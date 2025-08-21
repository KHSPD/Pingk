import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:pingk/common/constants.dart';

class SecureStorage {
  SecureStorage._privateConstructor();
  static final SecureStorage _instance = SecureStorage._privateConstructor();
  static SecureStorage get instance => _instance;

  // FlutterSecureStorage
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  // --------------------------------------------------
  // 로그인 정보 저장
  // --------------------------------------------------
  Future<void> saveLoginInfo({String? id, String? password, String? jwtToken}) async {
    try {
      if (id != null) {
        await _storage.write(key: 'id', value: id);
      }
      if (password != null) {
        await _storage.write(key: 'password', value: password);
      }
      if (jwtToken != null) {
        await _storage.write(key: 'jwtToken', value: jwtToken);
      }
    } catch (_) {
      rethrow;
    }
  }

  // --------------------------------------------------
  // 로그인 정보 조회
  // --------------------------------------------------
  Future<Map<String, String>> getLoginInfo() async {
    try {
      String? id = await _storage.read(key: 'id');
      String? password = await _storage.read(key: 'password');
      String? jwtToken = await _storage.read(key: 'jwtToken');
      return {'id': id ?? '', 'password': password ?? '', 'jwtToken': jwtToken ?? ''};
    } catch (_) {
      rethrow;
    }
  }

  // --------------------------------------------------
  // 로그인 정보 삭제
  // --------------------------------------------------
  Future<void> deleteLoginInfo() async {
    try {
      await _storage.delete(key: 'id');
      await _storage.delete(key: 'password');
      await _storage.delete(key: 'jwtToken');
    } catch (_) {
      rethrow;
    }
  }

  // --------------------------------------------------
  // 바이오 인증 사용 설정 저장
  // --------------------------------------------------
  Future<void> saveBiometricStatus(BiometricStatus status) async {
    try {
      await _storage.write(key: 'biometric_status', value: status.stringValue);
    } catch (_) {
      rethrow;
    }
  }

  // --------------------------------------------------
  // 바이오 인증 사용 설정 조회
  // --------------------------------------------------
  Future<BiometricStatus> getBiometricStatus() async {
    try {
      String result = await _storage.read(key: 'biometric_status') ?? '';
      for (BiometricStatus status in BiometricStatus.values) {
        if (status.name == result) {
          return status;
        }
      }
      return BiometricStatus.notSet;
    } catch (_) {
      return BiometricStatus.notSet;
    }
  }
}
