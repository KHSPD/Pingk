import 'package:flutter/material.dart';
import 'package:pingk/page_main/body_home_always_deal.dart';
import 'package:pingk/page_main/body_home_auction.dart';
import 'package:pingk/page_main/body_home_limited_deal.dart';
import 'package:pingk/page_main/body_home_winners.dart';
import '../common/my_styles.dart';

// ====================================================================================================
// BodyHome
// ====================================================================================================
class BodyHome extends StatefulWidget {
  const BodyHome({super.key});

  @override
  State<BodyHome> createState() => _BodyHomeState();
}

class _BodyHomeState extends State<BodyHome> {
  // --------------------------------------------------
  // Lifecycle Methods
  // --------------------------------------------------
  @override
  void initState() {
    debugPrint('BodyHome : initState');
    super.initState();
  }

  @override
  void dispose() {
    debugPrint('BodyHome : dispose');
    super.dispose();
  }

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
            SliverToBoxAdapter(child: const BodyHomeAuctionItems()),
            // ----- 낙찰자 목록 -----
            SliverToBoxAdapter(child: const BodyHomeWinnersList()),
            // ----- 탭바 (한정특가 / 상시특가) -----
            SliverToBoxAdapter(child: SizedBox(height: 40)),
            SliverPersistentHeader(
              pinned: true,
              delegate: _SliverAppBarDelegate(
                TabBar(
                  labelColor: const Color(0xFFFF437A),
                  unselectedLabelColor: const Color(0xFFBEBEBE),
                  indicator: const BoxDecoration(
                    border: Border(bottom: BorderSide(color: Color(0xFFFF437A), width: 2.0)),
                  ),
                  indicatorSize: TabBarIndicatorSize.tab,
                  tabs: const [
                    Tab(
                      child: Text('한정특가', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                    ),
                    Tab(
                      child: Text('상시특가', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                    ),
                  ],
                ),
              ),
            ),
          ];
        },
        // ----- 탭바 뷰 (한정특가 / 상시특가) -----
        body: TabBarView(children: [BodyHomeLimitedDeal(), BodyHomeAlwaysDeal()]),
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
