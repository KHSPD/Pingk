import 'package:flutter/material.dart';
import 'package:pingk/common/my_colors.dart';
import 'package:pingk/common/my_text.dart';

class PageLogin extends StatefulWidget {
  const PageLogin({super.key});

  @override
  State<PageLogin> createState() => _PageLoginState();
}

class _PageLoginState extends State<PageLogin> {
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
              '로그인 페이지 ',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.w700, color: MyColors.text1, height: 1.2),
            ),
            const Spacer(flex: 2),
          ],
        ),
      ),
    );
  }
}
