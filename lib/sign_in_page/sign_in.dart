import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pingk/_common/biometric_auth.dart';
import 'package:pingk/_common/my_styles.dart';
import 'package:pingk/_common/my_functions.dart';
import 'package:pingk/_common/my_widget.dart';
import 'package:pingk/_common/local_storage.dart';

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
  String _localHashedPassword = '';
  String _inputPassword = '';

  // --------------------------------------------------
  // Lifecycle Methods
  // --------------------------------------------------
  @override
  void initState() {
    debugPrint('SignIn : initState');
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkProcess();
    });
  }

  @override
  void dispose() {
    debugPrint('SignIn : dispose');
    super.dispose();
  }

  // --------------------------------------------------
  // 다음 절차 확인
  // --------------------------------------------------
  void _checkProcess() async {
    _localHashedPassword = await LocalStorage().loadPassword();
    final canCheckBiometrics = await BioAuth().canCheckBiometrics();
    final useBioAuth = await LocalStorage().loadUseBioAuth();
    if (canCheckBiometrics && useBioAuth == true) {
      bool result = await BioAuth().runBioAuth();
      if (!mounted) return;
      if (result) {
        context.go('/main/home');
      } else {
        setState(() {
          _showPasswordInputUI = true;
        });
        MyFN.showSnackBar(message: '바이오 인증에 실패했습니다.\n비밀번호로 인증해주세요.');
      }
    } else {
      if (!mounted) return;
      if (_localHashedPassword.isNotEmpty) {
        setState(() {
          _showPasswordInputUI = true;
        });
      } else {
        context.go('/sign_up');
      }
    }
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
    if (_localHashedPassword == MyFN.stringToHash(_inputPassword)) {
      context.go('/main/home');
    } else {
      setState(() {
        _inputPassword = '';
      });
      MyFN.showSnackBar(message: '비밀번호가 일치하지 않습니다.\n확인 후 다시 입력해주세요.');
    }
  }

  // --------------------------------------------------
  // build
  // --------------------------------------------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.background1,
      body: SafeArea(
        child: Container(padding: const EdgeInsets.symmetric(horizontal: 24.0), child: _showPasswordInputUI ? _buildPasswordInputUI() : _buildBiometricAuthUI()),
      ),
    );
  }

  // --------------------------------------------------
  // 바이오 인증 UI 위젯
  // --------------------------------------------------
  Widget _buildBiometricAuthUI() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 60),

        // 제목
        Text('바이오 인증', style: const TextStyle(fontSize: 24.0, fontWeight: FontWeight.w700)),
        const SizedBox(height: 20),

        // 설명 문구
        Text('바이오 인증을 진행합니다.\n지문 또는 얼굴 인식으로 로그인해주세요.', style: const TextStyle(fontSize: 16.0, color: MyColors.text2)),

        const Spacer(),
      ],
    );
  }

  // --------------------------------------------------
  // 비밀번호 입력 UI 위젯
  // --------------------------------------------------
  Widget _buildPasswordInputUI() {
    return Column(
      children: [
        const Spacer(flex: 1),

        // 제목
        Text(
          '비밀번호 입력',
          style: const TextStyle(fontSize: 24.0, fontWeight: FontWeight.w700),
          textAlign: TextAlign.center,
        ),

        const SizedBox(height: 20),

        // 설명 문구
        Text(
          '비밀번호 6자리를 입력해주세요.',
          style: const TextStyle(fontSize: 16.0, color: MyColors.text2),
          textAlign: TextAlign.center,
        ),

        const SizedBox(height: 40),

        // 비밀번호 표시 아이콘들
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(_passwordLength, (index) {
            bool isFilled = index < _inputPassword.length;
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 8),
              width: 20,
              height: 20,
              decoration: BoxDecoration(shape: BoxShape.circle, color: isFilled ? MyColors.color1 : MyColors.color2),
            );
          }),
        ),

        const SizedBox(height: 60),

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

        const Spacer(flex: 1),
      ],
    );
  }
}
