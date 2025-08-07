import 'package:flutter/material.dart';
import 'package:pingk/page_main/page_home_discount.dart';
import 'package:pingk/page_main/page_home_auction.dart';
import 'package:pingk/page_main/page_home_best.dart';
import 'package:pingk/page_main/page_home_hotdeal.dart';
import '../common/my_colors.dart';

// ====================================================================================================
// 홈 - StatefulWidget
// ====================================================================================================
class PageHome extends StatefulWidget {
  const PageHome({super.key});

  @override
  State<PageHome> createState() => _PageHomeState();
}

class _PageHomeState extends State<PageHome> {
  // --------------------------------------------------
  // build
  // --------------------------------------------------
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
                // ----- 경매 상품 목록 -----
                const HomeAuctionItems(),
                // ----- 핫딜 상품 목록 -----
                const HomeHotdealItems(),
                // ----- 베스트 상품 목록 -----
                const HomeBestItems(),
                // ----- 상시 할인 상품 목록 -----
                const HomeAlwaysDiscountItems(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
