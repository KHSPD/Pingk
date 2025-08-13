import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pingk/common/my_text.dart';
import 'package:pingk/page_auction/page_auction.dart';
import 'package:pingk/page_main/page_main_tab_index.dart';
import 'package:provider/provider.dart';
import '../common/my_colors.dart';
import '../page_home/page_home.dart';

// ====================================================================================================
// Main - StatefulWidget
// ====================================================================================================
class PageMain extends StatefulWidget {
  const PageMain({super.key});

  @override
  State<PageMain> createState() => _PageMainState();
}

// ====================================================================================================
// Main - State
// ====================================================================================================
class _PageMainState extends State<PageMain> {
  // --------------------------------------------------
  // IndexedStack으로 모든 페이지 생성
  // --------------------------------------------------
  Widget _pageStack() {
    return Consumer<MainTabIdx>(
      builder: (context, tabIndex, child) {
        return IndexedStack(
          index: tabIndex.selectedIdx,
          children: [
            const PageHome(),
            const Center(child: Text('찜', style: TextStyle(fontSize: 20))),
            const Center(child: Text('쿠폰함', style: TextStyle(fontSize: 20))),
            const PageAuction(),
            const Center(child: Text('한정특가', style: TextStyle(fontSize: 20))),
          ],
        );
      },
    );
  }

  // --------------------------------------------------
  // build
  // --------------------------------------------------
  @override
  Widget build(BuildContext context) {
    const int couponButtonIndex = 2;

    return Scaffold(
      backgroundColor: MyColors.background1,
      // ----- 상단바 -----
      appBar: AppBar(
        backgroundColor: MyColors.background2,
        automaticallyImplyLeading: false,
        title: Padding(padding: const EdgeInsets.only(left: 10), child: Image.asset('assets/logo_main_top.png', width: 78, height: 21)),
        actions: [
          IconButton(onPressed: () {}, icon: SvgPicture.asset('assets/icons/icon_search.svg', width: 20, height: 20)),
          IconButton(onPressed: () {}, icon: SvgPicture.asset('assets/icons/icon_my_info.svg', width: 18, height: 20)),
          const SizedBox(width: 20),
        ],
      ),

      // ----- Body -----
      body: Container(color: MyColors.background1, width: double.infinity, height: double.infinity, child: _pageStack()),

      // ----- 쿠폰함 버튼 -----
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Consumer<MainTabIdx>(
        builder: (context, tabIndex, child) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 46),
              FloatingActionButton(
                onPressed: () => tabIndex.changeIdx(couponButtonIndex),
                shape: const CircleBorder(),
                backgroundColor: MyColors.primary,
                foregroundColor: Colors.white,
                elevation: 0,
                child: SvgPicture.asset('assets/icons/icon_coupon.svg', width: 32, height: 20),
              ),
              const SizedBox(height: 6),
              MyText('쿠폰함', style: TextStyle(fontSize: 14, color: tabIndex.selectedIdx == couponButtonIndex ? MyColors.text3 : MyColors.text1)),
            ],
          );
        },
      ),

      // ----- 하단 메뉴바 -----
      bottomNavigationBar: Container(
        color: MyColors.background2,
        child: Container(
          decoration: BoxDecoration(
            boxShadow: [BoxShadow(color: MyColors.shadow2, blurRadius: 8, offset: const Offset(0, -2))],
            borderRadius: const BorderRadius.only(topLeft: Radius.circular(16), topRight: Radius.circular(16)),
          ),
          child: ClipRRect(
            borderRadius: const BorderRadius.only(topLeft: Radius.circular(16), topRight: Radius.circular(16)),
            child: BottomAppBar(
              color: MyColors.background1,
              child: Row(
                children: [
                  _menuButton('assets/icons/icon_home.svg', 18, 18, '홈', 0),
                  _menuButton('assets/icons/icon_like.svg', 18, 16, '찜', 1),
                  const SizedBox(width: 84),
                  _menuButton('assets/icons/icon_auction.svg', 14, 19, '핑크옥션', 3),
                  _menuButton('assets/icons/icon_hot_deal.svg', 14, 18, '한정특가', 4),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // --------------------------------------------------
  // 메뉴 버튼 위젯
  // --------------------------------------------------
  Widget _menuButton(String svgAssetPath, double width, double height, String label, int index) {
    return Consumer<MainTabIdx>(
      builder: (context, tabIndex, child) {
        return Expanded(
          child: GestureDetector(
            onTap: () {
              tabIndex.changeIdx(index);
            },
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SvgPicture.asset(
                  svgAssetPath,
                  width: width,
                  height: height,
                  colorFilter: ColorFilter.mode(tabIndex.selectedIdx == index ? MyColors.primary : MyColors.icon1, BlendMode.srcIn),
                ),
                const SizedBox(height: 10),
                MyText(label, style: TextStyle(color: tabIndex.selectedIdx == index ? MyColors.primary : MyColors.text1, fontSize: 14)),
              ],
            ),
          ),
        );
      },
    );
  }
}
