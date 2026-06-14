import 'package:flutter/foundation.dart';
import '../models/user_model.dart';
import '../datasources/remote/graphql_service.dart';
import '../datasources/local/cache_service.dart';

class AuthRepository {
  final GraphqlService _gql;
  final CacheService _cache;

  AuthRepository(this._gql, this._cache);

  Future<UserModel> login(String email, String password) async {
    const mutation = '''
      mutation Login(\$email: String!, \$password: String!) {
        login(loginInput: { email: \$email, password: \$password }) {
          token
          user { id name email phone avatarUrl }
        }
      }
    ''';
    final res = await _gql.mutate(mutation, variables: {
      'email': email,
      'password': password,
    });
    _checkErrors(res);
    final data = res.data!['login'] as Map<String, dynamic>;
    final token = data['token'] as String;
    debugPrint('AuthRepo: storing token: ${token.substring(0, 20)}...');
    await _cache.setToken(token);
    final stored = await _cache.getToken();
    debugPrint('AuthRepo: token stored: ${stored != null}');
    return UserModel.fromJson(data['user'] as Map<String, dynamic>);
  }

  Future<UserModel> register(String name, String email, String password) async {
    const mutation = '''
      mutation Register(\$name: String!, \$email: String!, \$password: String!) {
        register(createUserInput: { name: \$name, email: \$email, password: \$password }) {
          token
          user { id name email phone avatarUrl }
        }
      }
    ''';
    final res = await _gql.mutate(mutation, variables: {
      'name': name,
      'email': email,
      'password': password,
    });
    _checkErrors(res);
    final data = res.data!['register'] as Map<String, dynamic>;
    await _cache.setToken(data['token'] as String);
    return UserModel.fromJson(data['user'] as Map<String, dynamic>);
  }

  Future<UserModel> getCurrentUser() async {
    const query = '''
      query Me {
        me { id name email phone avatarUrl }
      }
    ''';
    final res = await _gql.query(query);
    _checkErrors(res);
    return UserModel.fromJson(res.data!['me'] as Map<String, dynamic>);
  }

  Future<void> logout() async {
    await _cache.clearToken();
  }

  Future<bool> isLoggedIn() async {
    final token = await _cache.getToken();
    return token != null;
  }

  void _checkErrors(GraphqlResponse res) {
    if (res.errors != null && res.errors!.isNotEmpty) {
      final msgs = res.errors!.map((e) => e.message).join('; ');
      throw AuthGraphqlException(msgs);
    }
    if (res.data == null) {
      throw AuthGraphqlException('No data returned');
    }
  }
}

class AuthGraphqlException implements Exception {
  final String message;
  AuthGraphqlException(this.message);

  @override
  String toString() => message;
}