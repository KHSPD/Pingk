import 'package:flutter/material.dart';
import 'package:pingk/common/my_colors.dart';
import 'package:pingk/common/my_text.dart';
import 'package:pingk/common/secure_storage.dart';

class PageSetPassword extends StatefulWidget {
  const PageSetPassword({super.key});

  @override
  State<PageSetPassword> createState() => _PageSetPasswordState();
}

class _PageSetPasswordState extends State<PageSetPassword> {
  final int _passwordLength = 6;
  String _password = '';
  String _confirmPassword = '';
  bool _isConfirming = false;

  // --------------------------------------------------
  // 숫자 패드 버튼 클릭 이벤트
  // --------------------------------------------------
  void _onDigitPadPressed(String digit) {
    setState(() {
      if (digit == '-') {
        if (_isConfirming && _confirmPassword.isNotEmpty) {
          _confirmPassword = _confirmPassword.substring(0, _confirmPassword.length - 1);
        } else if (!_isConfirming && _password.isNotEmpty) {
          _password = _password.substring(0, _password.length - 1);
        }
      } else {
        if (!_isConfirming && _password.length < _passwordLength) {
          _password += digit;
          if (_password.length == _passwordLength) _isConfirming = true;
        } else if (_isConfirming && _confirmPassword.length < _passwordLength) {
          _confirmPassword += digit;
          if (_confirmPassword.length == _passwordLength) {
            // setState 안에서 _checkPassword 호출 시 setState 중첩 방지
            WidgetsBinding.instance.addPostFrameCallback((_) => _checkPassword());
          }
        }
      }
    });
  }

  // --------------------------------------------------
  // 비밀번호 확인
  // --------------------------------------------------
  void _checkPassword() {
    if (_password == _confirmPassword) {
      // 비밀번호 일치
      SecureStorage.instance.saveLoginInfo(password: _password);
      Navigator.pushReplacementNamed(context, '/set-biometric');
    } else {
      // 비밀번호 불일치
      setState(() {
        _password = '';
        _confirmPassword = '';
        _isConfirming = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: MyText(
            '비밀번호가 일치하지 않습니다. 다시 입력해주세요.',
            style: const TextStyle(fontSize: 16.0, color: MyColors.text4),
            textAlign: TextAlign.center,
          ),
          duration: const Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          backgroundColor: MyColors.background5,
        ),
      );
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
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              const SizedBox(height: 60),

              // 제목
              MyText(
                _isConfirming ? '비밀번호 확인' : '비밀번호 설정',
                style: const TextStyle(fontSize: 24.0, fontWeight: FontWeight.w700),
                textAlign: TextAlign.center,
              ),

              // 설명 문구
              Container(
                height: 70,
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                child: MyText(
                  _isConfirming ? '비밀번호를 한번 더 입력해주세요' : '앱 실행시 사용할 6자리 비밀번호를 입력해주세요.',
                  style: const TextStyle(fontSize: 16.0, color: MyColors.text2),
                  textAlign: TextAlign.center,
                ),
              ),

              const SizedBox(height: 20),

              // 비밀번호 표시 아이콘들
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(_passwordLength, (index) {
                  bool isFilled = _isConfirming ? index < _confirmPassword.length : index < _password.length;

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
                  Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [_digitButton('1'), _digitButton('2'), _digitButton('3')]),
                  const SizedBox(height: 16),
                  // 4-6
                  Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [_digitButton('4'), _digitButton('5'), _digitButton('6')]),
                  const SizedBox(height: 16),
                  // 7-9
                  Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [_digitButton('7'), _digitButton('8'), _digitButton('9')]),
                  const SizedBox(height: 16),
                  // 0, 삭제
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      const SizedBox(width: 80), // 빈 공간
                      _digitButton('0'),
                      _deleteButton(),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  // --------------------------------------------------
  // 숫자 패드 버튼
  // --------------------------------------------------
  Widget _digitButton(String number) {
    return GestureDetector(
      onTap: () => _onDigitPadPressed(number),
      child: Container(
        width: 80,
        height: 80,
        decoration: BoxDecoration(
          color: MyColors.background1,
          borderRadius: BorderRadius.circular(40),
          boxShadow: [BoxShadow(color: MyColors.shadow2, blurRadius: 8, offset: const Offset(0, 2))],
        ),
        child: Center(
          child: MyText(number, style: const TextStyle(fontSize: 20.0, fontWeight: FontWeight.w600)),
        ),
      ),
    );
  }

  // --------------------------------------------------
  // 삭제 버튼
  // --------------------------------------------------
  Widget _deleteButton() {
    return GestureDetector(
      onTap: () => _onDigitPadPressed('-'),
      onLongPress: () {
        setState(() {
          if (_isConfirming) {
            _confirmPassword = '';
          } else {
            _password = '';
          }
        });
      },
      child: Container(
        width: 80,
        height: 80,
        decoration: BoxDecoration(
          color: MyColors.background1,
          borderRadius: BorderRadius.circular(40),
          boxShadow: [BoxShadow(color: MyColors.shadow2, blurRadius: 8, offset: const Offset(0, 2))],
        ),
        child: const Center(child: Icon(Icons.backspace_outlined, size: 32, color: Colors.grey)),
      ),
    );
  }
}
