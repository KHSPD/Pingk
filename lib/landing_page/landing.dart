import 'package:flutter/material.dart';
import 'package:pingk/_common/item_info.dart';
import 'package:pingk/_common/local_db.dart';
import 'package:pingk/_common/my_datetime.dart';
import 'package:pingk/_common/my_styles.dart';
import 'package:pingk/_common/my_widget.dart';
import 'package:pingk/_common/biometric_auth.dart';
import 'package:pingk/_common/local_storage.dart';
import 'package:go_router/go_router.dart';
import 'package:pingk/_common/token_manager.dart';

// ====================================================================================================
// Landing
// ====================================================================================================
class Landing extends StatefulWidget {
  const Landing({super.key});

  @override
  State<Landing> createState() => _LandingState();
}

class _LandingState extends State<Landing> {
  bool _showSignUpButton = false;

  // --------------------------------------------------
  // Lifecycle Methods
  // --------------------------------------------------
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      LocalDatabase().insertFavorite(FavoriteItem(id: 'P202509030001', brand: '메가커피', title: 'HOT 아메리카노', price: 1190, originPrice: 1500, status: 'ACTIVE'));
      LocalDatabase().insertFavorite(FavoriteItem(id: 'P202509030010', brand: '앤티앤스', title: '레몬에이드', price: 3000, originPrice: 3500, status: 'ACTIVE'));

      _checkProcess();
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  // --------------------------------------------------
  // 다음 절차 확인
  // --------------------------------------------------
  void _checkProcess() async {
    // ----- 서버 시간 동기화 -----
    await MyDateTime().startSync();
    // ----- 1초 딜레이 -----
    await Future.delayed(const Duration(milliseconds: 1000));
    // ----- Token 출력 -----
    debugPrint('========== Token ==========');
    debugPrint('Access Token: ${await LocalStorage().loadAccessToken()}');
    debugPrint('Refresh Token: ${await LocalStorage().loadRefreshToken()}');
    // ----- Token 확인 -----
    final String? accessToken = await JwtManager().getAccessToken();
    // ----- Access Token 확인 -----
    if (accessToken == null) {
      debugPrint('Access Token - X');
      setState(() {
        _showSignUpButton = true;
      });
      if (mounted) {
        Popup().show(
          context: context,
          title: '본인인증 안내',
          msg: '본인확인을 위한 인증이 필요합니다.',
          btTxt2: '확인',
          btCB2: () {
            context.go('/phone_number_auth');
          },
        );
      }
      return;
    }
    // ----- 비밀번호 확인 -----
    final password = await LocalStorage().loadPassword();
    if (password.isEmpty) {
      debugPrint('비밀번호 설정 페이지로 이동');
      if (mounted) {
        context.go('/set_password');
      }
      return;
    }
    // ----- 바이오인증 가능 여부 확인 -----
    final canCheckBiometrics = await BioAuth().canCheckBiometrics();
    final isEnabled = await LocalStorage().loadUseBioAuth();
    if (canCheckBiometrics && isEnabled == null) {
      debugPrint('바이오 인증 등록 페이지로 이동');
      if (mounted) {
        context.go('/set_bio_auth');
      }
      return;
    } else if (isEnabled != null) {
      debugPrint('로그인 페이지로 이동');
      if (mounted) {
        context.go('/sign_in');
      }
      return;
    }

    setState(() {
      _showSignUpButton = true;
    });
  }

  // --------------------------------------------------
  // build
  // --------------------------------------------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.background1,
      body: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: SafeArea(
          child: Column(
            children: [
              const Spacer(flex: 2),

              // ----- 상단 텍스트 -----
              const Text(
                '이제 쿠폰도 경매로!\n더 알뜰하게 득템해보세요!',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.w700, color: MyColors.text1, height: 1.2, decoration: TextDecoration.none),
              ),
              const Spacer(flex: 2),

              // ----- 중간 이미지 -----
              GestureDetector(
                onTap: () {
                  // TODO: 테스트용 코드 삭제 필요
                  LocalStorage().clearAll();
                  setState(() {
                    _showSignUpButton = true;
                  });
                },
                child: SizedBox(width: 316, height: 467, child: Image.asset('assets/landing_img.png', fit: BoxFit.contain)),
              ),
              const Spacer(flex: 4),

              // -----혜택받기(회원가입) 버튼 -----
              _showSignUpButton ? BottomLongButton('혜택받기', () => context.go('/phone_number_auth')) : const SizedBox(height: 56),
            ],
          ),
        ),
      ),
    );
  }
}
