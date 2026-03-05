import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:googleapis/drive/v3.dart' as drive;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_wallet/features/auth/domain/repositories/auth_repository.dart';
import 'package:mobile_wallet/features/auth/data/repositories/auth_repository_impl.dart';

/// Service for interacting with Google Drive API.
///
/// Handles folder creation, file uploads, and listing backups.
class GoogleDriveService {
  final AuthRepository _authRepository;

  GoogleDriveService(this._authRepository);

  /// Gets an authenticated HTTP client for Google API requests.
  Future<http.Client?> _getAuthenticatedClient() async {
    final headers = await _authRepository.googleAuthHeaders;
    if (headers == null) return null;
    return _AuthenticatedClient(headers);
  }

  /// Finds or creates the backup folder in Google Drive.
  Future<String?> findOrCreateBackupFolder(String folderName) async {
    final client = await _getAuthenticatedClient();
    if (client == null) return null;

    final api = drive.DriveApi(client);

    try {
      // Search for the folder
      final query =
          "name = '$folderName' and mimeType = 'application/vnd.google-apps.folder' and trashed = false";
      final folderList = await api.files.list(q: query, spaces: 'drive');

      if (folderList.files != null && folderList.files!.isNotEmpty) {
        return folderList.files!.first.id;
      }

      // Create new folder
      final folder = drive.File()
        ..name = folderName
        ..mimeType = 'application/vnd.google-apps.folder';

      final createdFolder = await api.files.create(folder);
      return createdFolder.id;
    } catch (e) {
      print('[GoogleDriveService] Error finding/creating folder: $e');
      return null;
    } finally {
      client.close();
    }
  }

  /// Uploads a backup file to the specified folder.
  Future<String?> uploadBackupFile({
    required String folderId,
    required String filename,
    required String content,
  }) async {
    final client = await _getAuthenticatedClient();
    if (client == null) return null;

    final api = drive.DriveApi(client);

    try {
      final fileMetadata = drive.File()
        ..name = filename
        ..parents = [folderId]
        ..mimeType = 'application/json';

      final media = drive.Media(
        Stream.value(utf8.encode(content)),
        content.length,
      );

      final uploadedFile = await api.files.create(
        fileMetadata,
        uploadMedia: media,
      );
      return uploadedFile.id;
    } catch (e) {
      print('[GoogleDriveService] Error uploading backup: $e');
      return null;
    } finally {
      client.close();
    }
  }

  /// Lists all backup files in the backup folder.
  Future<List<drive.File>> listBackups(String folderId) async {
    final client = await _getAuthenticatedClient();
    if (client == null) return [];

    final api = drive.DriveApi(client);

    try {
      final query = "'$folderId' in parents and trashed = false";
      final fileList = await api.files.list(
        q: query,
        spaces: 'drive',
        orderBy: 'createdTime desc',
        $fields: 'files(id, name, createdTime, size)',
      );

      return fileList.files ?? [];
    } catch (e) {
      print('[GoogleDriveService] Error listing backups: $e');
      return [];
    } finally {
      client.close();
    }
  }

  /// Downloads a backup file's content.
  Future<String?> downloadBackup(String fileId) async {
    final client = await _getAuthenticatedClient();
    if (client == null) return null;

    final api = drive.DriveApi(client);

    try {
      final response =
          await api.files.get(
                fileId,
                downloadOptions: drive.DownloadOptions.fullMedia,
              )
              as drive.Media;

      final List<int> data = [];
      await for (final chunk in response.stream) {
        data.addAll(chunk);
      }

      return utf8.decode(data);
    } catch (e) {
      print('[GoogleDriveService] Error downloading backup: $e');
      return null;
    } finally {
      client.close();
    }
  }
}

/// A simple authenticated HTTP client that adds auth headers to every request.
class _AuthenticatedClient extends http.BaseClient {
  final Map<String, String> _headers;
  final http.Client _inner = http.Client();

  _AuthenticatedClient(this._headers);

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) {
    request.headers.addAll(_headers);
    return _inner.send(request);
  }

  @override
  void close() {
    _inner.close();
    super.close();
  }
}

/// Provider for GoogleDriveService
final googleDriveServiceProvider = Provider<GoogleDriveService>((ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  return GoogleDriveService(authRepository);
});
