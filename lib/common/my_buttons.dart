import 'package:flutter/material.dart';

class MyButtons {
  MyButtons._();

  static Widget myElevatedButton(BuildContext context, String text, void Function() onPressed) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Color(0xFF1E1E1E),
          foregroundColor: Color(0xFFFFFFFF),
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
