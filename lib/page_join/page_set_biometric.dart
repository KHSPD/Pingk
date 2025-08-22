import 'package:flutter/material.dart';
import 'package:pingk/common/biometric_auth.dart';
import 'package:pingk/common/my_colors.dart';
import 'package:pingk/common/my_widget.dart';

class PageSetBiometric extends StatefulWidget {
  const PageSetBiometric({super.key});

  @override
  State<PageSetBiometric> createState() => _PageSetBiometricState();
}

class _PageSetBiometricState extends State<PageSetBiometric> {
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
            const Spacer(flex: 1),
            const MyText(
              '빠른 이용을 위한 생체인증 설정',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
            ),

            Container(
              height: 70,
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
              child: MyText(
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
                    onPressed: () {
                      BiometricAuth.instance.disableBiometric();
                      Navigator.pushNamedAndRemoveUntil(context, '/main', (route) => false);
                    },
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
                      final value = await BiometricAuth.instance.enableBiometric();
                      if (value && context.mounted) {
                        Navigator.pushNamedAndRemoveUntil(context, '/main', (route) => false);
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
}
