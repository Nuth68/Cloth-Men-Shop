import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class CacheService {
  static const _tokenKey = 'auth_token';
  static const _onboardingKey = 'onboarding_complete';

  final FlutterSecureStorage _storage;

  CacheService()
      : _storage = const FlutterSecureStorage(
          aOptions: AndroidOptions(encryptedSharedPreferences: true),
        );

  Future<void> setToken(String token) async {
    await _storage.write(key: _tokenKey, value: token);
  }

  Future<String?> getToken() async {
    return _storage.read(key: _tokenKey);
  }

  Future<void> clearToken() async {
    await _storage.delete(key: _tokenKey);
  }

  Future<void> setOnboardingComplete() async {
    await _storage.write(key: _onboardingKey, value: 'true');
  }

  Future<bool> isOnboardingComplete() async {
    final val = await _storage.read(key: _onboardingKey);
    return val == 'true';
  }
}