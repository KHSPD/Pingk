import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pingk/common/biometric_auth.dart';
import 'package:pingk/common/local_storage.dart';
import 'package:pingk/common/my_styles.dart';
import 'package:pingk/common/my_widget.dart';

// ====================================================================================================
// 바이오인증 등록 페이지
// ====================================================================================================
class SetBioAuth extends StatefulWidget {
  const SetBioAuth({super.key});
  @override
  State<SetBioAuth> createState() => _SetBioAuthState();
}

class _SetBioAuthState extends State<SetBioAuth> {
  // --------------------------------------------------
  // Lifecycle Methods
  // --------------------------------------------------
  @override
  void initState() {
    debugPrint('SetBioAuth : initState');
    super.initState();
  }

  @override
  void dispose() {
    debugPrint('SetBioAuth : dispose');
    super.dispose();
  }

  // --------------------------------------------------
  // 바이오인증 사용 승인시
  // --------------------------------------------------
  Future<void> _approveBioAuth() async {
    final isAvailable = await BioAuth().canCheckBiometrics();
    if (isAvailable) {
      bool result = await BioAuth().setBioAuth();
      if (result && mounted) {
        LocalStorage().saveUseBioAuth(true);
        context.go('/main/home');
      }
    } else {
      // 바이오 인증이 불가능한 경우
      if (mounted) {
        Popup().show(
          context: context,
          title: '생체인증 설정 불가',
          msg: '비밀번호 사용하여 이용해주세요.',
          btTxt2: '확인',
          btCB2: () {
            context.go('/main/home');
          },
        );
      }
    }
  }

  // --------------------------------------------------
  // 바이오 등록 거부시
  // --------------------------------------------------
  void _rejectBioAuth() {
    LocalStorage().saveUseBioAuth(false);
    if (mounted) {
      Popup().show(
        context: context,
        title: '로그인 안내',
        msg: '설정에서 생체인증 사용여부를 변경할 수 있습니다.',
        btTxt2: '확인',
        btCB2: () {
          context.go('/main/home');
        },
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
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 60),

              const Text(
                '빠른 이용을 위한 생체인증 설정',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600, decoration: TextDecoration.none),
              ),

              const SizedBox(height: 20),

              const Text(
                '생체인증으로 간편하게 Pingk를 이용하세요.\n사용자 설정에서 생체인증 설정을 변경할 수 있습니다.',
                style: TextStyle(fontSize: 16.0, color: MyColors.text2, decoration: TextDecoration.none),
              ),
              const Spacer(flex: 2),

              // ----- 하단 버튼 -----
              Row(
                children: [
                  // ----- 다음에 버튼 -----
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => _rejectBioAuth(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        foregroundColor: MyColors.text2,
                        elevation: 0,
                        side: const BorderSide(color: MyColors.text2),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      child: const Text('다음에', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                    ),
                  ),
                  const SizedBox(width: 12),
                  // ----- 사용하기 버튼 -----
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => _approveBioAuth(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: MyColors.color1,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      child: const Text('사용하기', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
