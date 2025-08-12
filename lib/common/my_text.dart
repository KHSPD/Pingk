import 'package:flutter/material.dart';

class MyText extends StatelessWidget {
  const MyText(this.txt, {super.key, this.style, this.maxLines, this.overflow, this.textAlign});

  final String txt;
  final TextStyle? style;
  final int? maxLines;
  final TextOverflow? overflow;
  final TextAlign? textAlign;

  @override
  Widget build(BuildContext context) {
    // 기본 스타일 정의 (폰트 웨이트 추가)
    const defaultStyle = TextStyle(fontFamily: 'Pretendard', fontSize: 18.0, color: Colors.black, fontWeight: FontWeight.w400);
    // 전달받은 style과 기본 스타일을 병합
    final mergedStyle = defaultStyle.merge(style);
    return Text(txt, style: mergedStyle, maxLines: maxLines, overflow: overflow, textAlign: textAlign);
  }
}
