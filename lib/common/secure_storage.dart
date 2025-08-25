import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorage {
  SecureStorage._privateConstructor();
  static final SecureStorage _instance = SecureStorage._privateConstructor();
  static SecureStorage get instance => _instance;
  //
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  // --------------------------------------------------
  // 로그인 정보 관련
  // --------------------------------------------------
  // ----- 로그인 정보 Save -----
  Future<void> saveLoginInfo({String? id, String? password}) async {
    try {
      if (id != null) {
        await _storage.write(key: 'id', value: id);
      }
      if (password != null) {
        await _storage.write(key: 'password', value: password);
      }
    } catch (_) {
      rethrow;
    }
  }

  // ----- 로그인 정보 Load -----
  Future<Map<String, String>> loadLoginInfo() async {
    try {
      String? id = await _storage.read(key: 'id');
      String? password = await _storage.read(key: 'password');
      return {'id': id ?? '', 'password': password ?? ''};
    } catch (_) {
      rethrow;
    }
  }

  // ----- 로그인 정보 Delete -----
  Future<void> deleteLoginInfo() async {
    try {
      await _storage.delete(key: 'id');
      await _storage.delete(key: 'password');
    } catch (_) {
      rethrow;
    }
  }
}
