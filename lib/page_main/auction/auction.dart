import 'package:flutter/material.dart';
import 'package:pingk/common/_temp_items.dart';
import 'package:pingk/common/item_info.dart';
import 'package:pingk/common/my_colors.dart';
import 'package:pingk/common/my_functions.dart';

class PageAuction extends StatefulWidget {
  const PageAuction({super.key});

  @override
  State<PageAuction> createState() => _PageAuctionState();
}

class _PageAuctionState extends State<PageAuction> {
  final List<AuctionItem> itemList = TempItems.auctionItems;
  int _selectedCategoryIndex = 0;
  final List<String> _categories = ['카페/디저트', '외식', '배달', '생활', '취미', '일식', '양식', '분식'];

  @override
  Widget build(BuildContext context) {
    return Container(
      color: MyColors.background2,
      child: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return [
            // ----- 상단 문구 -----
            SliverToBoxAdapter(
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(30, 20, 30, 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    RichText(
                      text: const TextSpan(
                        style: TextStyle(fontSize: 34, color: MyColors.text1),
                        children: [
                          TextSpan(
                            text: '경매',
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                          TextSpan(
                            text: '로 저렴하게',
                            style: TextStyle(fontWeight: FontWeight.w300),
                          ),
                        ],
                      ),
                    ),
                    RichText(
                      text: const TextSpan(
                        style: TextStyle(fontSize: 34, color: MyColors.text1),
                        children: [
                          TextSpan(
                            text: '쿠폰 쇼핑',
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                          TextSpan(
                            text: '하세요!',
                            style: TextStyle(fontWeight: FontWeight.w300),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 20)),

            // ----- 카테고리 선택 -----
            SliverPersistentHeader(
              pinned: true,
              delegate: _CategoryHeaderDelegate(
                height: 50,
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  decoration: const BoxDecoration(
                    color: MyColors.background2,
                    border: Border(bottom: BorderSide(color: MyColors.border1, width: 0.5)),
                  ),
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: _categories.length,
                    padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedCategoryIndex = index;
                          });
                        },
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 5),
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(color: _selectedCategoryIndex == index ? MyColors.primary : MyColors.button3, borderRadius: BorderRadius.circular(25)),
                          child: Text(
                            _categories[index],
                            style: TextStyle(
                              fontSize: 13,
                              color: _selectedCategoryIndex == index ? MyColors.text4 : MyColors.text1,
                              fontWeight: _selectedCategoryIndex == index ? FontWeight.w600 : FontWeight.w400,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 20)),
          ];
        },
        body: SizedBox(
          child: ListView.builder(
            itemCount: itemList.length,
            itemBuilder: (context, index) {
              return _itemAuctionCard(itemList[index]);
            },
          ),
        ),
      ),
    );
  }

  // --------------------------------------------------
  // 경매 상품 카드
  // --------------------------------------------------
  Widget _itemAuctionCard(AuctionItem item) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, '/auction-detail', arguments: item.id);
      },
      child: Container(
        width: double.infinity,
        height: 286,
        margin: const EdgeInsets.fromLTRB(30, 10, 30, 10),
        decoration: BoxDecoration(
          color: MyColors.background1,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [BoxShadow(color: MyColors.shadow2, spreadRadius: 4, blurRadius: 6, offset: const Offset(0, 0))],
        ),
        child: Stack(
          children: [
            // ----- 카운트 다운 -----
            Positioned(
              top: 10,
              right: 10,
              child: Container(
                width: 90,
                height: 27,
                decoration: BoxDecoration(color: MyColors.button5, borderRadius: BorderRadius.circular(15)),
                child: Center(
                  child: TweenAnimationBuilder<Duration>(
                    duration: item.endTime.difference(DateTime.now()),
                    tween: Tween<Duration>(begin: item.endTime.difference(DateTime.now()), end: Duration.zero),
                    onEnd: () {
                      setState(() {});
                    },
                    builder: (BuildContext context, Duration value, Widget? child) {
                      final hours = value.inHours.toString().padLeft(2, '0');
                      final minutes = (value.inMinutes % 60).toString().padLeft(2, '0');
                      final seconds = (value.inSeconds % 60).toString().padLeft(2, '0');
                      return Text(
                        '$hours:$minutes:$seconds',
                        style: const TextStyle(fontSize: 16, color: MyColors.text1, fontWeight: FontWeight.w600),
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      );
                    },
                  ),
                ),
              ),
            ),

            // ----- 상품명  -----
            Positioned(
              top: 64,
              left: 24,
              child: Text(
                item.name,
                style: const TextStyle(fontSize: 21, color: MyColors.text1, fontWeight: FontWeight.w500),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ),

            // ----- 브랜드 -----
            Positioned(
              top: 90,
              left: 24,
              child: Text(
                item.brand,
                style: const TextStyle(fontSize: 13, color: MyColors.text1, fontWeight: FontWeight.w300),
              ),
            ),

            // ----- Last Price -----
            Positioned(
              top: 180,
              left: 24,
              child: Text(
                'Last Price',
                style: const TextStyle(fontSize: 12, color: MyColors.text2, fontWeight: FontWeight.w300),
              ),
            ),

            // ----- 최종 가격 -----
            Positioned(
              top: 190,
              left: 24,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    MyFN.formatNumberWithComma(item.lastPrice),
                    style: const TextStyle(fontSize: 40, fontWeight: FontWeight.w700, color: MyColors.text1),
                  ),
                  const SizedBox(width: 4),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: const Text(
                      '원',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.w300, color: MyColors.text1),
                    ),
                  ),
                ],
              ),
            ),

            // ----- 상품 이미지 -----
            Positioned(
              top: 124,
              right: 24,
              width: 113,
              height: 113,
              child: ClipOval(
                child: Container(
                  decoration: BoxDecoration(color: MyColors.background3),
                  child: AspectRatio(
                    aspectRatio: 1,
                    child: Image.network(
                      item.thumbnail,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: MyColors.background3,
                          child: const Icon(Icons.image_not_supported, color: MyColors.text2, size: 40),
                        );
                      },
                    ),
                  ),
                ),
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
  final Widget child;
  final double height;
  _CategoryHeaderDelegate({required this.height, required this.child});

  @override
  double get minExtent => height;

  @override
  double get maxExtent => height;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return child;
  }

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }
}
