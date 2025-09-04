import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:pingk/main_page/coupon_box.dart';
import '../_common/my_styles.dart';

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
      backgroundColor: Color(0xFFFBF9F9),
      // ----- 상단바 -----
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Color(0xFFFBF9F9),
        title: Padding(padding: const EdgeInsets.only(left: 10), child: Image.asset('assets/logo_main_top.png', width: 78, height: 21)),
        actions: [
          IconButton(onPressed: () {}, icon: SvgPicture.asset('assets/icons/icon_search.svg', width: 20, height: 20)),
          IconButton(onPressed: () {}, icon: SvgPicture.asset('assets/icons/icon_my_info.svg', width: 18, height: 20)),
          const SizedBox(width: 20),
        ],
      ),

      // ----- Body with Stack -----
      body: Stack(
        children: [
          // 메인 컨텐츠
          SizedBox(width: double.infinity, height: double.infinity, child: child),

          // 하단 메뉴바
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              padding: const EdgeInsets.fromLTRB(8, 12, 8, 0),
              decoration: BoxDecoration(
                color: Color(0xFFFFFFFF),
                boxShadow: [MyShadows.pink2],
                borderRadius: const BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
              ),
              child: SafeArea(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _menuButton(context, 'assets/icons/icon_home.svg', 18, 18, '홈', '/main/home'),
                    _menuButton(context, 'assets/icons/icon_medal.svg', 15, 20, '핑크옥션', '/main/auction'),
                    const SizedBox(width: 84),
                    _menuButton(context, 'assets/icons/icon_lightning_bolt.svg', 15, 20, '한정특가', '/main/limited'),
                    _menuButton(context, 'assets/icons/icon_heart.svg', 19, 17, '상시특가', '/main/always'),
                  ],
                ),
              ),
            ),
          ),

          // 쿠폰함 버튼
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: SafeArea(
              child: Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      showModalBottomSheet(context: context, isScrollControlled: true, backgroundColor: Colors.transparent, builder: (context) => const CouponBox());
                    },
                    child: Container(
                      width: 70,
                      height: 70,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Color(0xFFFFFFFF), width: 6),
                        gradient: const LinearGradient(
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                          colors: [Color(0xFFFF8CA6), Color(0xFFFF437A), Color(0xFFFF437A), Color(0xFFFF8CA6)],
                          stops: [0.0, 0.3, 0.7, 1.0],
                        ),
                      ),
                      child: Center(child: SvgPicture.asset('assets/icons/icon_coupon.svg', width: 28, height: 17)),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text('쿠폰함', style: TextStyle(fontSize: 13, color: Color(0xFF393939))),
                  const SizedBox(height: 7),
                ],
              ),
            ),
          ),
        ],
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
            SvgPicture.asset(svgAssetPath, width: width, height: height, colorFilter: ColorFilter.mode(isSelected ? Color(0xFFFF437A) : Color(0xFF393939), BlendMode.srcIn)),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(color: isSelected ? Color(0xFFFF437A) : Color(0xFF393939), fontSize: 13, fontWeight: FontWeight.w400),
            ),
          ],
        ),
      ),
    );
  }
}
