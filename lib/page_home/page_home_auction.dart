import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pingk/common/my_functions.dart';
import 'package:pingk/common/item_info.dart';
import 'package:pingk/common/_temp_items.dart';
import 'package:pingk/common/my_widget.dart';
import '../common/my_colors.dart';

// ====================================================================================================
// 홈 - 경매 상품 목록
// ====================================================================================================
class HomeAuctionItems extends StatefulWidget {
  const HomeAuctionItems({super.key});

  @override
  State<HomeAuctionItems> createState() => _HomeAuctionItemsState();
}

class _HomeAuctionItemsState extends State<HomeAuctionItems> {
  final List<AuctionItem> itemList = TempItems.auctionItems;
  final PageController _pageController = PageController();
  int _selectedItemIdx = 0;

  // --------------------------------------------------
  // dispose
  // --------------------------------------------------
  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  // --------------------------------------------------
  // build
  // --------------------------------------------------
  @override
  Widget build(BuildContext context) {
    return Container(
      color: MyColors.background2,
      child: Column(
        children: [
          // ----- 상단 문구 -----
          Container(
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

          // ----- 상품 목록 -----
          SizedBox(
            height: 390,
            child: PageView.builder(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  _selectedItemIdx = index;
                });
              },
              itemCount: itemList.length,
              itemBuilder: (context, index) {
                return _itemAuctionCard(itemList[index]);
              },
            ),
          ),

          // ----- 페이지 인디케이터 -----
          Container(
            height: 7,
            margin: const EdgeInsets.fromLTRB(0, 16, 0, 40),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                itemList.length,
                (index) => Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(shape: BoxShape.circle, color: _selectedItemIdx == index ? MyColors.primary : MyColors.tertiary.withAlpha(80)),
                ),
              ),
            ),
          ),
        ],
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
        margin: const EdgeInsets.fromLTRB(30, 10, 30, 10),
        decoration: BoxDecoration(
          color: MyColors.background1,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [BoxShadow(color: MyColors.shadow2, spreadRadius: 4, blurRadius: 6, offset: const Offset(0, 0))],
        ),
        child: Stack(
          children: [
            // ----- 상세보기 버튼 -----
            Positioned(
              top: 24,
              right: 24,
              child: Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(color: MyColors.button2, shape: BoxShape.circle),
                child: Center(child: SvgPicture.asset('assets/icons/icon_arrow_ne.svg', width: 13, height: 12)),
              ),
            ),

            // ----- 상품명  -----
            Positioned(
              top: 70,
              left: 24,
              right: 24,
              child: MyText(
                item.name,
                style: const TextStyle(fontSize: 30, color: MyColors.text1, fontWeight: FontWeight.w600),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ),

            // ----- 브랜드 -----
            Positioned(
              top: 112,
              left: 24,
              right: 24,
              child: MyText(
                item.brand,
                style: const TextStyle(fontSize: 16, color: MyColors.text1, fontWeight: FontWeight.w300),
              ),
            ),

            // ----- Last Price -----
            Positioned(
              top: 196,
              left: 24,
              child: MyText(
                'Last Price',
                style: const TextStyle(fontSize: 16, color: MyColors.text2, fontWeight: FontWeight.w300),
              ),
            ),

            // ----- 최종 가격 -----
            Positioned(
              top: 210,
              left: 24,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  MyText(
                    MyFN.formatNumberWithComma(item.lastPrice),
                    style: const TextStyle(fontSize: 40, fontWeight: FontWeight.w700, color: MyColors.text1),
                  ),
                  const SizedBox(width: 4),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: const MyText(
                      '원',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.w300, color: MyColors.text1),
                    ),
                  ),
                ],
              ),
            ),

            // ----- 상품 이미지 -----
            Positioned(
              top: 140,
              right: 24,
              width: 120,
              height: 120,
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

            // ----- 카운트 다운 -----
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                height: 70,
                decoration: BoxDecoration(color: MyColors.button2, borderRadius: BorderRadius.circular(15)),
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
                      return MyText(
                        '$hours:$minutes:$seconds',
                        style: const TextStyle(color: MyColors.text4, fontWeight: FontWeight.w600, fontSize: 40),
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      );
                    },
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
