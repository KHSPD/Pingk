import 'package:flutter/material.dart';
import 'package:pingk/common/jwt_token_controller.dart';
import 'package:pingk/common/my_colors.dart';
import 'package:pingk/common/my_widget.dart';
import 'package:pingk/common/biometric_auth.dart';
import 'package:pingk/common/secure_storage.dart';

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
      _checkRefreshTokenAndPasswordExist();
    });
  }

  // --------------------------------------------------
  // 저장된 Refresh Token & 비밀번호 존재 여부 확인
  // --------------------------------------------------
  void _checkRefreshTokenAndPasswordExist() async {
    final refreshToken = await JwtTokenController().loadRefreshToken();
    final password = await SecureStorage().loadPassword();
    if (refreshToken.isNotEmpty && password.isNotEmpty) {
      _goLoginPage();
    } else {
      setState(() {
        _showJoinButton = true;
      });
    }
  }

  // --------------------------------------------------
  // 페이지 이동
  // --------------------------------------------------
  void _goJoinPage() {
    Navigator.pushNamedAndRemoveUntil(context, '/join', (route) => false);
  }

  void _goLoginPage() {
    Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
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
                JwtTokenController().saveTokens(accessToken: '', refreshToken: '');
                BioAuth().saveUseBioAuth(BioAuth.statusNotSet);
              },
              child: SizedBox(width: 316, height: 467, child: Image.asset('assets/landing_img.png', fit: BoxFit.contain)),
            ),
            const Spacer(flex: 4),

            // -----혜택받기(회원가입) 버튼 -----
            if (_showJoinButton) BottomLongButton('혜택받기', () => _goJoinPage()),
          ],
        ),
      ),
    );
  }
}
