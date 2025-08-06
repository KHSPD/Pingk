import 'package:flutter/material.dart';
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

  // ========== IndexedStack으로 모든 페이지 생성 ==========
  Widget _pageStack() {
    return IndexedStack(
      index: _selectedIndex,
      children: [
        const PageHome(),
        const Center(child: Text('검색 페이지', style: TextStyle(fontSize: 20))),
        const Center(child: Text('쿠폰함 페이지', style: TextStyle(fontSize: 20))),
        const Center(child: Text('찜 페이지', style: TextStyle(fontSize: 20))),
        const Center(child: Text('알림 페이지', style: TextStyle(fontSize: 20))),
      ],
    );
  }

  // ========== build ==========
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.background1,
      // ----- 상단바 -----
      appBar: AppBar(
        backgroundColor: MyColors.background1,
        automaticallyImplyLeading: false,
        actions: [
          // 사용자 정보 버튼
          Container(
            margin: const EdgeInsets.only(right: 16),
            child: IconButton(
              onPressed: () {
                // 사용자 정보 페이지로 이동
              },
              icon: Icon(
                Icons.person_outline,
                size: 30,
                color: MyColors.secondary,
              ),
            ),
          ),
        ],
      ),
      // ----- Body -----
      body: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: _pageStack(),
      ),

      // ----- 쿠폰함 버튼 -----
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Container(
        margin: const EdgeInsets.only(bottom: 0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 54),
            FloatingActionButton(
              onPressed: () => _changePage(2), // 가운데 버튼 인덱스
              shape: const CircleBorder(),
              backgroundColor: MyColors.button1,
              foregroundColor: Colors.white,
              elevation: 0,
              child: const Icon(Icons.card_giftcard, size: 32),
            ),
            const SizedBox(height: 4),
            const Text(
              '쿠폰함',
              style: TextStyle(
                fontSize: 14,
                color: Colors.black54,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
      // ----- 하단 메뉴바 -----
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Color.fromRGBO(0, 0, 0, 0.1),
              blurRadius: 8,
              offset: const Offset(0, -2),
            ),
          ],
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
          ),
          child: BottomAppBar(
            color: MyColors.background1,
            child: Row(
              children: [
                _menuButton(Icons.home_outlined, '홈', 0),
                _menuButton(Icons.search_outlined, '검색', 1),
                const SizedBox(width: 84),
                _menuButton(Icons.favorite_outline, '찜', 3),
                _menuButton(Icons.notifications_outlined, '알림', 4),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ========== 페이지 전환 메서드 ==========
  void _changePage(int pageIndex) {
    setState(() {
      _selectedIndex = pageIndex;
    });
  }

  // ========== 메뉴 버튼 위젯 ==========
  Widget _menuButton(IconData iconData, String label, int index) {
    // 일반 메뉴 버튼
    return Expanded(
      child: GestureDetector(
        onTap: () {
          _changePage(index);
        },
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              iconData,
              size: 28,
              color: _selectedIndex == index
                  ? MyColors.primary
                  : MyColors.text1,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: _selectedIndex == index
                    ? MyColors.primary
                    : MyColors.text1,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
