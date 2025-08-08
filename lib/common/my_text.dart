import 'package:flutter/material.dart';

class MyText extends StatelessWidget {
  const MyText(this.txt, {super.key, this.style});

  final String txt;
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    // 기본 스타일 정의
    const defaultStyle = TextStyle(fontFamily: 'Pretendard', fontSize: 18.0, color: Colors.black);
    // 전달받은 style과 기본 스타일을 병합
    final mergedStyle = defaultStyle.merge(style);
    return Text(txt, style: mergedStyle);
  }
}
