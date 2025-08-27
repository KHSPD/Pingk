import 'package:flutter/material.dart';
import 'package:pingk/page_sign_up/phone_number_auth.dart';

// ====================================================================================================
// 회원 가입시 필요 정보 클래스
// ====================================================================================================
class SignUpData {
  String carrier = 'SKT';
  String name = '홍길동';
  String phoneNumber = '';
  String password = '';
}

// ====================================================================================================
// 회원가입 페이지
// ====================================================================================================
class SignUp extends StatelessWidget {
  const SignUp({super.key});

  @override
  Widget build(BuildContext context) {
    return PhoneNumberAuth(SignUpData());
  }
}
