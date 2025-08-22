import 'package:flutter/material.dart';
import 'package:pingk/common/constants.dart';
import 'package:pingk/common/my_colors.dart';
import 'package:pingk/common/my_widget.dart';
import 'package:pingk/common/secure_storage.dart';
import 'package:pingk/common/biometric_auth.dart';

class PageLanding extends StatefulWidget {
  const PageLanding({super.key});

  @override
  State<PageLanding> createState() => _PageLandingState();
}

class _PageLandingState extends State<PageLanding> {
  bool _showJoinButton = false;

  // --------------------------------------------------
  // initState
  // --------------------------------------------------
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 1), () {
      checkNextStep();
    });
  }

  // --------------------------------------------------
  // 페이지 이동
  // --------------------------------------------------
  void goJoinPage() {
    Navigator.pushNamedAndRemoveUntil(context, '/join', (route) => false);
  }

  void goMainPage() {
    Navigator.pushNamedAndRemoveUntil(context, '/main', (route) => false);
  }

  void goLoginPage() {
    Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
  }

  // --------------------------------------------------
  // 다음 단계 확인
  // --------------------------------------------------
  void checkNextStep() async {
    final Map<String, String> loginInfo = await SecureStorage.instance.loadLoginInfo();
    final password = loginInfo['password'] ?? '';
    if (password.isEmpty) {
      // ----- 저장된 비밀번호가 없는 경우 -----
      setState(() {
        _showJoinButton = true;
      });
    } else {
      // ----- 저장된 비밀번호가 있는 경우 -----
      final isBiometricAvailable = await BiometricAuth.instance.isBiometricAvailable();
      final biometricStatus = await SecureStorage.instance.loadBiometricStatus();
      if (isBiometricAvailable && biometricStatus == statusEnabled) {
        final bool isAuthenticated = await BiometricAuth.instance.authenticate();
        if (isAuthenticated) {
          goMainPage();
        } else {
          goLoginPage();
        }
      } else {
        goLoginPage();
      }
    }
  }

  // --------------------------------------------------
  // build
  // --------------------------------------------------
  @override
  Widget build(BuildContext context) {
    return Container(
      color: MyColors.background1,
      padding: const EdgeInsets.all(20.0),
      child: SafeArea(
        child: Column(
          children: [
            const Spacer(flex: 2),
            // ----- 상단 텍스트 -----
            const MyText(
              '이제 쿠폰도 경매로!\n더 알뜰하게 득템해보세요!',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.w700, color: MyColors.text1, height: 1.2),
            ),
            const Spacer(flex: 2),

            // ----- 중간 이미지 -----
            GestureDetector(
              onTap: () {
                SecureStorage.instance.saveLoginInfo(id: '', password: '');
                SecureStorage.instance.saveBiometricStatus(statusNotSet);
              },
              child: SizedBox(width: 316, height: 467, child: Image.asset('assets/landing_img.png', fit: BoxFit.contain)),
            ),
            const Spacer(flex: 4),

            // -----혜택받기(회원가입) 버튼 -----
            if (_showJoinButton) BottomLongButton('혜택받기', () => goJoinPage()),
          ],
        ),
      ),
    );
  }
}
