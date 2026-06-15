import 'package:flutter/foundation.dart';

abstract class ApiConfig {
  static String get baseUrl {
    if (kIsWeb) {
      return 'http://127.0.0.1:3000';
    }
    return 'http://10.0.2.2:3000';
  }
}