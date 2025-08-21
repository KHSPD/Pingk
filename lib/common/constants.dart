// ----- 메인 메뉴 -----
enum MainMenu { home, favorite, pingkAuction, limitedDeal }

// ----- 바이오인증 상태 -----
enum BiometricStatus { enabled, disabled, notSet }

extension BiometricStatusExtension on BiometricStatus {
  String get stringValue {
    switch (this) {
      case BiometricStatus.enabled:
        return 'enabled';
      case BiometricStatus.disabled:
        return 'disabled';
      case BiometricStatus.notSet:
        return 'notSet';
    }
  }
}
