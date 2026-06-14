import 'dart:convert';
import 'package:http/http.dart' as http;
import '../local/cache_service.dart';

class GraphqlResponse<T> {
  final T? data;
  final List<GraphqlError>? errors;

  const GraphqlResponse({this.data, this.errors});
}

class GraphqlError {
  final String message;
  final List<dynamic>? locations;
  final List<dynamic>? path;

  const GraphqlError({required this.message, this.locations, this.path});
}

class GraphqlService {
  final String baseUrl;
  final http.Client _client;
  final CacheService _cache;
  final Duration _timeout;

  GraphqlService({
    required this.baseUrl,
    required CacheService cache,
    Duration timeout = const Duration(seconds: 10),
  })  : _client = http.Client(),
        _cache = cache,
        _timeout = timeout;

  Future<Map<String, String>> _headers() async {
    final token = await _cache.getToken();
    return {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  Future<GraphqlResponse<Map<String, dynamic>>> query(
    String query, {
    Map<String, dynamic>? variables,
  }) async {
    return _request(query, variables: variables);
  }

  Future<GraphqlResponse<Map<String, dynamic>>> mutate(
    String mutation, {
    Map<String, dynamic>? variables,
  }) async {
    return _request(mutation, variables: variables);
  }

  Future<GraphqlResponse<Map<String, dynamic>>> _request(
    String document, {
    Map<String, dynamic>? variables,
  }) async {
    final uri = Uri.parse('$baseUrl/graphql');
    final response = await _client
        .post(
          uri,
          headers: await _headers(),
          body: jsonEncode({
            'query': document,
            if (variables != null) 'variables': variables,
          }),
        )
        .timeout(_timeout);

    if (response.statusCode >= 200 && response.statusCode < 300) {
      final body = jsonDecode(response.body) as Map<String, dynamic>;
      final data = body['data'] as Map<String, dynamic>?;
      final errors = (body['errors'] as List<dynamic>?)
          ?.map((e) => GraphqlError(
                message: e['message'] as String,
                locations: e['locations'] as List<dynamic>?,
                path: e['path'] as List<dynamic>?,
              ))
          .toList();
      return GraphqlResponse(data: data, errors: errors);
    }

    throw GraphqlHttpException(response.statusCode, response.body);
  }

  void dispose() => _client.close();
}

class GraphqlHttpException implements Exception {
  final int statusCode;
  final String message;
  GraphqlHttpException(this.statusCode, this.message);

  @override
  String toString() => 'GraphqlHttpException($statusCode): $message';
}

class GraphqlTimeoutException implements Exception {
  final String message;
  GraphqlTimeoutException(this.message);

  @override
  String toString() => 'GraphqlTimeoutException: $message';
}