import 'package:flutter/material.dart';
import 'package:pingk/_common/constants.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';
import 'my_styles.dart';

// ====================================================================================================
// 앱에서 공통으로 사용하는 함수 Util
// ====================================================================================================
class MyFN {
  MyFN._();

  // --------------------------------------------------
  // 문자열을 SHA256 해시로 변환
  // --------------------------------------------------
  static String stringToHash(String string) {
    var bytes = utf8.encode(string);
    var digest = sha256.convert(bytes);
    return digest.toString();
  }

  // --------------------------------------------------
  // 숫자에 3자리마다 콤마를 찍어서 문자열로 반환
  // --------------------------------------------------
  static String formatNumberWithComma(dynamic number) {
    if (number == null) return '0';
    // 숫자를 문자열로 변환
    String numStr = number.toString();
    // 소수점이 있는 경우 분리
    List<String> parts = numStr.split('.');
    String integerPart = parts[0];
    String decimalPart = parts.length > 1 ? '.${parts[1]}' : '';
    // 정수 부분에 3자리마다 콤마 추가
    String formattedInteger = '';
    for (int i = 0; i < integerPart.length; i++) {
      if (i > 0 && (integerPart.length - i) % 3 == 0) {
        formattedInteger += ',';
      }
      formattedInteger += integerPart[i];
    }
    return formattedInteger + decimalPart;
  }

  // --------------------------------------------------
  // 할인률 계산
  // --------------------------------------------------
  static int discountRate(int originalPrice, int price) {
    if (originalPrice <= 0) return 0;
    return ((originalPrice - price) / originalPrice * 100).floor();
  }

  // --------------------------------------------------
  // SnackBar
  // --------------------------------------------------
  static void showSnackBar({
    required String message,
    Duration duration = const Duration(seconds: 3),
    Color? backgroundColor,
    Color? textColor,
    double? fontSize,
    SnackBarBehavior behavior = SnackBarBehavior.floating,
    double borderRadius = 20.0,
  }) {
    snackbarKey.currentState?.showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: TextStyle(fontSize: fontSize ?? 16.0, color: textColor ?? MyColors.text6),
          textAlign: TextAlign.center,
        ),
        duration: duration,
        behavior: behavior,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(borderRadius)),
        backgroundColor: backgroundColor ?? MyColors.background2,
      ),
    );
  }
}
