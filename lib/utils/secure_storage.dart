import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorage {
  static FlutterSecureStorage _preferences = FlutterSecureStorage();

  static Future<String?> getString(String key, {String defValue = ''}) {
    return _preferences.read(key: key);
  }

  static Future<Map<String, String>?> getAll() {
    return _preferences.readAll();
  }

  static Future<void> putString(String key, String value) {
    return _preferences.write(key: key, value: value);
  }

  static Future<void> deleteString(String key, String value) {
    return _preferences.delete(key: key);
  }

  static Future<void> deleteAll() {
    return _preferences.deleteAll();
  }
}
