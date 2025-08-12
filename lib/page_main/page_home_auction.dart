import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pingk/common/my_function.dart';
import 'package:pingk/common/item_info.dart';
import 'package:pingk/common/_temp_items.dart';
import 'package:pingk/common/my_text.dart';
import 'package:pingk/common/user_info.dart';
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
            height: 162,
            padding: const EdgeInsets.fromLTRB(30, 20, 30, 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                MyText(
                  '${UserInfo.nickName}님, 안녕하세요!',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w300, color: MyColors.text1),
                ),
                const SizedBox(height: 10),
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
            height: 356,
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
  Widget _itemCard(AuctionItem item) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 30),
      decoration: BoxDecoration(
        color: MyColors.background1,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: MyColors.shadow2, spreadRadius: 3, blurRadius: 10, offset: const Offset(5, 0))],
      ),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ----- 상세보기 화살표 -----
              Container(
                margin: const EdgeInsets.fromLTRB(0, 20, 20, 0),
                alignment: Alignment.centerRight,
                child: Container(
                  width: 29,
                  height: 29,
                  decoration: BoxDecoration(color: MyColors.secondary, shape: BoxShape.circle),
                  child: Center(child: SvgPicture.asset('assets/icons/icon_arrow_ne.svg', width: 14, height: 13)),
                ),
              ),
              SizedBox(height: 10),

              // ----- 상품명 & 브랜드 -----
              Container(
                margin: const EdgeInsets.fromLTRB(30, 0, 30, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    MyText(
                      item.name,
                      style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w500, color: MyColors.text1),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                    MyText(
                      item.brand,
                      style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w300, color: MyColors.text1),
                    ),
                  ],
                ),
              ),

              // ----- 가격 & 이미지 -----
              Container(
                margin: const EdgeInsets.fromLTRB(30, 0, 30, 0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 30),
                          MyText(
                            'last price',
                            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w300, color: MyColors.text2),
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              MyText(
                                MyFN.formatNumberWithComma(item.lastPrice),
                                style: const TextStyle(fontSize: 40, fontWeight: FontWeight.w700, color: MyColors.text1),
                              ),
                              Container(
                                margin: const EdgeInsets.fromLTRB(3, 0, 0, 9),
                                child: MyText(
                                  '원',
                                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w300, color: MyColors.text1),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 117,
                      height: 117,
                      child: ClipOval(
                        child: Image.network(
                          item.thumbnail,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              color: Colors.grey[300],
                              child: const Icon(Icons.image, size: 50, color: Colors.grey),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          // ----- 카운트 다운 -----
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 83,
              decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(16)),
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
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 40),
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
    );
  }
}
