import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pingk/common/my_text.dart';
import 'package:pingk/page_main/page_hotdeal.dart';
import '../common/my_colors.dart';
import 'page_home.dart';

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
  int _selectedIndex = 0;

  // --------------------------------------------------
  // IndexedStack으로 모든 페이지 생성
  // --------------------------------------------------
  Widget _pageStack() {
    return IndexedStack(
      index: _selectedIndex,
      children: [
        const PageHome(),
        const PageHotdeal(),
        const Center(child: Text('쿠폰함', style: TextStyle(fontSize: 20))),
        const Center(child: Text('베스트', style: TextStyle(fontSize: 20))),
        const Center(child: Text('상시특가', style: TextStyle(fontSize: 20))),
      ],
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
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            child: Row(
              children: [
                // 찜 목록 버튼
                IconButton(
                  onPressed: () {},
                  icon: Icon(Icons.favorite, size: 26, color: MyColors.secondary),
                ),
                // 사용자 정보 버튼
                IconButton(
                  onPressed: () {},
                  icon: Icon(Icons.person, size: 26, color: MyColors.secondary),
                ),
                // 설정 버튼
                IconButton(
                  onPressed: () {},
                  icon: Icon(Icons.settings, size: 26, color: MyColors.secondary),
                ),
              ],
            ),
          ),
        ],
      ),

      // ----- Body -----
      body: Container(color: MyColors.background1, width: double.infinity, height: double.infinity, child: _pageStack()),

      // ----- 쿠폰함 버튼 -----
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 46),
          FloatingActionButton(
            onPressed: () => _changePage(couponButtonIndex), // 가운데 버튼 인덱스
            shape: const CircleBorder(),
            backgroundColor: _selectedIndex == couponButtonIndex ? MyColors.primary : MyColors.text1,
            foregroundColor: Colors.white,
            elevation: 0,
            child: SvgPicture.asset('assets/icons/icon_coupon.svg', width: 32, height: 20),
          ),
          const SizedBox(height: 6),
          MyText('쿠폰함', style: TextStyle(fontSize: 14, color: _selectedIndex == couponButtonIndex ? MyColors.primary : MyColors.text1)),
        ],
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
                  _menuButton('assets/icons/icon_auction.svg', 14, 19, '옥션', 3),
                  _menuButton('assets/icons/icon_hot_deal.svg', 14, 18, '핫딜', 4),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // --------------------------------------------------
  // 페이지 전환 메서드
  // --------------------------------------------------
  void _changePage(int pageIndex) {
    setState(() {
      _selectedIndex = pageIndex;
    });
  }

  // --------------------------------------------------
  // 메뉴 버튼 위젯
  // --------------------------------------------------
  Widget _menuButton(String svgAssetPath, double width, double height, String label, int index) {
    // 일반 메뉴 버튼 (SvgPicture 사용)
    return Expanded(
      child: GestureDetector(
        onTap: () {
          _changePage(index);
        },
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SvgPicture.asset(
              svgAssetPath,
              width: width,
              height: height,
              colorFilter: ColorFilter.mode(_selectedIndex == index ? MyColors.primary : MyColors.icon1, BlendMode.srcIn),
            ),
            const SizedBox(height: 10),
            MyText(label, style: TextStyle(color: _selectedIndex == index ? MyColors.primary : MyColors.text1, fontSize: 14)),
          ],
        ),
      ),
    );
  }
}
