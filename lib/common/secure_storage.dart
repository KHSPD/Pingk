import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorage {
  SecureStorage._privateConstructor();
  static final SecureStorage _instance = SecureStorage._privateConstructor();
  factory SecureStorage() => _instance;
  //
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  final String _keyPassword = 'password';

  // --------------------------------------------------
  // 비밀번호 Save / Load / Delete
  // --------------------------------------------------
  Future<bool> savePassword({required String password}) async {
    try {
      await _storage.write(key: _keyPassword, value: password);
      return true;
    } catch (_) {
      return false;
    }
  }

  // ----- 비밀번호 Load -----
  Future<String> loadPassword() async {
    try {
      String? password = await _storage.read(key: _keyPassword);
      return password ?? '';
    } catch (_) {
      return '';
    }
  }

  // ----- 비밀번호 Delete -----
  Future<bool> deletePassword() async {
    try {
      await _storage.delete(key: _keyPassword);
      return true;
    } catch (_) {
      return false;
    }
  }
}
