import 'package:flutter/material.dart';
import 'package:pingk/_common/api_request.dart';
import 'package:pingk/_common/item_info.dart';

// ====================================================================================================
// AlwaysDealPage
// ====================================================================================================
class Always extends StatefulWidget {
  const Always({super.key});

  @override
  State<Always> createState() => _AlwaysState();
}

class _AlwaysState extends State<Always> {
  List<String> categoryList = ['ALL', 'BEAUTY', 'FASHION', 'LIFESTYLE', 'FOOD', 'HOME', 'ELECTRONICS', 'SPORTS', 'BOOKS', 'MUSIC', 'MOVIES', 'GAMES', 'TOYS', 'OTHERS'];
  int selectedCategoryIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xFFFFFFFF),
      child: NestedScrollView(
        // ----- NestedScrollView -headerSliverBuilder -----
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return [
            // ----- 상단 문구 -----
            SliverToBoxAdapter(
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(29, 30, 29, 0),
                child: RichText(
                  text: const TextSpan(
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.w600, letterSpacing: -0.3),
                    children: [
                      TextSpan(
                        text: '상시특가로 매일매일',
                        style: TextStyle(color: Color(0xFFFF437A)),
                      ),
                      TextSpan(
                        text: '\n똑똑한 쇼핑하세요!',
                        style: TextStyle(color: Color(0xFF393939), height: 1.2),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 10)),

            // ----- 카테고리 선택 -----
            SliverPersistentHeader(
              pinned: true,
              delegate: _CategoryHeaderDelegate(categoryList, selectedCategoryIndex, (index) {
                setState(() {
                  selectedCategoryIndex = index;
                });
              }),
            ),
          ];
        },

        // ----- NestedScrollView - body -----
        body: ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: ApiRequest().auctionItemListNotifier.value.length,
          itemBuilder: (context, index) {
            return _readyLimitedDealCard(ApiRequest().auctionItemListNotifier.value[index]);
          },
        ),
      ),
    );
  }

  // --------------------------------------------------
  // 다가오는 한정특가 상품 카드
  // --------------------------------------------------
  Widget _readyLimitedDealCard(AuctionItem item) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        width: double.infinity,
        height: 98,
        margin: const EdgeInsets.symmetric(horizontal: 21, vertical: 5),
        decoration: BoxDecoration(
          border: Border.all(color: const Color(0xFFF6F1F1), width: 1),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Stack(
          children: [
            // ----- 제품명 -----
            Positioned(
              top: 47,
              left: 103.5,
              right: 70,
              child: Text(
                item.productName,
                style: const TextStyle(fontSize: 16, color: Color(0xFF393939), fontWeight: FontWeight.w700, letterSpacing: -0.3),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ====================================================================================================
// CategoryHeaderDelegate
// ====================================================================================================
class _CategoryHeaderDelegate extends SliverPersistentHeaderDelegate {
  final List<String> categoryList;
  final int selectedIndex;
  final Function(int) onCategorySelected;

  _CategoryHeaderDelegate(this.categoryList, this.selectedIndex, this.onCategorySelected);

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: Colors.white,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 21, vertical: 10),
        child: Row(
          children: categoryList.asMap().entries.map((entry) {
            int index = entry.key;
            String category = entry.value;
            bool isSelected = index == selectedIndex;
            return GestureDetector(
              onTap: () {
                onCategorySelected(index);
              },
              child: Container(
                margin: const EdgeInsets.only(right: 8),
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: isSelected ? const Color(0xFFFF437A) : Colors.transparent,
                  borderRadius: BorderRadius.circular(30),
                  border: isSelected ? null : Border.all(color: const Color(0xFFBEBEBE), width: 1),
                ),
                alignment: Alignment.center,
                child: Text(
                  category,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                    color: isSelected ? Colors.white : const Color(0xFFBEBEBE),
                    letterSpacing: -0.3,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  @override
  double get maxExtent => 58;

  @override
  double get minExtent => 58;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }
}
