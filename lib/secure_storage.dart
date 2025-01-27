import 'package:flutter_secure_storage/flutter_secure_storage.dart';
class SecureStorage {
  static final _storage = FlutterSecureStorage();

  // Save token
  static Future<void> saveToken(String token) async {
    await _storage.write(key: 'authToken', value: token);
  }

  // Load token
  static Future<String?> loadToken() async {
    return await _storage.read(key: 'authToken');
  }

  // Delete token (on logout)
  static Future<void> deleteToken() async {
    await _storage.delete(key: 'authToken');
  }
}