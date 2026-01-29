import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/app_config.dart';
import '../../features/auth/data/firebase_auth_service.dart';

class AzureApiService {
  final FirebaseAuthService _authService;
  final String _baseUrl = AppConfig.azureFunctionsBaseUrl;

  AzureApiService(this._authService);

  // Make authenticated request to Azure Functions
  Future<http.Response> authenticatedRequest({
    required String endpoint,
    required String method,
    Map<String, dynamic>? body,
  }) async {
    // Get Firebase ID token
    final token = await _authService.getIdToken();
    if (token == null) throw Exception('User not authenticated');

    final url = Uri.parse('$_baseUrl/$endpoint');
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token', // Send Firebase token
    };

    try {
      switch (method.toUpperCase()) {
        case 'GET':
          return await http.get(url, headers: headers);
        case 'POST':
          return await http.post(
            url,
            headers: headers,
            body: json.encode(body),
          );
        case 'PUT':
          return await http.put(url, headers: headers, body: json.encode(body));
        case 'DELETE':
          return await http.delete(url, headers: headers);
        default:
          throw Exception('Unsupported HTTP method');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  // Example: Get user contacts from Cosmos DB
  Future<List<dynamic>> getUserContacts() async {
    final response = await authenticatedRequest(
      endpoint: 'contacts',
      method: 'GET',
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load contacts: ${response.statusCode}');
    }
  }
}
