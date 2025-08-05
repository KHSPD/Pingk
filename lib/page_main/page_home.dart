import 'package:flutter/material.dart';
import 'package:pingk/page_main/page_home_auction.dart';
import '../common/my_colors.dart';
import '../common/my_function.dart';

// ====================================================================================================
// 홈 - StatefulWidget
// ====================================================================================================
class PageHome extends StatefulWidget {
  const PageHome({super.key});

  @override
  State<PageHome> createState() => _PageHomeState();
}

class _PageHomeState extends State<PageHome> {
  // ========== build ==========
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            width: double.infinity,
            color: MyColors.background2,
            child: Column(
              children: [
                // ----- 상단 문구 -----
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.fromLTRB(30, 30, 30, 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      RichText(
                        text: const TextSpan(
                          style: TextStyle(fontSize: 24, color: Colors.black87),
                          children: [
                            TextSpan(
                              text: '경매',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            TextSpan(text: '로 저렴하게'),
                          ],
                        ),
                      ),
                      RichText(
                        text: const TextSpan(
                          style: TextStyle(fontSize: 24, color: Colors.black87),
                          children: [
                            TextSpan(
                              text: '쿠폰 쇼핑',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            TextSpan(text: '하세요!'),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                // ----- 경매 상품 미리보기 -----
                const AuctionProductPreview(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
