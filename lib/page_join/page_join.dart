import 'package:flutter/material.dart';
import 'package:pingk/common/my_colors.dart';
import 'package:pingk/common/my_widget.dart';

class PageJoin extends StatefulWidget {
  const PageJoin({super.key});

  @override
  State<PageJoin> createState() => _PageJoinState();
}

class _PageJoinState extends State<PageJoin> {
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
              '회원가입 페이지',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.w600),
            ),
            const Spacer(flex: 1),
            const MyText('카드사, 통신사 등에 따른 가입 처리 일단 생략', textAlign: TextAlign.center, style: TextStyle(fontSize: 16)),
            const Spacer(flex: 10),
            BottomLongButton('회원가입 완료', () {
              Navigator.pushNamed(context, '/set-password');
            }),
          ],
        ),
      ),
    );
  }
}
