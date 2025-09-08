import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalStorage {
  LocalStorage._privateConstructor();
  static final LocalStorage _instance = LocalStorage._privateConstructor();
  factory LocalStorage() => _instance;
  //
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  // 저장소 키 상수
  final String _keyPassword = 'password';
  final String _keyAccessToken = 'access_token';
  final String _keyRefreshToken = 'refresh_token';
  final String _keyUseBioAuth = 'use_bio_auth';
  final String _keyFavoriteItem = 'favorite_item';

  // --------------------------------------------------
  // 비밀번호 - Save / Load
  // --------------------------------------------------
  Future<bool> savePassword(String? password) async {
    try {
      if (password != null) {
        await _secureStorage.write(key: _keyPassword, value: password);
      } else {
        await _secureStorage.delete(key: _keyPassword);
      }
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<String> loadPassword() async {
    try {
      String? password = await _secureStorage.read(key: _keyPassword);
      return password ?? '';
    } catch (_) {
      return '';
    }
  }

  // --------------------------------------------------
  // JWT Token - Save / Load
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

  Future<bool> saveAccessToken(String? token) async {
    try {
      if (token != null) {
        await _secureStorage.write(key: _keyAccessToken, value: token);
      } else {
        await _secureStorage.delete(key: _keyAccessToken);
      }
      return true;
    } catch (e) {
      debugPrint('엑세스 토큰 저장 실패: $e');
      return false;
    }
  }

  Future<bool> saveRefreshToken(String? token) async {
    try {
      if (token != null) {
        await _secureStorage.write(key: _keyRefreshToken, value: token);
      } else {
        await _secureStorage.delete(key: _keyRefreshToken);
      }
      return true;
    } catch (e) {
      debugPrint('토큰 저장 실패: $e');
      return false;
    }
  }

  // --------------------------------------------------
  // 바이오 인증 사용 설정 - Save / Load
  // --------------------------------------------------
  Future<bool> saveUseBioAuth(bool? status) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      if (status == null) {
        await prefs.remove(_keyUseBioAuth);
      } else {
        await prefs.setBool(_keyUseBioAuth, status);
      }
      return true;
    } catch (e) {
      debugPrint('바이오 인증 사용 설정 저장 실패: $e');
      return false;
    }
  }

  Future<bool?> loadUseBioAuth() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getBool(_keyUseBioAuth);
    } catch (e) {
      debugPrint('바이오 인증 사용 설정 로드 실패: $e');
      return null;
    }
  }

  // --------------------------------------------------
  // 저장소의 모든 데이터 삭제
  // --------------------------------------------------
  Future<void> clearAll() async {
    await _secureStorage.deleteAll();
    await SharedPreferences.getInstance().then((prefs) => prefs.clear());
  }
}
