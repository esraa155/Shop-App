import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class LocaleStorage {
  static const _key = 'app_locale';
  static const _storage = FlutterSecureStorage();
  
  static Future<void> write(String code) async {
    await _storage.write(key: _key, value: code);
  }
  
  static Future<String?> read() async {
    return await _storage.read(key: _key);
  }
}

