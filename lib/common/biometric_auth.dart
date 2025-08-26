import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BioAuth {
  static final BioAuth _instance = BioAuth._privateConstructor();
  factory BioAuth() => _instance;
  BioAuth._privateConstructor();
  //
  static const String statusEnabled = 'enabled';
  static const String statusDisabled = 'disabled';
  static const String statusNotSet = 'notSet';
  final LocalAuthentication _localAuth = LocalAuthentication();

  // 저장소 키 상수
  final String _keyUseBioAuth = 'use_bio_auth';

  // --------------------------------------------------
  // 바이오인증 가능 여부 확인 (하드웨어 지원 여부, 바이오인증 사용 가능 여부)
  // --------------------------------------------------
  Future<bool> isBioAvailable() async {
    try {
      final bool isDeviceSupported = await _localAuth.isDeviceSupported();
      if (!isDeviceSupported) return false;
      final bool canCheckBiometrics = await _localAuth.canCheckBiometrics;
      return canCheckBiometrics;
    } on PlatformException catch (e) {
      debugPrint('바이오 인증 가능 여부 확인 실패: $e');
      return false;
    }
  }

  // --------------------------------------------------
  // 바이오인증 사용 설정
  // --------------------------------------------------
  Future<bool> enableBioAuth() async {
    try {
      final bool isAvailable = await isBioAvailable();
      if (!isAvailable) return false;
      final bool didAuthenticate = await _localAuth.authenticate(
        localizedReason: '바이오인증을 활성화하려면 인증해주세요',
        options: const AuthenticationOptions(stickyAuth: true, biometricOnly: true),
      );
      if (didAuthenticate) {
        await saveUseBioAuth(statusEnabled);
        return true;
      }
      return false;
    } on PlatformException catch (e) {
      debugPrint('바이오 인증 사용 설정 실패: $e');
      return false;
    }
  }

  // --------------------------------------------------
  // 바이오인증 사용 해제
  // --------------------------------------------------
  Future<bool> disableBioAuth() async {
    try {
      await saveUseBioAuth(statusDisabled);
      return true;
    } catch (e) {
      debugPrint('바이오 인증 사용 해제 실패: $e');
      return false;
    }
  }

  // --------------------------------------------------
  // 바이오인증으로 사용자 인증 실행
  // --------------------------------------------------
  Future<bool> runBioAuth() async {
    try {
      final String status = await loadUseBioAuth();
      if (status != statusEnabled) return false;
      final bool didAuthenticate = await _localAuth.authenticate(
        localizedReason: '사용자 인증을 위해 바이오인증을 사용해주세요',
        options: const AuthenticationOptions(stickyAuth: true, biometricOnly: true),
      );
      return didAuthenticate;
    } on PlatformException catch (e) {
      debugPrint('바이오 인증 실행 실패: $e');
      return false;
    }
  }

  // --------------------------------------------------
  // 바이오 인증 사용 설정 Save / Load
  // --------------------------------------------------
  Future<void> saveUseBioAuth(String status) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_keyUseBioAuth, status);
    } catch (e) {
      debugPrint('바이오 인증 사용 설정 저장 실패: $e');
      rethrow;
    }
  }

  Future<String> loadUseBioAuth() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString(_keyUseBioAuth) ?? statusNotSet;
    } catch (e) {
      debugPrint('바이오 인증 사용 설정 로드 실패: $e');
      rethrow;
    }
  }
}
