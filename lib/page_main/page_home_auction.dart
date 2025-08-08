import 'package:flutter/material.dart';
import 'package:pingk/common/my_function.dart';
import 'package:pingk/common/item_info.dart';
import 'package:pingk/common/_temp_items.dart';
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
      height: 654,
      color: MyColors.background2,
      child: Column(
        children: [
          // ----- 상단 문구 -----
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(30, 20, 30, 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  text: const TextSpan(
                    style: TextStyle(fontSize: 24, color: Colors.black87),
                    children: [
                      TextSpan(
                        text: '경매',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      TextSpan(text: '로 저렴하게'),
                    ],
                  ),
                ),
                RichText(
                  text: const TextSpan(
                    style: TextStyle(fontSize: 24, color: Colors.black87),
                    children: [
                      TextSpan(
                        text: '쿠폰 쇼핑',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      TextSpan(text: '하세요!'),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // ----- 상품 목록 -----
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  _selectedItemIdx = index;
                });
              },
              itemCount: itemList.length,
              itemBuilder: (context, index) {
                return _itemCard(itemList[index]);
              },
            ),
          ),

          // ----- 페이지 인디케이터 -----
          Container(
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
  Widget _itemCard(AuctionItem item) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: MyColors.background1,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: const Color.fromARGB(15, 191, 19, 19), spreadRadius: 5, blurRadius: 10, offset: const Offset(0, 0))],
      ),
      child: Column(
        children: [
          // ----- 카운트 다운 -----
          Container(
            alignment: Alignment.centerRight,
            child: Container(
              width: 124,
              margin: const EdgeInsets.fromLTRB(0, 10, 10, 20),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
              decoration: BoxDecoration(color: MyColors.tertiary, borderRadius: BorderRadius.circular(20)),
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
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  );
                },
              ),
            ),
          ),

          // ----- 상품 이미지 -----
          ClipOval(
            child: Image.network(
              item.thumbnail,
              fit: BoxFit.cover,
              width: 200,
              height: 200,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  height: 200,
                  width: 200,
                  color: Colors.grey[300],
                  child: const Icon(Icons.image, size: 50, color: Colors.grey),
                );
              },
            ),
          ),

          // ----- 상품 정보 -----
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.brand, style: const TextStyle(fontSize: 16, color: Colors.grey)),
                const SizedBox(height: 4),
                Text(item.name, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                const SizedBox(height: 20),
                Text('Last Price', style: const TextStyle(fontSize: 14, color: Colors.grey)),
                Row(
                  children: [
                    Text(
                      MyFN.formatNumberWithComma(item.lastPrice),
                      style: const TextStyle(fontSize: 40, fontWeight: FontWeight.bold, color: MyColors.text1),
                    ),
                    const SizedBox(width: 4),
                    Text('원', style: TextStyle(fontSize: 16, color: MyColors.text1)),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
