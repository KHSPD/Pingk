import 'package:flutter/material.dart';
import 'package:pingk/common/my_colors.dart';

// ====================================================================================================
// 앱에서 공통으로 사용하는 스타일 정의
// ====================================================================================================
class MyStyles {
  MyStyles._();

  // ----- 하단 검정/흰색 버튼 -----
  static ButtonStyle get bottomButton => ElevatedButton.styleFrom(
    backgroundColor: MyColors.button1,
    foregroundColor: MyColors.text4,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    minimumSize: const Size(double.infinity, 56),
  );
  static TextStyle get bottomButtonText => const TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: MyColors.text4,
  );
}
