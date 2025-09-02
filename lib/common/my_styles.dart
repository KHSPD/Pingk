import 'package:flutter/material.dart';

// ====================================================================================================
// 색상 정의
// ====================================================================================================
class MyColors {
  MyColors._();

  static const Color color1 = Color(0xFFFF437A);
  static const Color color2 = Color(0xFF4A4A4A);
  static const Color color3 = Color(0xFFF4EBEF);
  static const Color color4 = Color(0xFFD0D0D0);
  static const Color color5 = Color(0xFFF4EEEE);
  static const Color color6 = Color(0xFFFFFFFF);
  static const Color color7 = Color(0xFFFFEFF4);
  static const Color color8 = Color(0xFFFF8CA6);

  static const Color text1 = Color(0xFF393939);
  static const Color text2 = Color(0xFF969696);
  static const Color text3 = Color(0xFF6F6F6F);
  static const Color text4 = Color(0xFFFF437A);
  static const Color text5 = Color(0xFFBEBEBE);
  static const Color text6 = Color(0xFFFFFFFF);

  static const Color background1 = Color(0xFFFFFFFF);
  static const Color background2 = Color(0xFFFF437A);
  static const Color background3 = Color(0xFFFBF9F9);
}

// ====================================================================================================
// Shadow
// ====================================================================================================
class MyShadows {
  MyShadows._();

  static const type1 = BoxShadow(color: Color(0x1B747474), blurRadius: 8, spreadRadius: 5, offset: Offset(0, 0));
  static const type2 = BoxShadow(color: Color(0x03FF437A), blurRadius: 10, spreadRadius: 5, offset: Offset(0, 0));
  static const type3 = BoxShadow(color: Color(0x1FFF437A), blurRadius: 15, spreadRadius: 8, offset: Offset(0, 0));
  static const type4 = BoxShadow(color: Color(0x1A747474), blurRadius: 8, spreadRadius: 2, offset: Offset(0, 5));
}
