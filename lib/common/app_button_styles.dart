import 'package:flutter/material.dart';
import 'package:pingk/common/app_colors.dart';

// ====================================================================================================
// 앱에서 공통으로 사용하는 버튼 스타일 정의
// ====================================================================================================
class AppButtonStyles {
  AppButtonStyles._();

  // ----- 하단 검정/흰색 버튼 -----
  static ButtonStyle get bottomButton => ElevatedButton.styleFrom(
    backgroundColor: AppColors.button1,
    foregroundColor: AppColors.text4,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10),
    ),
    minimumSize: const Size(double.infinity, 56),
  );
  static TextStyle get bottomButtonText => const TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: AppColors.text4,
  );
}