import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class JwtTokenController {
  static final JwtTokenController _instance = JwtTokenController._privateConstructor();
  static JwtTokenController get instance => _instance;
  JwtTokenController._privateConstructor();

  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  // 저장소 키 상수
  static const String _keyAccessToken = 'access_token';
  static const String _keyRefreshToken = 'refresh_token';

  // --------------------------------------------------
  // 엑세스 토큰 반환
  // --------------------------------------------------
  Future<String?> getAccessToken() async {
    try {
      return await _secureStorage.read(key: _keyAccessToken);
    } catch (e) {
      debugPrint('엑세스 토큰 조회 실패: $e');
      return null;
    }
  }

  // --------------------------------------------------
  // 리프레시 토큰 반환
  // --------------------------------------------------
  Future<String?> getRefreshToken() async {
    try {
      return await _secureStorage.read(key: _keyRefreshToken);
    } catch (e) {
      debugPrint('리프레시 토큰 조회 실패: $e');
      return null;
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
  // 리프레시 토큰으로 엑세스 토큰 갱신
  // --------------------------------------------------
  Future<bool> _refreshAccessToken() async {
    try {
      final refreshToken = await getRefreshToken();
      if (refreshToken == null) return false;

      // TODO: 실제 API 호출로 리프레시 토큰을 사용하여 새 엑세스 토큰 요청
      // 예시 코드:
      // final response = await http.post(
      //   Uri.parse('your_refresh_endpoint'),
      //   headers: {'Authorization': 'Bearer $refreshToken'},
      // );
      //
      // if (response.statusCode == 200) {
      //   final newAccessToken = jsonDecode(response.body)['access_token'];
      //   await saveAccessToken(newAccessToken);
      //   return true;
      // }

      // 임시로 false 반환 (실제 구현 시 위 주석 코드 사용)
      return false;
    } catch (e) {
      debugPrint('엑세스 토큰 갱신 실패: $e');
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
