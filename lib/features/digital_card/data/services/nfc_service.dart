// NFC Service
// Handles NFC card sharing using nfc_manager package

import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/foundation.dart' show debugPrint, kIsWeb;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nfc_manager/nfc_manager.dart';

import '../../domain/failures/card_design_failure.dart';

/// Data model for NFC card exchange
class NfcCardData {
  final String name;
  final String? phone;
  final String? email;
  final String? company;
  final String? jobTitle;
  final String? website;

  const NfcCardData({
    required this.name,
    this.phone,
    this.email,
    this.company,
    this.jobTitle,
    this.website,
  });

  Map<String, dynamic> toJson() => {
    'name': name,
    if (phone != null) 'phone': phone,
    if (email != null) 'email': email,
    if (company != null) 'company': company,
    if (jobTitle != null) 'jobTitle': jobTitle,
    if (website != null) 'website': website,
  };

  factory NfcCardData.fromJson(Map<String, dynamic> json) => NfcCardData(
    name: json['name'] as String,
    phone: json['phone'] as String?,
    email: json['email'] as String?,
    company: json['company'] as String?,
    jobTitle: json['jobTitle'] as String?,
    website: json['website'] as String?,
  );

  /// Build a vCard string for NDEF MIME record
  String toVCard() {
    final sb = StringBuffer();
    sb.writeln('BEGIN:VCARD');
    sb.writeln('VERSION:3.0');
    sb.writeln('FN:$name');
    if (phone != null && phone!.isNotEmpty) sb.writeln('TEL:$phone');
    if (email != null && email!.isNotEmpty) sb.writeln('EMAIL:$email');
    if (company != null && company!.isNotEmpty) sb.writeln('ORG:$company');
    if (jobTitle != null && jobTitle!.isNotEmpty) sb.writeln('TITLE:$jobTitle');
    if (website != null && website!.isNotEmpty) sb.writeln('URL:$website');
    sb.writeln('END:VCARD');
    return sb.toString();
  }
}

/// NFC session state
enum NfcSessionState { idle, waitingForTag, writing, success, error }

/// STUB-01 FIX: Implemented NFC service using nfc_manager package
///
/// Architecture:
///  - WRITE: encodes card data as an NDEF vCard (text/vcard MIME) record
///  - READ: decodes incoming NDEF records and extracts vCard or JSON payload
///  - iOS: NFC write requires reading entitlement (Core NFC) — write is
///    available on iOS 13+. Note the entitlement must be added in Xcode.
///  - Android: Full NDEF read/write on Android 4.4+
class NfcService {
  bool _isSessionActive = false;

  /// Check if NFC is available on this device/platform
  Future<bool> isNfcAvailable() async {
    if (kIsWeb) return false;
    try {
      return await NfcManager.instance.isAvailable();
    } catch (e) {
      debugPrint('NFC availability check failed: $e');
      return false;
    }
  }

  /// Start an NFC sharing session — writes vCard NDEF record to tapped tag.
  ///
  /// Throws [CardDesignFailure] if NFC is not available or session fails.
  Future<void> startSharing({
    required String name,
    String? phone,
    String? email,
    String? company,
    String? jobTitle,
    String? website,
    Duration timeout = const Duration(seconds: 30),
  }) async {
    final available = await isNfcAvailable();
    if (!available) {
      throw const CardDesignFailure(
        type: CardDesignFailureType.unknown,
        message: 'NFC is not available on this device',
      );
    }

    _isSessionActive = true;

    try {
      final cardData = NfcCardData(
        name: name,
        phone: phone,
        email: email,
        company: company,
        jobTitle: jobTitle,
        website: website,
      );

      final vCardString = cardData.toVCard();
      final vCardBytes = Uint8List.fromList(utf8.encode(vCardString));

      // Build NDEF MIME record: text/vcard
      final mimeType = Uint8List.fromList(utf8.encode('text/vcard'));
      final ndefRecord = NdefRecord(
        typeNameFormat: NdefTypeNameFormat.media,
        type: mimeType,
        identifier: Uint8List(0),
        payload: vCardBytes,
      );
      final ndefMessage = NdefMessage([ndefRecord]);

      await NfcManager.instance.startSession(
        onDiscovered: (NfcTag tag) async {
          try {
            final ndef = Ndef.from(tag);
            if (ndef == null || !ndef.isWritable) {
              throw const CardDesignFailure(
                type: CardDesignFailureType.unknown,
                message: 'This NFC tag is not writable',
              );
            }
            await ndef.write(ndefMessage);
            debugPrint('NFC card written successfully');
          } catch (e) {
            debugPrint('NFC write error: $e');
            rethrow;
          } finally {
            await stopSession();
          }
        },
        onError: (NfcError error) async {
          debugPrint('NFC session error: $error');
          _isSessionActive = false;
        },
      );
    } catch (e) {
      _isSessionActive = false;
      if (e is CardDesignFailure) rethrow;
      throw CardDesignFailure(
        type: CardDesignFailureType.unknown,
        message: 'NFC sharing failed: $e',
      );
    }
  }

