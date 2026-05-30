import 'dart:convert';
import 'package:http/http.dart' as http;
import '../local/cache_service.dart';

class ApiService {
  final String baseUrl;
  final http.Client _client;
  final CacheService _cache;

  ApiService({required this.baseUrl, required CacheService cache})
      : _client = http.Client(),
        _cache = cache;

  Future<Map<String, String>> _headers() async {
    final token = await _cache.getToken();
    return {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  Future<dynamic> get(String endpoint, {Map<String, dynamic>? queryParameters}) async {
    final uri = Uri.parse('$baseUrl$endpoint').replace(queryParameters: queryParameters?.map((k, v) => MapEntry(k, v.toString())));
    final response = await _client.get(uri, headers: await _headers());
    return _handleResponse(response);
  }

  Future<dynamic> post(String endpoint, {Map<String, dynamic>? body}) async {
    final uri = Uri.parse('$baseUrl$endpoint');
    final response = await _client.post(uri, headers: await _headers(), body: body != null ? jsonEncode(body) : null);
    return _handleResponse(response);
  }

  Future<dynamic> put(String endpoint, {Map<String, dynamic>? body}) async {
    final uri = Uri.parse('$baseUrl$endpoint');
    final response = await _client.put(uri, headers: await _headers(), body: body != null ? jsonEncode(body) : null);
    return _handleResponse(response);
  }

  Future<dynamic> delete(String endpoint) async {
    final uri = Uri.parse('$baseUrl$endpoint');
    final response = await _client.delete(uri, headers: await _headers());
    return _handleResponse(response);
  }

  dynamic _handleResponse(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return response.body.isNotEmpty ? jsonDecode(response.body) : null;
    }
    throw ApiException(response.statusCode, response.body);
  }

  void dispose() => _client.close();
}

class ApiException implements Exception {
  final int statusCode;
  final String message;
  ApiException(this.statusCode, this.message);

  @override
  String toString() => 'ApiException($statusCode): $message';
}
