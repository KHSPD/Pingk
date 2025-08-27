import 'package:flutter/material.dart';
import 'package:pingk/common/biometric_auth.dart';
import 'package:pingk/common/my_colors.dart';
import 'package:pingk/page_sign_up/sign_up.dart';

// ====================================================================================================
// 바이오인증 등록 페이지
// ====================================================================================================
class SetBioAuth extends StatefulWidget {
  final SignUpData signUpData;
  const SetBioAuth(this.signUpData, {super.key});
  @override
  State<SetBioAuth> createState() => _SetBioAuthState();
}

class _SetBioAuthState extends State<SetBioAuth> {
  bool _isBioAvailable = false;

  @override
  void initState() {
    super.initState();
    _checkBioAuthAvailability();
  }

  // --------------------------------------------------
  // 바이오 인증 가능 여부 확인
  // --------------------------------------------------
  Future<void> _checkBioAuthAvailability() async {
    final isAvailable = await BioAuth().isBioAuthAvailable();
    setState(() {
      _isBioAvailable = isAvailable;
    });

    // 바이오 인증이 불가능한 경우
    if (!isAvailable) {
      _navigateToSignInPage();
    }
  }

  // --------------------------------------------------
  // build
  // --------------------------------------------------
  @override
  Widget build(BuildContext context) {
    if (!_isBioAvailable) {
      return Container(
        color: MyColors.background1,
        padding: const EdgeInsets.all(20.0),
        child: SafeArea(
          child: Column(
            children: [
              const Spacer(flex: 1),
              const Text(
                '빠른 이용을 위한 생체인증 설정',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
              ),

              Container(
                height: 70,
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                child: Text(
                  '생체인증으로 간편하게 Pingk를 이용하세요.\n사용자 설정에서 생체인증 설정을 변경할 수 있습니다.',
                  style: const TextStyle(fontSize: 16.0, color: MyColors.text2),
                  textAlign: TextAlign.center,
                ),
              ),
              const Spacer(flex: 2),

              // ----- 하단 버튼 -----
              Row(
                children: [
                  // ----- 다음에 버튼 -----
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _navigateToSignInPage,
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
                      onPressed: () async {
                        final value = await BioAuth().enableBioAuth();
                        if (value && context.mounted) {
                          _navigateToSignInPage();
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: MyColors.primary,
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
      );
    }
    // 바이오 인증 가능 여부 확인중 일때
    return const Center(child: CircularProgressIndicator());
  }

  // --------------------------------------------------
  // 페이지로 이동
  // --------------------------------------------------
  void _navigateToSignInPage() {
    BioAuth().disableBioAuth();
    Navigator.pushNamedAndRemoveUntil(context, '/sign_in', (route) => false, arguments: widget.signUpData.phoneNumber);
  }
}
