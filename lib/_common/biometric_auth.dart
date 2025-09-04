import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'package:pingk/_common/local_storage.dart';

class BioAuth {
  static final BioAuth _instance = BioAuth._privateConstructor();
  factory BioAuth() => _instance;
  BioAuth._privateConstructor();
  //
  final LocalAuthentication _localAuth = LocalAuthentication();

  // --------------------------------------------------
  // 바이오 인증 가능한 하드웨어 인지 확인
  // --------------------------------------------------
  Future<bool> canCheckBiometrics() async {
    try {
      final bool isAvailable = await _localAuth.canCheckBiometrics;
      return isAvailable;
    } on PlatformException catch (e) {
      debugPrint('바이오 인증 가능한 하드웨어 인지 확인 실패: $e');
      return false;
    }
  }

  // --------------------------------------------------
  // 바이오인증 사용 설정
  // --------------------------------------------------
  Future<bool> setBioAuth() async {
    try {
      final bool isAvailable = await canCheckBiometrics();
      if (!isAvailable) return false;
      final bool isSuccess = await _localAuth.authenticate(localizedReason: '바이오인증을 활성화하려면 인증해주세요', options: const AuthenticationOptions(stickyAuth: true, biometricOnly: true));
      if (isSuccess) {
        await LocalStorage().saveUseBioAuth(true);
        return true;
      }
      return false;
    } on PlatformException catch (e) {
      debugPrint('바이오 인증 사용 설정 실패: $e');
      return false;
    }
  }

  // --------------------------------------------------
  // 바이오인증으로 사용자 인증 실행
  // --------------------------------------------------
  Future<bool> runBioAuth() async {
    try {
      final bool? status = await LocalStorage().loadUseBioAuth();
      if (status != true) return false;
      final bool isSuccess = await _localAuth.authenticate(
        localizedReason: '사용자 인증을 위해 바이오인증을 사용해주세요',
        options: const AuthenticationOptions(stickyAuth: true, biometricOnly: true),
      );
      return isSuccess;
    } on PlatformException catch (e) {
      debugPrint('바이오 인증 실패: $e');
      return false;
    }
  }
}
