import 'package:flutter/material.dart';
import 'package:pingk/common/_temp_items.dart';
import 'package:pingk/common/item_info.dart';
import 'package:pingk/common/my_colors.dart';
import 'package:pingk/common/my_functions.dart';
import 'package:pingk/common/my_text.dart';

class PageLimitedDeal extends StatefulWidget {
  const PageLimitedDeal({super.key});

  @override
  State<PageLimitedDeal> createState() => _PageLimitedDealState();
}

class _PageLimitedDealState extends State<PageLimitedDeal> {
  final List<GeneralItem> todayItemList = TempItems.todaysHotDealDatas;
  final List<GeneralItem> comingSoonItemList = TempItems.comingSoonHotDealDatas;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.background1,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 30),
              // ----- 오늘의 한정특가 문구 -----
              const MyText(
                '          오늘의 한정특가',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: MyColors.text1),
              ),

              const SizedBox(height: 20),
              // 오늘의 한정특가 상품들
              ...todayItemList.map((item) => _todayItemCard(item)),

              const SizedBox(height: 30),
              // ----- 오늘의 한정특가 문구 -----
              const MyText(
                '          다가올 한정특가',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: MyColors.text1),
              ),

              const SizedBox(height: 20),

              // 다가올 한정특가 상품들
              ...comingSoonItemList.map(
                (item) => _comingSoonItemCard(
                  item,
                  isNotified: false,
                  onToggleNotify: () {
                    // 알림 토글 로직
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // --------------------------------------------------
  // 오늘의 한정특가 카드
  // --------------------------------------------------
  Widget _todayItemCard(GeneralItem item) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, '/deal-detail', arguments: item.id);
      },
      child: Container(
        width: double.infinity,
        height: 220,
        margin: const EdgeInsets.fromLTRB(30, 10, 30, 10),
        decoration: BoxDecoration(
          color: MyColors.background1,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: MyColors.border1, width: 0.5),
        ),
        child: Stack(
          children: [
            // ----- 카운트 다운 -----
            Positioned(
              top: 15,
              right: 15,
              child: Container(
                width: 90,
                height: 27,
                decoration: BoxDecoration(color: MyColors.button5, borderRadius: BorderRadius.circular(15)),
                child: Center(
                  child: MyText(
                    '00:30:21',
                    style: const TextStyle(fontSize: 16, color: MyColors.text1, fontWeight: FontWeight.w600),
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ),

            // ----- 상품명  -----
            Positioned(
              top: 58,
              left: 24,
              child: MyText(
                item.name,
                style: const TextStyle(fontSize: 21, color: MyColors.text1, fontWeight: FontWeight.w500),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ),

            // ----- 브랜드 -----
            Positioned(
              top: 88,
              left: 24,
              child: MyText(
                item.brand,
                style: const TextStyle(fontSize: 13, color: MyColors.text1, fontWeight: FontWeight.w300),
              ),
            ),

            Positioned(
              bottom: 60,
              left: 24,
              child: Container(
                width: 52,
                height: 23,
                decoration: BoxDecoration(color: MyColors.background4, borderRadius: BorderRadius.circular(20)),
                alignment: Alignment.center,
                child: RichText(
                  text: TextSpan(
                    text: '${MyFN.discountRate(item.originalPrice, item.price)}%',
                    style: const TextStyle(fontFamily: 'Pretendard', fontSize: 14, color: Colors.white, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ),

            // ----- 가격 -----
            Positioned(
              left: 24,
              bottom: 24,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 3),
                    child: MyText(
                      '${MyFN.formatNumberWithComma(item.originalPrice)}원',
                      style: const TextStyle(
                        fontSize: 16,
                        color: MyColors.text2,
                        fontWeight: FontWeight.w300,
                        decoration: TextDecoration.lineThrough,
                        decorationColor: MyColors.text2,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  MyText(
                    MyFN.formatNumberWithComma(item.price),
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w800, color: MyColors.text1),
                  ),
                  const SizedBox(width: 2),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 3),
                    child: const MyText(
                      '원',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w300, color: MyColors.text1),
                    ),
                  ),
                ],
              ),
            ),

            // ----- 상품 이미지 -----
            Positioned(
              right: 24,
              bottom: 24,
              width: 95,
              height: 95,
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

  // --------------------------------------------------
  // 다가올 한정특가 상품 카드
  // --------------------------------------------------
  Widget _comingSoonItemCard(GeneralItem item, {required bool isNotified, required VoidCallback onToggleNotify}) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, '/deal-detail', arguments: item.id);
      },
      child: Container(
        width: double.infinity,
        height: 85,
        margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
        decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: MyColors.border1, width: 0.5)),
        ),
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
                    color: MyColors.imageBgColor,
                    child: const Icon(Icons.image_not_supported, color: MyColors.secondary, size: 32),
                  ),
                ),
              ),
            ),
            // ----- 브랜드명 -----
            Positioned(
              top: 14,
              left: 80,
              child: MyText(
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
              child: MyText(
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
                decoration: BoxDecoration(color: MyColors.secondary, borderRadius: BorderRadius.circular(25)),
                alignment: Alignment.center,
                child: MyText(
                  'D-3',
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
