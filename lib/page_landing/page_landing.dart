import 'package:flutter/material.dart';
import 'package:pingk/common/my_colors.dart';
import 'package:pingk/common/my_styles.dart';
import 'package:pingk/common/my_text.dart';

class PageLanding extends StatelessWidget {
  const PageLanding({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.background1,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              const Spacer(flex: 2),
              // ----- 상단 텍스트 -----
              const MyText(
                '이제 쿠폰도 경매로!\n더 알뜰하게 득템해보세요!',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.w700, color: MyColors.text1, height: 1.2),
              ),
              const Spacer(flex: 2),

              // ----- 중간 이미지 -----
              SizedBox(width: 316, height: 467, child: Image.asset('assets/landing_img.png', fit: BoxFit.contain)),
              const Spacer(flex: 4),

              // -----하단 혜택받기 버튼 -----
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacementNamed(context, '/main');
                  },
                  style: MyStyles.bottomButton,
                  child: MyText('혜택받기', style: MyStyles.bottomButtonText),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
