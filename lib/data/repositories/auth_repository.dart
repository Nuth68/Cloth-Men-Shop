import '../models/user_model.dart';
import '../datasources/remote/api_service.dart';
import '../datasources/local/cache_service.dart';

class AuthRepository {
  final ApiService _api;
  final CacheService _cache;

  AuthRepository(this._api, this._cache);

  Future<UserModel> login(String email, String password) async {
    final data = await _api.post('/auth/login', body: {'email': email, 'password': password});
    final user = UserModel.fromJson(data['user'] as Map<String, dynamic>);
    await _cache.setToken(data['token'] as String);
    return user;
  }

  Future<UserModel> register(String name, String email, String password) async {
    final data = await _api.post('/auth/register', body: {'name': name, 'email': email, 'password': password});
    final user = UserModel.fromJson(data['user'] as Map<String, dynamic>);
    await _cache.setToken(data['token'] as String);
    return user;
  }

  Future<void> logout() async {
    await _api.post('/auth/logout');
    await _cache.clearToken();
  }

  Future<bool> isLoggedIn() async {
    final token = await _cache.getToken();
    return token != null;
  }
}
