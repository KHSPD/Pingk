import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pingk/common/constants.dart';

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

  // --------------------------------------------------
  // JWT 토큰 관련
  // --------------------------------------------------
  // ----- 액세스 토큰 저장 -----
  Future<void> saveAccessToken(String accessToken) async {
    try {
      await _storage.write(key: 'accessToken', value: accessToken);
    } catch (_) {
      debugPrint('액세스 토큰 저장 실패');
      rethrow;
    }
  }

  // ----- 리프레시 토큰 저장 -----
  Future<void> saveRefreshToken(String refreshToken) async {
    try {
      await _storage.write(key: 'refreshToken', value: refreshToken);
    } catch (_) {
      debugPrint('리프레시 토큰 저장 실패');
      rethrow;
    }
  }

  // ----- 액세스 토큰과 리프레시 토큰을 함께 저장 -----
  Future<void> saveTokens({required String accessToken, required String refreshToken}) async {
    try {
      await Future.wait([_storage.write(key: 'accessToken', value: accessToken), _storage.write(key: 'refreshToken', value: refreshToken)]);
    } catch (_) {
      debugPrint('토큰 저장 실패');
      rethrow;
    }
  }

  // ----- 액세스 토큰 로드 -----
  Future<String?> loadAccessToken() async {
    try {
      return await _storage.read(key: 'accessToken');
    } catch (_) {
      debugPrint('액세스 토큰 로드 실패');
      return null;
    }
  }

  // ----- 리프레시 토큰 로드 -----
  Future<String?> loadRefreshToken() async {
    try {
      return await _storage.read(key: 'refreshToken');
    } catch (_) {
      debugPrint('리프레시 토큰 로드 실패');
      return null;
    }
  }

  // ----- 모든 토큰 로드 -----
  Future<Map<String, String?>> loadAllTokens() async {
    try {
      String? accessToken = await _storage.read(key: 'accessToken');
      String? refreshToken = await _storage.read(key: 'refreshToken');

      return {'accessToken': accessToken, 'refreshToken': refreshToken};
    } catch (_) {
      debugPrint('토큰 로드 실패');
      return {'accessToken': null, 'refreshToken': null};
    }
  }

  // ----- 액세스 토큰 삭제 -----
  Future<void> deleteAccessToken() async {
    try {
      await _storage.delete(key: 'accessToken');
    } catch (_) {
      debugPrint('액세스 토큰 삭제 실패');
      rethrow;
    }
  }

  // ----- 리프레시 토큰 삭제 -----
  Future<void> deleteRefreshToken() async {
    try {
      await _storage.delete(key: 'refreshToken');
    } catch (_) {
      debugPrint('리프레시 토큰 삭제 실패');
      rethrow;
    }
  }

  // ----- 모든 토큰 삭제 -----
  Future<void> deleteAllTokens() async {
    try {
      await Future.wait([_storage.delete(key: 'accessToken'), _storage.delete(key: 'refreshToken')]);
    } catch (_) {
      debugPrint('토큰 삭제 실패');
      rethrow;
    }
  }

  // ----- 액세스 토큰 존재 여부 확인 -----
  Future<bool> hasAccessToken() async {
    try {
      final token = await _storage.read(key: 'accessToken');
      return token != null && token.isNotEmpty;
    } catch (_) {
      return false;
    }
  }

  // ----- 리프레시 토큰 존재 여부 확인 -----
  Future<bool> hasRefreshToken() async {
    try {
      final token = await _storage.read(key: 'refreshToken');
      return token != null && token.isNotEmpty;
    } catch (_) {
      return false;
    }
  }

  // --------------------------------------------------
  // 바이오 인증 사용 관련
  // --------------------------------------------------
  // ----- 바이오 인증 사용 설정 Save -----
  Future<void> saveBiometricStatus(String status) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('useBiometricAuth', status);
    } catch (_) {
      debugPrint('바이오 인증 사용 설정 저장 실패');
      rethrow;
    }
  }

  // ----- 바이오 인증 사용 설정 Load -----
  Future<String> loadBiometricStatus() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString('useBiometricAuth') ?? statusNotSet;
    } catch (_) {
      return statusNotSet;
    }
  }
}
