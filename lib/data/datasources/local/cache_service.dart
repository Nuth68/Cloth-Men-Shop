import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CacheService {
  static const _tokenKey = 'auth_token';
  static const _onboardingKey = 'onboarding_complete';

  final FlutterSecureStorage? _storage;

  CacheService()
      : _storage = kIsWeb
            ? null
            : const FlutterSecureStorage(
                aOptions: AndroidOptions(encryptedSharedPreferences: true),
              );

  Future<void> setToken(String token) async {
    if (kIsWeb) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_tokenKey, token);
    } else {
      await _storage!.write(key: _tokenKey, value: token);
    }
  }

  Future<String?> getToken() async {
    if (kIsWeb) {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString(_tokenKey);
    }
    return _storage!.read(key: _tokenKey);
  }

  Future<void> clearToken() async {
    if (kIsWeb) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_tokenKey);
    } else {
      await _storage!.delete(key: _tokenKey);
    }
  }

  Future<void> setOnboardingComplete() async {
    if (kIsWeb) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_onboardingKey, 'true');
    } else {
      await _storage!.write(key: _onboardingKey, value: 'true');
    }
  }

  Future<bool> isOnboardingComplete() async {
    if (kIsWeb) {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString(_onboardingKey) == 'true';
    }
    final val = await _storage!.read(key: _onboardingKey);
    return val == 'true';
  }
}