import 'package:flutter/material.dart';
import 'package:pingk/common/my_colors.dart';

// --------------------------------------------------
// 커스텀 텍스트
// --------------------------------------------------
class MyText extends StatelessWidget {
  final String txt;
  final TextStyle? style;
  final int? maxLines;
  final TextOverflow? overflow;
  final TextAlign? textAlign;

  const MyText(this.txt, {super.key, this.style, this.maxLines, this.overflow, this.textAlign});

  @override
  Widget build(BuildContext context) {
    // 기본 스타일 정의 (폰트 웨이트 추가)
    const defaultStyle = TextStyle(fontFamily: 'Pretendard', fontSize: 18.0, color: MyColors.text1, fontWeight: FontWeight.w400, decoration: TextDecoration.none);
    // 전달받은 style과 기본 스타일을 병합
    final mergedStyle = defaultStyle.merge(style);
    return Text(txt, style: mergedStyle, maxLines: maxLines, overflow: overflow, textAlign: textAlign);
  }
}

// --------------------------------------------------
// 넘버패드 - 숫자 버튼
// --------------------------------------------------
class NumpadDigitButton extends StatelessWidget {
  final String number;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;

  const NumpadDigitButton(this.number, {super.key, this.onTap, this.onLongPress});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      onLongPress: onLongPress,
      child: Container(
        width: 80,
        height: 80,
        decoration: BoxDecoration(
          color: MyColors.background1,
          borderRadius: BorderRadius.circular(40),
          boxShadow: [BoxShadow(color: MyColors.shadow2, blurRadius: 8, offset: const Offset(0, 2))],
        ),
        child: Center(
          child: MyText(number, style: const TextStyle(fontSize: 20.0, fontWeight: FontWeight.w600)),
        ),
      ),
    );
  }
}

// --------------------------------------------------
// 넘버패드 - 삭제 버튼
// --------------------------------------------------
class NumpadDeleteButton extends StatelessWidget {
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;

  const NumpadDeleteButton({super.key, this.onTap, this.onLongPress});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      onLongPress: onLongPress,
      child: Container(
        width: 80,
        height: 80,
        decoration: BoxDecoration(
          color: MyColors.background1,
          borderRadius: BorderRadius.circular(40),
          boxShadow: [BoxShadow(color: MyColors.shadow2, blurRadius: 8, offset: const Offset(0, 2))],
        ),
        child: const Center(child: Icon(Icons.backspace_outlined, size: 32, color: Colors.grey)),
      ),
    );
  }
}

// --------------------------------------------------
// 하단에 긴 버튼
// --------------------------------------------------
class BottomLongButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const BottomLongButton(this.text, this.onPressed, {super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF1E1E1E),
          foregroundColor: const Color(0xFFFFFFFF),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(26)),
          minimumSize: const Size(double.infinity, 56),
        ),
        onPressed: onPressed,
        child: Text(
          text,
          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Color(0xFFFFFFFF)),
        ),
      ),
    );
  }
}
