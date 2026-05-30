import 'package:shared_preferences/shared_preferences.dart';

class CacheService {
  static const _tokenKey = 'auth_token';
  static const _onboardingKey = 'onboarding_complete';

  Future<SharedPreferences> get _prefs => SharedPreferences.getInstance();

  Future<void> setToken(String token) async {
    final prefs = await _prefs;
    await prefs.setString(_tokenKey, token);
  }

  Future<String?> getToken() async {
    final prefs = await _prefs;
    return prefs.getString(_tokenKey);
  }

  Future<void> clearToken() async {
    final prefs = await _prefs;
    await prefs.remove(_tokenKey);
  }

  Future<void> setOnboardingComplete() async {
    final prefs = await _prefs;
    await prefs.setBool(_onboardingKey, true);
  }

  Future<bool> isOnboardingComplete() async {
    final prefs = await _prefs;
    return prefs.getBool(_onboardingKey) ?? false;
  }
}
