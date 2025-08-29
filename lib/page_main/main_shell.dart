import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:pingk/page_main/coupon_box.dart';
import '../common/my_colors.dart';

// ====================================================================================================
// MainShell
// ====================================================================================================
class MainShell extends StatelessWidget {
  final Widget child;

  const MainShell({super.key, required this.child});

  // --------------------------------------------------
  // build
  // --------------------------------------------------
  @override
  Widget build(BuildContext context) {
    debugPrint('MainShell : build');
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
      body: Container(color: MyColors.background1, width: double.infinity, height: double.infinity, child: child),

      // ----- 쿠폰함 버튼 -----
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 46),
          FloatingActionButton(
            onPressed: () {
              showModalBottomSheet(context: context, isScrollControlled: true, backgroundColor: Colors.transparent, builder: (context) => const CouponBox());
            },
            shape: const CircleBorder(),
            backgroundColor: MyColors.primary,
            foregroundColor: Colors.white,
            elevation: 0,
            child: SvgPicture.asset('assets/icons/icon_coupon.svg', width: 32, height: 20),
          ),
          const SizedBox(height: 6),
          Text('쿠폰함', style: TextStyle(fontSize: 14, color: MyColors.text3)),
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
          width: null,
          child: ClipRRect(
            borderRadius: const BorderRadius.only(topLeft: Radius.circular(16), topRight: Radius.circular(16)),
            child: BottomAppBar(
              color: MyColors.background1,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _menuButton(context, 'assets/icons/icon_home.svg', 18, 18, '홈', '/main/home'),
                  _menuButton(context, 'assets/icons/icon_like.svg', 18, 16, '찜', '/main/favorite'),
                  const SizedBox(width: 84),
                  _menuButton(context, 'assets/icons/icon_auction.svg', 14, 19, '핑크옥션', '/main/auction'),
                  _menuButton(context, 'assets/icons/icon_hot_deal.svg', 14, 18, '한정특가', '/main/limited-deal'),
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
  Widget _menuButton(BuildContext context, String svgAssetPath, double width, double height, String label, String route) {
    final currentLocation = GoRouterState.of(context).uri.toString();
    final isSelected = currentLocation == route;

    return Container(
      width: 60,
      height: 60,
      alignment: Alignment.center,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        hoverColor: Colors.transparent,
        onTap: () {
          context.go(route);
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SvgPicture.asset(svgAssetPath, width: width, height: height, colorFilter: ColorFilter.mode(isSelected ? MyColors.primary : MyColors.icon1, BlendMode.srcIn)),
            const SizedBox(height: 10),
            Text(label, style: TextStyle(color: isSelected ? MyColors.primary : MyColors.text1, fontSize: 14)),
          ],
        ),
      ),
    );
  }
}
