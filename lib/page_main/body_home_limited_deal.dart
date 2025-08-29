import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pingk/common/my_colors.dart';
import 'package:pingk/common/my_functions.dart';
import 'package:pingk/common/item_info.dart';
import 'package:pingk/common/_temp_items.dart';

// ====================================================================================================
// BodyHomeLimitedDeal
// ====================================================================================================
class BodyHomeLimitedDeal extends StatefulWidget {
  const BodyHomeLimitedDeal({super.key});

  @override
  State<BodyHomeLimitedDeal> createState() => _BodyHomeLimitedDealState();
}

class _BodyHomeLimitedDealState extends State<BodyHomeLimitedDeal> {
  final List<GeneralItem> todaysHotDealDatas = TempItems.todaysHotDealDatas.sublist(0, 7);
  final List<GeneralItem> comingSoonHotDealDatas = TempItems.comingSoonHotDealDatas;

  // --------------------------------------------------
  // Lifecycle Methods
  // --------------------------------------------------
  @override
  void initState() {
    debugPrint('BodyHomeLimitedDeal : initState');
    super.initState();
  }

  @override
  void dispose() {
    debugPrint('BodyHomeLimitedDeal : dispose');
    super.dispose();
  }

  // --------------------------------------------------
  // build
  // --------------------------------------------------
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        SizedBox(height: 30),
        // ----- 타이틀 및 더보기 버튼 -----
        GestureDetector(
          onTap: () {},
          child: Container(
            margin: const EdgeInsets.fromLTRB(30, 20, 30, 0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  '오늘의 한정특가',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: MyColors.text1),
                ),
                const Spacer(),
                SvgPicture.asset('assets/icons/icon_arrow_right.svg', width: 16, height: 11.34, colorFilter: ColorFilter.mode(MyColors.icon1, BlendMode.srcIn)),
              ],
            ),
          ),
        ),
        SizedBox(height: 10),
        // ----- 오늘의 한정특가 리스트 -----
        SizedBox(
          height: 336,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.only(right: 20),
            itemCount: todaysHotDealDatas.length,
            itemBuilder: (context, index) {
              return _todaysLimitedDealCard(todaysHotDealDatas[index], () => _toggleWish(index));
            },
          ),
        ),

        // ----- 다가올 한정특가 타이틀 -----
        GestureDetector(
          onTap: () {},
          child: Container(
            margin: const EdgeInsets.fromLTRB(30, 40, 30, 20),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  '다가올 한정특가',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: MyColors.text1),
                ),
                const Spacer(),
                SvgPicture.asset('assets/icons/icon_arrow_right.svg', width: 16, height: 11.34, colorFilter: ColorFilter.mode(MyColors.icon1, BlendMode.srcIn)),
              ],
            ),
          ),
        ),

        // ----- 다가올 핫딜 리스트 -----
        Column(children: comingSoonHotDealDatas.map((item) => _comingSoonLimitedDealCard(item, isNotified: false, onToggleNotify: () {})).toList()),
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
  // 오늘의 한정특가 상품 카드
  // --------------------------------------------------
  Widget _todaysLimitedDealCard(GeneralItem item, VoidCallback onWishToggle) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, '/deal-detail', arguments: item.id);
      },
      child: Container(
        width: 250,
        height: 336,
        margin: const EdgeInsets.fromLTRB(20, 5, 0, 5),
        decoration: BoxDecoration(
          color: MyColors.background1,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [BoxShadow(color: MyColors.shadow2, spreadRadius: 0, blurRadius: 4, offset: const Offset(2, 2))],
        ),
        child: Stack(
          children: [
            // ----- 상품 이미지 -----
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              bottom: 120,
              child: ClipRRect(
                borderRadius: const BorderRadius.only(topLeft: Radius.circular(12), topRight: Radius.circular(12)),
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
            // ----- 브랜드명 -----
            Positioned(
              top: 220,
              left: 16,
              child: Text(
                item.brand,
                style: const TextStyle(fontSize: 13, color: MyColors.text2, fontWeight: FontWeight.w600),
              ),
            ),

            // ----- 상품명 -----
            Positioned(
              top: 240,
              left: 16,
              child: Text(
                item.name,
                style: const TextStyle(fontSize: 16, color: MyColors.text1, fontWeight: FontWeight.w400),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            // ----- 할인률 -----
            Positioned(
              bottom: 16,
              left: 16,
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
            // ----- 오리지널 가격 -----
            Positioned(
              bottom: 38,
              right: 16,
              child: Text(
                '${MyFN.formatNumberWithComma(item.originalPrice)}원',
                style: const TextStyle(fontSize: 16, color: MyColors.text2, fontWeight: FontWeight.w300, decoration: TextDecoration.lineThrough, decorationColor: MyColors.text2),
              ),
            ),
            // ----- 판매가  -----
            Positioned(
              bottom: 12,
              right: 32,
              child: Text(
                MyFN.formatNumberWithComma(item.price),
                style: const TextStyle(fontSize: 23, color: MyColors.text1, fontWeight: FontWeight.w800),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            // ----- 원 -----
            Positioned(
              bottom: 15,
              right: 16,
              child: Text(
                '원',
                style: const TextStyle(fontSize: 16, color: MyColors.text1, fontWeight: FontWeight.w300),
                overflow: TextOverflow.ellipsis,
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
  Widget _comingSoonLimitedDealCard(GeneralItem item, {required bool isNotified, required VoidCallback onToggleNotify}) {
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
                decoration: BoxDecoration(color: MyColors.secondary, borderRadius: BorderRadius.circular(25)),
                alignment: Alignment.center,
                child: Text(
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
