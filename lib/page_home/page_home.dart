import 'package:flutter/material.dart';
import 'package:pingk/common/my_widget.dart';
import 'package:pingk/page_home/page_home_always_deal.dart';
import 'package:pingk/page_home/page_home_auction.dart';
import 'package:pingk/page_home/page_home_limited_deal.dart';
import 'package:pingk/page_home/page_home_winners.dart';
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
            // ----- 탭바 (한정특가 / 상시특가) -----
            SliverToBoxAdapter(child: SizedBox(height: 40)),
            SliverPersistentHeader(
              pinned: true,
              delegate: _SliverAppBarDelegate(
                const TabBar(
                  indicatorColor: MyColors.primary,
                  labelColor: MyColors.text3,
                  unselectedLabelColor: MyColors.text1,
                  tabs: [
                    Tab(
                      child: MyText('한정특가', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500)),
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
        // ----- 탭바 뷰 (한정특가 / 상시특가) -----
        body: TabBarView(children: [HomeHotDealItems(), HomeDiscountItems()]),
      ),
    );
  }
}

// ====================================================================================================
// SliverAppBarDelegate
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
