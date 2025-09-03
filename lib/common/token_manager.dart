import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pingk/common/constants.dart';
import 'local_storage.dart';

class JwtManager {
  JwtManager._privateConstructor();
  static final JwtManager _instance = JwtManager._privateConstructor();
  factory JwtManager() => _instance;

  // --------------------------------------------------
  // JWT 토큰에서 만료 시간을 추출
  // --------------------------------------------------
  Map<String, dynamic>? _decodeToken(String token) {
    try {
      final parts = token.split('.');
      if (parts.length != 3) {
        return null;
      }
      final payload = parts[1];
      final normalized = base64Url.normalize(payload);
      final resp = utf8.decode(base64Url.decode(normalized));
      final payloadMap = json.decode(resp);
      return payloadMap;
    } catch (e) {
      debugPrint('토큰 디코딩 실패: $e');
      return null;
    }
  }

  // --------------------------------------------------
  // 토큰의 만료 시간을 확인
  // --------------------------------------------------
  bool _isTokenExpired(String token) {
    try {
      final payload = _decodeToken(token);
      if (payload == null) {
        return true;
      }
      final exp = payload['exp'];
      if (exp == null) {
        return true;
      }
      final currentTime = DateTime.now().millisecondsSinceEpoch ~/ 1000;
      final expiryTime = exp as int;
      return currentTime >= (expiryTime - (5 * 60)); // 5분 여유시간
    } catch (e) {
      debugPrint('토큰 만료 확인 실패: $e');
      return true;
    }
  }

  // --------------------------------------------------
  // 리프레시 토큰을 사용하여 새로운 액세스 토큰을 요청
  // --------------------------------------------------
  Future<String?> _refreshAccessToken(String refreshToken) async {
    try {
      final String apiUrl = '$apiServerURL/api/auth/refresh';
      final response = await http.post(Uri.parse(apiUrl), headers: {'Content-Type': 'application/json', 'X-Refresh-Token': refreshToken});
      debugPrint('========== API Response ==========\nURL: $apiUrl\nStatus: ${response.statusCode}\nBody: ${response.body}');
      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);
        if (body['code'] == '200') {
          final String accessToken = body['result']['accessToken'];
          await LocalStorage().saveAccessToken(accessToken);
          return accessToken;
        }
      }
      debugPrint('토큰 갱신 실패');
      return null;
    } catch (e) {
      debugPrint('Exception: ${e.toString()}');
      return null;
    }
  }

  // --------------------------------------------------
  // 리프레시 토큰 만료 여부 확인
  // --------------------------------------------------
  Future<bool?> isValidRefreshToken(String refreshToken) async {
    try {
      final String apiUrl = '$apiServerURL/api/auth/validate-token';
      final response = await http.post(Uri.parse(apiUrl), headers: {'Content-Type': 'application/json', 'X-Refresh-Token': refreshToken});
      debugPrint('========== API Response: $apiUrl =====\nStatus: ${response.statusCode}\nBody: ${response.body}');
      if (response.statusCode == 200) {
        final Map<String, dynamic> body = jsonDecode(response.body);
        if (body['code'] == '200') {
          final String accessToken = body['result']['accessToken'];
          await LocalStorage().saveAccessToken(accessToken);
          return true;
        } else {
          return false;
        }
      } else {
        return null;
      }
    } catch (e) {
      debugPrint('Exception: ${e.toString()}');
      return null;
    }
  }

  // --------------------------------------------------
  // 유효한 토큰 반환
  // --------------------------------------------------
  Future<String?> getAccessToken() async {
    try {
      // 저장된 액세스 토큰 로드
      final accessToken = await LocalStorage().loadAccessToken();
      if (accessToken.isEmpty) {
        debugPrint('저장된 액세스 토큰 없음.');
        return null;
      }

      // 토큰 만료 여부 확인
      if (!_isTokenExpired(accessToken)) {
        return accessToken;
      }

      // 리프레시 토큰으로 갱신 시도
      debugPrint('액세스 토큰 만료. 갱신 시도.');
      final refreshToken = await LocalStorage().loadRefreshToken();
      if (refreshToken.isEmpty) {
        debugPrint('리프레시 토큰 없음.');
        return null;
      }

      final newAccessToken = await _refreshAccessToken(refreshToken);
      if (newAccessToken != null) {
        debugPrint('토큰 갱신 성공');
        return newAccessToken;
      } else {
        debugPrint('토큰 갱신 실패');
        return null;
      }
    } catch (e) {
      debugPrint('Exception: ${e.toString()}');
      return null;
    }
  }
}
