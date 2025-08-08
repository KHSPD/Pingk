import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:pingk/common/my_colors.dart';
import 'package:pingk/common/my_function.dart';
import 'package:pingk/common/item_info.dart';
import 'package:pingk/common/_temp_items.dart';
import 'package:pingk/common/my_text.dart';

// ====================================================================================================
// 홈 - 핫딜 상품 목록
// ====================================================================================================
class HomeHotDealItems extends StatefulWidget {
  const HomeHotDealItems({super.key});

  @override
  State<HomeHotDealItems> createState() => _HomeHotDealItemsState();
}

class _HomeHotDealItemsState extends State<HomeHotDealItems> {
  final List<GeneralItem> todaysHotDealDatas = TempItems.todaysHotDealDatas.sublist(0, 7);
  final List<GeneralItem> comingSoonHotDealDatas = TempItems.comingSoonHotDealDatas;

  // --------------------------------------------------
  // build
  // --------------------------------------------------
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        // ----- 타이틀 및 더보기 버튼 -----
        Container(
          margin: const EdgeInsets.fromLTRB(20, 20, 20, 0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Lottie.asset('assets/lottie/icon_2.json', width: 40, height: 40, fit: BoxFit.contain),
              const SizedBox(width: 4),
              const MyText(
                '오늘의 핫딜',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: MyColors.text1),
              ),
              const Spacer(),
              GestureDetector(
                onTap: () {},
                child: const Text(
                  '상품 더보기',
                  style: TextStyle(fontSize: 14, color: MyColors.text2, fontWeight: FontWeight.w500),
                ),
              ),
            ],
          ),
        ),
        // ----- 오늘의 핫딜 리스트 -----
        SizedBox(
          height: 330,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.only(right: 20),
            itemCount: todaysHotDealDatas.length,
            itemBuilder: (context, index) {
              return _todaysHotDealCard(todaysHotDealDatas[index], () => _toggleWish(index));
            },
          ),
        ),

        // ----- 다가올 핫딜 타이틀 -----
        Container(
          margin: const EdgeInsets.fromLTRB(20, 30, 20, 10),
          child: const Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                '다가올 핫딜',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: MyColors.text1),
              ),
            ],
          ),
        ),
        // ----- 다가올 핫딜 리스트 -----
        Column(children: comingSoonHotDealDatas.map((item) => _comingSoonHotDealCard(item, isNotified: false, onToggleNotify: () {})).toList()),
        SizedBox(height: 20),
      ],
    );
  }

  // --------------------------------------------------
  // 찜 버튼 토글
  // --------------------------------------------------
  void _toggleWish(int index) {
    setState(() {
      todaysHotDealDatas[index].isWished = !todaysHotDealDatas[index].isWished;
    });
  }

  // --------------------------------------------------
  // 오늘의 핫딜 상품 카드
  // --------------------------------------------------
  Widget _todaysHotDealCard(GeneralItem item, VoidCallback onWishToggle) {
    return Container(
      width: 220,
      margin: const EdgeInsets.fromLTRB(20, 5, 0, 5),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: MyColors.background1,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: MyColors.shadow2, spreadRadius: 0, blurRadius: 4, offset: const Offset(2, 2))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            alignment: Alignment.bottomRight,
            children: [
              // ----- 상품 이미지 -----
              Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: MyColors.border1, // 얇은 회색 선
                    width: 0.5,
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: AspectRatio(
                    aspectRatio: 1, // 정사각형 비율 유지
                    child: Image.network(
                      item.thumbnail,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: MyColors.background2,
                          child: const Icon(Icons.image_not_supported, color: MyColors.text2, size: 40),
                        );
                      },
                    ),
                  ),
                ),
              ),
              // ----- 찜 버튼 -----
              Padding(
                padding: const EdgeInsets.only(bottom: 10, right: 10),
                child: GestureDetector(
                  onTap: onWishToggle,
                  child: Icon(item.isWished ? Icons.favorite : Icons.favorite_border, color: item.isWished ? MyColors.primary : MyColors.secondary, size: 24),
                ),
              ),
            ],
          ),
          // ----- 상품 정보 -----
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 브랜드명
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Text(
                  item.brand,
                  style: const TextStyle(fontSize: 12, color: MyColors.text2, fontWeight: FontWeight.w400),
                ),
              ),
              // 상품명
              Text(
                item.name,
                style: const TextStyle(fontSize: 14, color: MyColors.text1, fontWeight: FontWeight.w600),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),

              Container(
                width: double.infinity,
                margin: const EdgeInsets.only(top: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // ----- 할인률 -----
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
                      decoration: BoxDecoration(
                        color: MyColors.primary,
                        borderRadius: BorderRadius.circular(8), // 모서리 라운드 처리
                      ),
                      alignment: Alignment.center,
                      child: RichText(
                        text: TextSpan(
                          text: '${MyFN.discountRate(item.originalPrice, item.price)}',
                          style: const TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold),
                          children: [
                            const TextSpan(
                              text: '%',
                              style: TextStyle(fontSize: 12, color: Colors.white, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // ----- 가격 정보 -----
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          '${MyFN.formatNumberWithComma(item.originalPrice)}원',
                          style: const TextStyle(fontSize: 11, color: MyColors.text2, decoration: TextDecoration.lineThrough, decorationColor: MyColors.text2),
                        ),
                        Text(
                          '${MyFN.formatNumberWithComma(item.price)}원',
                          style: const TextStyle(fontSize: 16, color: MyColors.text1, fontWeight: FontWeight.bold),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // --------------------------------------------------
  // 다가올 핫딜 상품 카드
  // --------------------------------------------------
  Widget _comingSoonHotDealCard(GeneralItem item, {required bool isNotified, required VoidCallback onToggleNotify}) {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 0, 20, 0),
      padding: const EdgeInsets.fromLTRB(10, 16, 10, 16),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: MyColors.border1, width: 0.5)),
      ),
      child: Row(
        children: [
          // ----- 상품 이미지 -----
          Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: MyColors.border1, width: 0.5),
            ),
            child: ClipOval(
              child: Image.network(
                item.thumbnail,
                width: 70,
                height: 70,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  width: 70,
                  height: 70,
                  color: MyColors.imageBgColor,
                  child: const Icon(Icons.image_not_supported, color: MyColors.secondary, size: 32),
                ),
              ),
            ),
          ),
          const SizedBox(width: 18),
          // ----- 브랜드명, 상품명, 남은 날짜 -----
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.brand,
                  style: const TextStyle(fontSize: 13, color: MyColors.text2, fontWeight: FontWeight.w500),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  item.name,
                  style: const TextStyle(fontSize: 16, color: MyColors.text1, fontWeight: FontWeight.bold),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.access_time, size: 16, color: MyColors.primary),
                    const SizedBox(width: 4),
                    Text(
                      'D-3',
                      style: const TextStyle(fontSize: 12, color: MyColors.primary, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // ----- 알림 종 아이콘 -----
          GestureDetector(
            onTap: onToggleNotify,
            child: Container(
              width: 50,
              height: 26,
              decoration: BoxDecoration(color: isNotified ? MyColors.primary : MyColors.secondary, borderRadius: BorderRadius.circular(25)),
              child: Icon(isNotified ? Icons.notifications_active : Icons.notifications_none, color: MyColors.icon4, size: 20),
            ),
          ),
        ],
      ),
    );
  }
}
