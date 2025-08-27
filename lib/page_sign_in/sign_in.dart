import 'dart:convert';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:pingk/common/biometric_auth.dart';
import 'package:pingk/common/constants.dart';
import 'package:pingk/common/jwt_token_controller.dart';
import 'package:pingk/common/my_colors.dart';
import 'package:pingk/common/my_functions.dart';
import 'package:pingk/common/my_widget.dart';
import 'package:http/http.dart' as http;
import 'package:pingk/common/secure_storage.dart';

// ====================================================================================================
// 로그인 페이지
// ====================================================================================================
class SignIn extends StatefulWidget {
  final String? phoneNumber;
  const SignIn({this.phoneNumber, super.key});
  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  bool _showPasswordInputUI = false;
  final int _passwordLength = 6;
  String _userPassword = '';
  String _inputPassword = '';

  // --------------------------------------------------
  // initState
  // --------------------------------------------------
  @override
  void initState() {
    super.initState();
    _checkProcess();
  }

  // --------------------------------------------------
  // 비밀번호, 바이오인증, JWT 토큰 확인해서 프로세스 진행
  // --------------------------------------------------
  void _checkProcess() async {
    _userPassword = await SecureStorage().loadPassword();
    final isBioAuthAvailable = await BioAuth().isBioAuthAvailable();
    final refreshToken = await JwtTokenController().loadRefreshToken();

    if (refreshToken.isEmpty && _userPassword.isNotEmpty && !isBioAuthAvailable) {
      // 비밀번호 직접 입력
    }
  }

  // --------------------------------------------------
  // 바이오 인증 실행 여부 판단
  // --------------------------------------------------
  void _checkBioAuthAvailable() async {
    final isBiometricAvailable = await BioAuth().isBioAuthAvailable();
    final biometricStatus = await BioAuth().loadUseBioAuth();
    if (isBiometricAvailable && biometricStatus == BioAuth.statusEnabled) {
      final bool isAuthenticated = await BioAuth().runBioAuth();
      if (isAuthenticated) {
        _checkRefreshTokenExpired();
      } else {
        setState(() {
          _showPasswordInputUI = true;
        });
      }
    } else {
      setState(() {
        _showPasswordInputUI = true;
      });
    }
    // 비밀번호 입력 시작
    _inputPassword = '';
  }

  // --------------------------------------------------
  // 숫자 패드 버튼 클릭 이벤트
  // --------------------------------------------------
  void _onDigitPadPressed(String digit) {
    setState(() {
      if (digit == '-') {
        if (_inputPassword.isNotEmpty) {
          _inputPassword = _inputPassword.substring(0, _inputPassword.length - 1);
        }
      } else {
        if (_inputPassword.length < _passwordLength) {
          _inputPassword += digit;
        }
        if (_inputPassword.length == _passwordLength) {
          // setState 안에서 _checkPassword 호출 시 setState 중첩 방지
          WidgetsBinding.instance.addPostFrameCallback((_) => _checkPassword());
        }
      }
    });
  }

  // --------------------------------------------------
  // 비밀번호 일치 여부 확인
  // --------------------------------------------------
  void _checkPassword() {
    if (_userPassword.isNotEmpty && _inputPassword == _userPassword) {
      _checkRefreshTokenExpired();
    } else {
      setState(() {
        _inputPassword = '';
      });
      MyFN.showSnackBar(message: '비밀번호가 일치하지 않습니다.\n확인 후 다시 입력해주세요.');
    }
  }

