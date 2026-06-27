import 'package:flutter/foundation.dart';

abstract class ApiConfig {
  static String get baseUrl => baseUrls.first;

  static List<String> get baseUrls {
    if (kIsWeb) {
      return ["http://127.0.0.1:3002"];
    }
    if (defaultTargetPlatform == TargetPlatform.android) {
      return ["http://10.0.2.2:3002"];
    }
    return ["http://127.0.0.1:3002"];
  }
}
