import 'package:flutter/material.dart';
import 'package:pingk/common/my_colors.dart';

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
          child: Text(number, style: const TextStyle(fontSize: 20.0, fontWeight: FontWeight.w600)),
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

// --------------------------------------------------
// 로딩 화면
// --------------------------------------------------
class Loading {
  static final Loading _instance = Loading._privateConstructor();
  factory Loading() => _instance;
  Loading._privateConstructor();

  OverlayEntry? _overlayEntry;
  bool _isShowing = false;

  // ----- 로딩 화면 표시 -----
  void show(BuildContext context) {
    if (_isShowing) return;
    _overlayEntry = OverlayEntry(
      builder: (context) => Container(
        color: Colors.black.withValues(alpha: 0.4),
        child: const Center(
          child: SizedBox(width: 60.0, height: 60.0, child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(MyColors.primary))),
        ),
      ),
    );
    Overlay.of(context).insert(_overlayEntry!);
    _isShowing = true;
  }

  // ----- 로딩 화면 숨기기 -----
  void hide() {
    if (!_isShowing) return;
    _overlayEntry?.remove();
    _overlayEntry = null;
    _isShowing = false;
  }
}
