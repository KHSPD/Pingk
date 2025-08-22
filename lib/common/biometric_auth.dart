import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'package:pingk/common/constants.dart';
import 'package:pingk/common/secure_storage.dart';

class BiometricAuth {
  BiometricAuth._privateConstructor();
  static final BiometricAuth _instance = BiometricAuth._privateConstructor();
  static BiometricAuth get instance => _instance;
  //
  final LocalAuthentication _localAuth = LocalAuthentication();

  // --------------------------------------------------
  // 바이오인증 가능 여부 확인 (하드웨어 지원 여부, 바이오인증 사용 가능 여부)
  // --------------------------------------------------
  Future<bool> isBiometricAvailable() async {
    try {
      final bool isDeviceSupported = await _localAuth.isDeviceSupported();
      if (!isDeviceSupported) return false;
      final bool canCheckBiometrics = await _localAuth.canCheckBiometrics;
      return canCheckBiometrics;
    } on PlatformException catch (_) {
      return false;
    }
  }

  // --------------------------------------------------
  // 사용자의 바이오인증 설정 상태 확인
  // --------------------------------------------------
  Future<String> getBiometricStatus() async {
    try {
      return await SecureStorage.instance.loadBiometricStatus();
    } catch (_) {
      return statusNotSet;
    }
  }

  // --------------------------------------------------
  // 바이오인증 사용 설정
  // --------------------------------------------------
  Future<bool> enableBiometric() async {
    try {
      final bool isAvailable = await isBiometricAvailable();
      if (!isAvailable) return false;
      final bool didAuthenticate = await _localAuth.authenticate(
        localizedReason: '바이오인증을 활성화하려면 인증해주세요',
        options: const AuthenticationOptions(stickyAuth: true, biometricOnly: true),
      );
      if (didAuthenticate) {
        await SecureStorage.instance.saveBiometricStatus(statusEnabled);
        return true;
      }
      return false;
    } on PlatformException catch (e) {
      debugPrint('value: $e');
      return false;
    }
  }

  // --------------------------------------------------
  // 바이오인증 사용 해제
  // --------------------------------------------------
  Future<bool> disableBiometric() async {
    try {
      await SecureStorage.instance.saveBiometricStatus(statusDisabled);
      return true;
    } catch (_) {
      return false;
    }
  }

  // --------------------------------------------------
  // 바이오인증으로 사용자 인증
  // --------------------------------------------------
  Future<bool> authenticate() async {
    try {
      final String status = await getBiometricStatus();
      if (status != 'enabled') return false;

      final bool didAuthenticate = await _localAuth.authenticate(
        localizedReason: '사용자 인증을 위해 바이오인증을 사용해주세요',
        options: const AuthenticationOptions(stickyAuth: true, biometricOnly: true),
      );

      return didAuthenticate;
    } on PlatformException catch (_) {
      return false;
    }
  }
}
