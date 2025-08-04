import 'package:flutter/material.dart';
import 'package:pingk/common/app_colors.dart';
import 'package:pingk/common/app_button_styles.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              const Spacer(),
              // ----- 상단 텍스트 -----
              const Text(
                '이제 쿠폰도 경매로!\n더 알뜰하게 득템해보세요!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.text1,
                  height: 1.4,
                ),
              ),
              const Spacer(flex: 1),

              // ----- 중간 이미지 -----
              SizedBox(width: 316, height: 467, child: Placeholder()),
              const Spacer(flex: 5),

              // -----하단 혜택받기 버튼 -----
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/login');
                  },
                  style: AppButtonStyles.bottomButton,
                  child: Text('혜택받기', style: AppButtonStyles.bottomButtonText),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