  /// Start an NFC receiving session — reads NDEF record from tapped tag.
  ///
  /// Returns [NfcCardData] on success, null if no parseable data found.
  Future<NfcCardData?> startReceiving({
    Duration timeout = const Duration(seconds: 30),
  }) async {
    final available = await isNfcAvailable();
    if (!available) {
      throw const CardDesignFailure(
        type: CardDesignFailureType.unknown,
        message: 'NFC is not available on this device',
      );
    }

    _isSessionActive = true;
    NfcCardData? result;

    try {
      await NfcManager.instance.startSession(
        onDiscovered: (NfcTag tag) async {
          try {
            final ndef = Ndef.from(tag);
            if (ndef != null) {
              final message = await ndef.read();
              for (final record in message.records) {
                // Try MIME type text/vcard
                if (record.typeNameFormat == NdefTypeNameFormat.media) {
                  final payload = utf8.decode(record.payload);
                  result = _parseVCard(payload);
                  if (result != null) break;
                }
                // Try JSON payload (legacy format)
                if (record.typeNameFormat == NdefTypeNameFormat.nfcWellknown) {
                  try {
                    final jsonStr = utf8.decode(record.payload.sublist(3));
                    final jsonData =
                        jsonDecode(jsonStr) as Map<String, dynamic>;
                    result = NfcCardData.fromJson(jsonData);
                    break;
                  } catch (_) {
                    // Not a JSON payload, continue
                  }
                }
              }
            }
          } catch (e) {
            debugPrint('NFC read error: $e');
          } finally {
            await stopSession();
          }
        },
        onError: (NfcError error) async {
          debugPrint('NFC session error: $error');
          _isSessionActive = false;
        },
      );
    } catch (e) {
      _isSessionActive = false;
      if (e is CardDesignFailure) rethrow;
      throw CardDesignFailure(
        type: CardDesignFailureType.unknown,
        message: 'NFC receiving failed: $e',
      );
    }

    return result;
  }

  /// Stop the active NFC session
  Future<void> stopSession() async {
    if (_isSessionActive) {
      try {
        await NfcManager.instance.stopSession();
      } catch (e) {
        debugPrint('NFC stop session error: $e');
      } finally {
        _isSessionActive = false;
      }
    }
  }

  /// Parse a vCard string into NfcCardData
  NfcCardData? _parseVCard(String vcard) {
    try {
      if (!vcard.contains('BEGIN:VCARD')) return null;

      String? name;
      String? phone;
      String? email;
      String? company;
      String? jobTitle;
      String? website;

      for (final line in vcard.split('\n')) {
        final trimmed = line.trim();
        if (trimmed.startsWith('FN:')) {
          name = trimmed.substring(3);
        } else if (trimmed.startsWith('TEL')) {
          phone = trimmed.contains(':') ? trimmed.split(':').last : null;
        } else if (trimmed.startsWith('EMAIL')) {
          email = trimmed.contains(':') ? trimmed.split(':').last : null;
        } else if (trimmed.startsWith('ORG:')) {
          company = trimmed.substring(4);
        } else if (trimmed.startsWith('TITLE:')) {
          jobTitle = trimmed.substring(6);
        } else if (trimmed.startsWith('URL:')) {
          website = trimmed.substring(4);
        }
      }

      if (name == null || name.isEmpty) return null;

      return NfcCardData(
        name: name,
        phone: phone,
        email: email,
        company: company,
        jobTitle: jobTitle,
        website: website,
      );
    } catch (e) {
      debugPrint('vCard parse error: $e');
      return null;
    }
  }
}

/// Provider for NfcService
final nfcServiceProvider = Provider<NfcService>((ref) => NfcService());
