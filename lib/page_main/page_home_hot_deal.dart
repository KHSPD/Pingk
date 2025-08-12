import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
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

  // ------------------------------------------- -------
  // build
  // --------------------------------------------------
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(0, 30, 0, 0),
      child: ListView(
        children: [
          // ----- 타이틀 및 더보기 버튼 -----
          Container(
            margin: const EdgeInsets.fromLTRB(30, 20, 30, 0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const MyText(
                  '오늘의 핫딜',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: MyColors.text1),
                ),
                const Spacer(),
                SvgPicture.asset('assets/icons/icon_arrow_right.svg', width: 16, height: 11, colorFilter: ColorFilter.mode(MyColors.icon1, BlendMode.srcIn)),
              ],
            ),
          ),
          // ----- 오늘의 핫딜 리스트 -----
          SizedBox(
            height: 336,
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
            margin: const EdgeInsets.fromLTRB(30, 60, 30, 10),
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
      ),
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
      width: 250,
      margin: const EdgeInsets.fromLTRB(20, 5, 0, 5),
      decoration: BoxDecoration(
        color: MyColors.background1,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: MyColors.shadow2, spreadRadius: 0, blurRadius: 4, offset: const Offset(2, 2))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ----- 상품 이미지 -----
          Container(
            width: double.infinity,
            height: 216,
            decoration: BoxDecoration(
              color: MyColors.background2,
              borderRadius: BorderRadius.only(topLeft: Radius.circular(12), topRight: Radius.circular(12)),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.only(topLeft: Radius.circular(12), topRight: Radius.circular(12)),
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
          // ----- 상품 정보 -----
          Container(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
            child: Column(
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
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // ----- 할인률 -----
                      Container(
                        width: 52,
                        height: 23,

                        decoration: BoxDecoration(color: MyColors.background4, borderRadius: BorderRadius.circular(20)),
                        alignment: Alignment.center,
                        child: RichText(
                          text: TextSpan(
                            text: '${MyFN.discountRate(item.originalPrice, item.price)}%',
                            style: const TextStyle(fontSize: 14, color: Colors.white, fontWeight: FontWeight.w600),
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
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                MyFN.formatNumberWithComma(item.price),
                                style: const TextStyle(fontSize: 23, color: MyColors.text1, fontWeight: FontWeight.w800),
                                overflow: TextOverflow.ellipsis,
                              ),
                              Container(
                                margin: const EdgeInsets.fromLTRB(2, 0, 0, 4),
                                child: Text(
                                  '원',
                                  style: const TextStyle(fontSize: 11, color: MyColors.text1, fontWeight: FontWeight.w300),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
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
      margin: const EdgeInsets.fromLTRB(30, 0, 30, 0),
      padding: const EdgeInsets.fromLTRB(0, 16, 0, 16),
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
                  style: const TextStyle(fontSize: 13, color: MyColors.text2, fontWeight: FontWeight.w600),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  item.name,
                  style: const TextStyle(fontSize: 16, color: MyColors.text1, fontWeight: FontWeight.w400),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          // ----- 알림 종 아이콘 -----
          Container(
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
        ],
      ),
    );
  }
}
