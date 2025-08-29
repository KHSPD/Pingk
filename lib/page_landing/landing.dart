import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pingk/common/constants.dart';
import 'package:pingk/common/my_colors.dart';
import 'package:pingk/common/my_functions.dart';
import 'package:pingk/common/my_widget.dart';
import 'package:pingk/common/biometric_auth.dart';
import 'package:pingk/common/local_storage.dart';
import 'package:go_router/go_router.dart';

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
    debugPrint('Landing : initState');
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkProcess();
    });
  }

  @override
  void dispose() {
    debugPrint('Landing : dispose');
    super.dispose();
  }

  // --------------------------------------------------
  // 다음 절차 확인
  // --------------------------------------------------
  void _checkProcess() async {
    await Future.delayed(const Duration(milliseconds: 1000));

    // ----- Refresh Token 확인 -----
    final refreshToken = await LocalStorage().loadRefreshToken();
    if (refreshToken.isNotEmpty) {
      debugPrint('Refresh Token - O');
      final bool? isValidRefreshToken = await _isValidRefreshToken(refreshToken);
      if (isValidRefreshToken == false) {
        debugPrint('Refresh Token - 만료됨');
        await LocalStorage().clearAll();
        setState(() {
          _showSignUpButton = true;
        });
        if (mounted) {
          Popup().show(
            context: context,
            title: '로그인 만료',
            msg: '기간이 만료되어 다시 인증이 필요합니다.',
            btTxt2: '확인',
            btCB2: () {
              context.go('/phone_number_auth');
            },
          );
        }
        return;
      } else if (isValidRefreshToken == null) {
        MyFN.showSnackBar(message: '정보 확인 중 오류가 발생했습니다.');
        return;
      }
    } else {
      debugPrint('Refresh Token - X');
      setState(() {
        _showSignUpButton = true;
      });
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
  // Refresh Token 만료 여부 확인
  // --------------------------------------------------
  Future<bool?> _isValidRefreshToken(String refreshToken) async {
    Loading().show(context);
    try {
      final String apiUrl = '$appServerURL/api/auth/validate-token';
      final response = await http.post(Uri.parse(apiUrl), headers: {'Content-Type': 'application/json', 'Accept': 'application/json', 'X-Refresh-Token': refreshToken});

      debugPrint('========== API Response: $apiUrl =====');
      debugPrint('status: ${response.statusCode}');
      debugPrint('body: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseBody = jsonDecode(response.body);
        if (responseBody['code'] == '200') {
          final String accessToken = responseBody['result']['accessToken'];
          await LocalStorage().saveAccessToken(accessToken);
          return true;
        } else {
          return false;
        }
      } else {
        return null;
      }
    } catch (e) {
      debugPrint('Exception: ${e.toString()}');
      MyFN.showSnackBar(message: messageError);
      return null;
    } finally {
      Loading().hide();
    }
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
