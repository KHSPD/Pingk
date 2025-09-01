import 'package:flutter/material.dart';
import 'package:pingk/common/my_styles.dart';

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
        decoration: BoxDecoration(color: MyColors.background1, borderRadius: BorderRadius.circular(40), boxShadow: [MyShadows.type4]),
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
        decoration: BoxDecoration(color: MyColors.background1, borderRadius: BorderRadius.circular(40), boxShadow: [MyShadows.type4]),
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
          child: SizedBox(width: 60.0, height: 60.0, child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(MyColors.color1))),
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

// --------------------------------------------------
// 커스텀 팝업 창
// --------------------------------------------------
class Popup {
  static final Popup _instance = Popup._privateConstructor();
  factory Popup() => _instance;
  Popup._privateConstructor();

  OverlayEntry? _overlayEntry;
  bool _isShowing = false;

  // ----- 팝업 표시 -----
  void show({
    required BuildContext context,
    required String title,
    required String msg,
    String? btTxt1,
    String? btTxt2,
    VoidCallback? btCB1,
    VoidCallback? btCB2,
    bool canCancel = false,
  }) {
    if (_isShowing) return;

    _overlayEntry = OverlayEntry(
      builder: (context) => _PopupOverlay(canCancel: canCancel, onDismiss: () => hide(), title: title, msg: msg, btTxt1: btTxt1, btTxt2: btTxt2, btCB1: btCB1, btCB2: btCB2),
    );

    Overlay.of(context).insert(_overlayEntry!);
    _isShowing = true;
  }

  // ----- 팝업 숨기기 -----
  void hide() {
    if (!_isShowing) return;
    _overlayEntry?.remove();
    _overlayEntry = null;
    _isShowing = false;
  }
}

// --------------------------------------------------
// 팝업 오버레이 위젯
// --------------------------------------------------
class _PopupOverlay extends StatefulWidget {
  final bool canCancel;
  final VoidCallback onDismiss;
  final String title;
  final String msg;
  final String? btTxt1;
  final String? btTxt2;
  final VoidCallback? btCB1;
  final VoidCallback? btCB2;

  const _PopupOverlay({required this.canCancel, required this.onDismiss, required this.title, required this.msg, this.btTxt1, this.btTxt2, this.btCB1, this.btCB2});

  @override
  State<_PopupOverlay> createState() => _PopupOverlayState();
}

class _PopupOverlayState extends State<_PopupOverlay> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(duration: const Duration(milliseconds: 300), vsync: this);
    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(parent: _animationController, curve: Curves.easeOutBack));
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(parent: _animationController, curve: Curves.easeOut));
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: GestureDetector(
        onTap: widget.canCancel ? widget.onDismiss : null,
        child: Container(
          color: const Color(0x80000000),
          child: Center(
            child: GestureDetector(
              onTap: () {},
              child: AnimatedBuilder(
                animation: _animationController,
                builder: (context, child) {
                  return Transform.scale(
                    scale: _scaleAnimation.value,
                    child: Opacity(opacity: _fadeAnimation.value, child: _buildPopupContent()),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPopupContent() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 40),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), boxShadow: [MyShadows.type1]),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            widget.title,
            style: const TextStyle(fontSize: 18, color: MyColors.text1, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 10),
          Text(
            widget.msg,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 16, color: MyColors.text2, fontWeight: FontWeight.w400),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              if (widget.btTxt1 != null) ...[
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      Popup().hide();
                      if (widget.btCB1 != null) {
                        widget.btCB1!();
                      }
                    },
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    child: Text(
                      widget.btTxt1!,
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 14, color: MyColors.text1, fontWeight: FontWeight.w600, decoration: TextDecoration.none),
                    ),
                  ),
                ),
              ],
              if (widget.btTxt1 != null && widget.btTxt2 != null) ...[const SizedBox(width: 12)],
              if (widget.btTxt2 != null) ...[
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Popup().hide();
                      if (widget.btCB2 != null) {
                        widget.btCB2!();
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: MyColors.color1,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    child: Text(
                      widget.btTxt2!,
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 14, color: MyColors.text6, fontWeight: FontWeight.w600, decoration: TextDecoration.none),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}
