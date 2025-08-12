import 'package:flutter/material.dart';
import 'package:pingk/common/my_text.dart';
import 'package:pingk/page_main/page_home_discount.dart';
import 'package:pingk/page_main/page_home_auction.dart';
import 'package:pingk/page_main/page_home_hot_deal.dart';
import 'package:pingk/page_main/page_home_winners.dart';
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
    return DefaultTabController(
      length: 2,
      child: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return [
            // ----- 경매 상품 목록 -----
            SliverToBoxAdapter(child: const HomeAuctionItems()),
            // ----- 낙찰자 목록 -----
            SliverToBoxAdapter(child: const HomeWinnersList()),
            // ----- 탭바 (스크롤시 상단 고정) -----
            SliverToBoxAdapter(child: SizedBox(height: 40)),
            SliverPersistentHeader(
              pinned: true, // 탭바를 상단에 고정
              delegate: _SliverAppBarDelegate(
                const TabBar(
                  indicatorColor: MyColors.primary,
                  labelColor: MyColors.text3,
                  unselectedLabelColor: MyColors.text1,
                  tabs: [
                    Tab(
                      child: MyText('핫딜', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500)),
                    ),
                    Tab(
                      child: MyText('상시특가', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500)),
                    ),
                  ],
                ),
              ),
            ),
          ];
        },
        body: TabBarView(children: [HomeHotDealItems(), HomeDiscountItems()]),
      ),
    );
  }
}

// ====================================================================================================
// SliverAppBarDelegate - 탭바를 SliverPersistentHeader로 만들기 위한 델리게이트
// ====================================================================================================
class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate(this._tabBar);

  final TabBar _tabBar;

  @override
  double get minExtent => _tabBar.preferredSize.height;

  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(color: MyColors.background1, child: _tabBar);
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return false;
  }
}