  // --------------------------------------------------
  // API - 토큰 만료 여부 확인
  // --------------------------------------------------
  Future<void> _checkRefreshTokenExpired() async {
    Loading().show(context);
    try {
      // 저장된 Refresh 토큰 가져오기
      final refreshToken = await JwtTokenController().loadRefreshToken();
      if (refreshToken.isEmpty) {
        // 토큰 없음 - 안내 후 회원 인증 페이지로 이동.
        return;
      }
      // 서버에 토큰 유효성 검증 요청
      final response = await http
          .post(Uri.parse('$appServerURL/api/auth/login'), headers: {'Content-Type': 'application/json'}, body: jsonEncode({'phoneNumber': '01089283972', 'password': '123456'}))
          .timeout(const Duration(seconds: apiTimeout));

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        final Map<String, String> result = jsonDecode(responseData['result']);
        final String? accessToken = result['accessToken'];
        final String? refreshToken = result['refreshToken'];
        // JWT 토큰 저장
        if (accessToken != null && accessToken.isNotEmpty && refreshToken != null && refreshToken.isNotEmpty) {
          await JwtTokenController().saveTokens(accessToken: accessToken, refreshToken: refreshToken);
        }
        // 메인 페이지로 이동
        _navigateMainPage();
      } else if (response.statusCode == 401) {
      } else {}
    } catch (e) {
      debugPrint(e.toString());
      MyFN.showSnackBar(message: messageError);
    } finally {
      Loading().hide();
    }
  }

  // --------------------------------------------------
  // build
  // --------------------------------------------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: MyColors.background1, body: _showPasswordInputUI ? _buildPasswordInputUI() : _buildBiometricAuthUI());
  }

  // --------------------------------------------------
  // 바이오 인증 UI 위젯
  // --------------------------------------------------
  Widget _buildBiometricAuthUI() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 60),

          // 제목
          Text(
            '바이오 인증',
            style: const TextStyle(fontSize: 24.0, fontWeight: FontWeight.w700),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 20),

          // 설명 문구
          Container(
            height: 70,
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
            child: Text(
              '바이오 인증을 진행합니다.\n지문 또는 얼굴 인식으로 로그인해주세요.',
              style: const TextStyle(fontSize: 16.0, color: MyColors.text2),
              textAlign: TextAlign.center,
            ),
          ),

          const Spacer(),
        ],
      ),
    );
  }

  // --------------------------------------------------
  // 비밀번호 입력 UI 위젯
  // --------------------------------------------------
  Widget _buildPasswordInputUI() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        children: [
          const SizedBox(height: 60),

          // 제목
          Text(
            '비밀번호 입력',
            style: const TextStyle(fontSize: 24.0, fontWeight: FontWeight.w700),
            textAlign: TextAlign.center,
          ),

          // 설명 문구
          Container(
            height: 70,
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
            child: Text(
              '비밀번호 6자리를 입력해주세요.',
              style: const TextStyle(fontSize: 16.0, color: MyColors.text2),
              textAlign: TextAlign.center,
            ),
          ),

          const SizedBox(height: 20),

          // 비밀번호 표시 아이콘들
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(_passwordLength, (index) {
              bool isFilled = index < _inputPassword.length;
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 8),
                width: 20,
                height: 20,
                decoration: BoxDecoration(shape: BoxShape.circle, color: isFilled ? MyColors.primary : MyColors.tertiary),
              );
            }),
          ),

          const Spacer(),

          // 숫자 패드
          Column(
            children: [
              // 1-3
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  NumpadDigitButton('1', onTap: () => _onDigitPadPressed('1')),
                  NumpadDigitButton('2', onTap: () => _onDigitPadPressed('2')),
                  NumpadDigitButton('3', onTap: () => _onDigitPadPressed('3')),
                ],
              ),
              const SizedBox(height: 16),
              // 4-6
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  NumpadDigitButton('4', onTap: () => _onDigitPadPressed('4')),
                  NumpadDigitButton('5', onTap: () => _onDigitPadPressed('5')),
                  NumpadDigitButton('6', onTap: () => _onDigitPadPressed('6')),
                ],
              ),
              const SizedBox(height: 16),
              // 7-9
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  NumpadDigitButton('7', onTap: () => _onDigitPadPressed('7')),
                  NumpadDigitButton('8', onTap: () => _onDigitPadPressed('8')),
                  NumpadDigitButton('9', onTap: () => _onDigitPadPressed('9')),
                ],
              ),
              const SizedBox(height: 16),
              // 0, 삭제
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const SizedBox(width: 80), // 빈 공간
                  NumpadDigitButton('0', onTap: () => _onDigitPadPressed('0')),
                  NumpadDeleteButton(
                    onTap: () => _onDigitPadPressed('-'),
                    onLongPress: () {
                      setState(() {
                        _inputPassword = '';
                      });
                    },
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  // --------------------------------------------------
  // 페이지 이동
  // --------------------------------------------------
  void _navigateMainPage() {
    Navigator.pushNamedAndRemoveUntil(context, '/main', (route) => false);
  }
}
