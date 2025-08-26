import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class JwtTokenController {
  static final JwtTokenController _instance = JwtTokenController._privateConstructor();
  factory JwtTokenController() => _instance;
  JwtTokenController._privateConstructor();

  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  // 저장소 키 상수
  static const String _keyAccessToken = 'access_token';
  static const String _keyRefreshToken = 'refresh_token';

  // --------------------------------------------------
  // 엑세스 토큰 반환
  // --------------------------------------------------
  Future<String> loadAccessToken() async {
    try {
      String? token = await _secureStorage.read(key: _keyAccessToken);
      if (token == null || token.isEmpty) {
        return '';
      }
      return token;
    } catch (e) {
      debugPrint('엑세스 토큰 조회 실패: $e');
      return '';
    }
  }

  // --------------------------------------------------
  // 리프레시 토큰 반환
  // --------------------------------------------------
  Future<String> loadRefreshToken() async {
    try {
      String? token = await _secureStorage.read(key: _keyRefreshToken);
      if (token == null || token.isEmpty) {
        return '';
      }
      return token;
    } catch (e) {
      debugPrint('리프레시 토큰 조회 실패: $e');
      return '';
    }
  }

  // --------------------------------------------------
  // 토큰 저장
  // --------------------------------------------------
  Future<bool> saveTokens({required String accessToken, required String refreshToken}) async {
    try {
      await _secureStorage.write(key: _keyAccessToken, value: accessToken);
      await _secureStorage.write(key: _keyRefreshToken, value: refreshToken);
      return true;
    } catch (e) {
      debugPrint('토큰 저장 실패: $e');
      return false;
    }
  }

  Future<bool> saveAccessToken(String accessToken) async {
    try {
      await _secureStorage.write(key: _keyAccessToken, value: accessToken);
      return true;
    } catch (e) {
      debugPrint('엑세스 토큰 저장 실패: $e');
      return false;
    }
  }

  // --------------------------------------------------
  // 모든 토큰 삭제
  // --------------------------------------------------
  Future<bool> removeAllTokens() async {
    try {
      await _secureStorage.delete(key: _keyAccessToken);
      await _secureStorage.delete(key: _keyRefreshToken);
      return true;
    } catch (e) {
      debugPrint('토큰 삭제 실패: $e');
      return false;
    }
  }
}
