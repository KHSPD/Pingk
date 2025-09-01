import 'package:flutter/material.dart';
import 'package:pingk/common/_temp_items.dart';
import 'package:pingk/common/item_info.dart';
import 'package:pingk/common/my_styles.dart';

// ====================================================================================================
// CouponBox
// ====================================================================================================
class CouponBox extends StatefulWidget {
  const CouponBox({super.key});

  @override
  State<CouponBox> createState() => _CouponBoxState();
}

class _CouponBoxState extends State<CouponBox> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  final int _totalPages = 3;

  // --------------------------------------------------
  // Lifecycle Methods
  // --------------------------------------------------
  @override
  void initState() {
    debugPrint('CouponBox : initState');
    super.initState();
  }

  @override
  void dispose() {
    debugPrint('CouponBox : dispose');
    _pageController.dispose();
    super.dispose();
  }

  // --------------------------------------------------
  // 이전 페이지
  // --------------------------------------------------
  void _previousPage() {
    if (_currentPage > 0) {
      _pageController.previousPage(duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
    }
  }

  // --------------------------------------------------
  // 다음 페이지
  // --------------------------------------------------
  void _nextPage() {
    if (_currentPage < _totalPages - 1) {
      _pageController.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
    }
  }

  // --------------------------------------------------
  // build
  // --------------------------------------------------
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: MyColors.background1,
        borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // 상단 핸들바
          Container(
            margin: const EdgeInsets.only(top: 12, bottom: 20),
            width: 40,
            height: 4,
            decoration: BoxDecoration(color: MyColors.color1, borderRadius: BorderRadius.circular(2)),
          ),

          const SizedBox(height: 20),

          Container(
            width: double.infinity,
            height: 151,
            margin: const EdgeInsets.symmetric(horizontal: 40),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: MyColors.color2, width: 1),
            ),
            child: Image.asset('assets/sample_barcode.png', width: double.infinity, height: 151, fit: BoxFit.fitWidth),
          ),

          const SizedBox(height: 40),

          // 쿠폰 목록
          Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: double.infinity,
                height: 120,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: _totalPages,
                  onPageChanged: (index) {
                    setState(() {
                      _currentPage = index;
                    });
                  },
                  itemBuilder: (context, index) {
                    final GeneralItem item = TempItems.generalItems[index];
                    return _couponCard(item);
                  },
                ),
              ),

              // 왼쪽 화살표 버튼
              if (_currentPage > 0)
                Positioned(
                  left: 20,
                  top: 33,
                  child: GestureDetector(
                    onTap: _previousPage,
                    child: const Icon(Icons.arrow_back_ios, color: MyColors.color2, size: 20),
                  ),
                ),

              // 오른쪽 화살표 버튼
              if (_currentPage < _totalPages - 1)
                Positioned(
                  right: 20,
                  top: 33,
                  child: GestureDetector(
                    onTap: _nextPage,
                    child: const Icon(Icons.arrow_forward_ios, color: MyColors.color2, size: 20),
                  ),
                ),
            ],
          ),

          const SizedBox(height: 30),
        ],
      ),
    );
  }

  // --------------------------------------------------
  // 쿠폰 카드
  // --------------------------------------------------
  Widget _couponCard(GeneralItem item) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        width: double.infinity,
        height: 85,
        margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
        child: Stack(
          children: [
            // ----- 상품 이미지 -----
            Positioned(
              top: 0,
              left: 0,
              child: ClipOval(
                child: Image.network(
                  item.thumbnail,
                  width: 64,
                  height: 64,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    color: MyColors.color4,
                    child: const Icon(Icons.image_not_supported, color: MyColors.color2, size: 32),
                  ),
                ),
              ),
            ),
            // ----- 브랜드명 -----
            Positioned(
              top: 14,
              left: 80,
              child: Text(
                item.brand,
                style: const TextStyle(fontSize: 13, color: MyColors.text2, fontWeight: FontWeight.w600),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            // ----- 제품명 -----
            Positioned(
              top: 30,
              left: 80,
              right: 80,
              child: Text(
                item.name,
                style: const TextStyle(fontSize: 16, color: MyColors.text1, fontWeight: FontWeight.w400),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            // ----- 남은 날짜 -----
            Positioned(
              top: 20,
              right: 16,
              child: Container(
                width: 48,
                height: 26,
                decoration: BoxDecoration(color: MyColors.color2, borderRadius: BorderRadius.circular(25)),
                alignment: Alignment.center,
                child: Text(
                  'D-12',
                  style: TextStyle(fontSize: 15, color: MyColors.text4, fontWeight: FontWeight.w700),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
