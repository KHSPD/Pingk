import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:pingk/common/my_styles.dart';
import 'package:pingk/common/my_functions.dart';
import 'package:pingk/common/item_info.dart';
import 'package:pingk/common/_temp_items.dart';
import 'package:pingk/common/my_widget.dart';

// ====================================================================================================
// BodyHomeLimited
// ====================================================================================================
class BodyHomeLimited extends StatefulWidget {
  const BodyHomeLimited({super.key});

  @override
  State<BodyHomeLimited> createState() => _BodyHomeLimitedState();
}

class _BodyHomeLimitedState extends State<BodyHomeLimited> {
  final List<GeneralItem> todaysHotDealDatas = TempItems.todaysHotDealDatas.sublist(0, 7);
  final List<GeneralItem> comingSoonHotDealDatas = TempItems.comingSoonHotDealDatas;

  // --------------------------------------------------
  // Lifecycle Methods
  // --------------------------------------------------
  @override
  void initState() {
    debugPrint('BodyHomeLimited : initState');
    super.initState();
  }

  @override
  void dispose() {
    debugPrint('BodyHomeLimited : dispose');
    super.dispose();
  }

  // --------------------------------------------------
  // build
  // --------------------------------------------------
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: ListView(
        children: [
          SizedBox(height: 30),
          // ----- 한정특가 타이틀 -----
          GestureDetector(
            onTap: () {
              context.go('/main/limited-deal');
            },
            child: Container(
              margin: const EdgeInsets.fromLTRB(30, 10, 30, 0),
              child: Row(
                children: [
                  RichText(
                    text: TextSpan(
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Color(0xFF393939), letterSpacing: -0.3),
                      children: [
                        const TextSpan(text: '놓치기 아쉬운 '),
                        const TextSpan(
                          text: '한정특가',
                          style: TextStyle(color: Color(0xFFFF437A)),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(width: 6),
                  SvgPicture.asset('assets/icons/icon_greater_then.svg', width: 7, height: 11),
                ],
              ),
            ),
          ),
          SizedBox(height: 10),

          // ----- 한정특가 리스트 -----
          SizedBox(
            height: 370,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.only(right: 20),
              itemCount: todaysHotDealDatas.length,
              itemBuilder: (context, index) {
                return _todaysLimitedDealCard(todaysHotDealDatas[index]);
              },
            ),
          ),

          // ----- 다가오는 한정특가 타이틀 -----
          GestureDetector(
            onTap: () {
              context.go('/main/limited-deal');
            },
            child: Container(
              margin: const EdgeInsets.fromLTRB(30, 50, 30, 0),
              child: Row(
                children: [
                  RichText(
                    text: TextSpan(
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Color(0xFF393939), letterSpacing: -0.3),
                      children: [
                        const TextSpan(text: '다가오는 '),
                        const TextSpan(
                          text: '한정특가 ',
                          style: TextStyle(color: Color(0xFFFF437A)),
                        ),
                        const TextSpan(text: '미리보기!'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 10),

          // ----- 다가오는 한정특가 리스트 -----
          Column(children: comingSoonHotDealDatas.map((item) => _comingSoonLimitedDealCard(item, isNotified: false, onToggleNotify: () {})).toList()),
          SizedBox(height: 120),
        ],
      ),
    );
  }

  // --------------------------------------------------
  // 한정특가 상품 카드
  // --------------------------------------------------
  Widget _todaysLimitedDealCard(GeneralItem item) {
    return GestureDetector(
      onTap: () {
        context.pushNamed('deal-detail', pathParameters: {'itemId': item.id});
      },
      child: Container(
        width: 250,
        margin: const EdgeInsets.fromLTRB(20, 10, 0, 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          boxShadow: [MyShadows.gray1],
          gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, stops: [0.6286, 0.6286], colors: [Color(0xFFF6F1F1), Colors.white]),
        ),
        child: Stack(
          children: [
            // ----- 상품 이미지 -----
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Align(alignment: Alignment.center, child: MyNetworkImage(item.thumbnail, width: 220, height: 220)),
            ),

            // ----- 브랜드명 -----
            Positioned(
              top: 235,
              left: 23,
              child: Text(
                item.brand,
                style: const TextStyle(fontSize: 14, color: Color(0xFFBEBEBE), fontWeight: FontWeight.w500, letterSpacing: -0.4),
              ),
            ),

            // ----- 상품명 -----
            Positioned(
              top: 255,
              left: 23,
              child: Text(
                item.name,
                style: const TextStyle(fontSize: 18, color: Color(0xFF393939), fontWeight: FontWeight.w600, letterSpacing: -0.3),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),

            // ----- 할인률 -----
            Positioned(
              bottom: 27,
              left: 23,
              child: Container(
                width: 52,
                height: 23,
                decoration: BoxDecoration(color: Color(0xFFFDEEF2), borderRadius: BorderRadius.circular(20)),
                alignment: Alignment.center,
                child: Text(
                  '${MyFN.discountRate(item.originalPrice, item.price)}%',
                  style: const TextStyle(fontFamily: 'Numbers', fontSize: 14, color: Color(0xFFFF437A), fontWeight: FontWeight.w700),
                ),
              ),
            ),

            // ----- 정상가 가격 -----
            Positioned(
              bottom: 49,
              right: 23,
              child: Text(
                '${MyFN.formatNumberWithComma(item.originalPrice)}원',
                style: const TextStyle(
                  fontFamily: 'Numbers',
                  fontSize: 14,
                  color: Color(0xFFBEBEBE),
                  fontWeight: FontWeight.w300,
                  decoration: TextDecoration.lineThrough,
                  decorationColor: Color(0xFFBEBEBE),
                  letterSpacing: -0.4,
                ),
              ),
            ),

            // ----- 판매가  -----
            Positioned(
              right: 24,
              bottom: 10,
              child: Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: MyFN.formatNumberWithComma(item.price),
                      style: TextStyle(fontFamily: 'Numbers', color: Color(0xFFFF437A), fontSize: 26, fontWeight: FontWeight.w700, letterSpacing: -0.1),
                    ),
                    WidgetSpan(
                      alignment: PlaceholderAlignment.top,
                      child: Transform.translate(
                        offset: const Offset(2, -6),
                        child: Text(
                          '원',
                          style: const TextStyle(color: Color(0xFFFF437A), fontSize: 18, fontWeight: FontWeight.w500),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --------------------------------------------------
  // 다가오는 한정특가 상품 카드
  // --------------------------------------------------
  Widget _comingSoonLimitedDealCard(GeneralItem item, {required bool isNotified, required VoidCallback onToggleNotify}) {
    return GestureDetector(
      onTap: () {
        context.pushNamed('deal-detail', pathParameters: {'itemId': item.id});
      },
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
            // ----- 상품 이미지 -----
            Positioned(
              top: 0,
              left: 21.5,
              bottom: 0,
              child: SizedBox(
                width: 68,
                height: 98,
                child: Center(child: ClipOval(child: MyNetworkImage(item.thumbnail, width: 68, height: 68))),
              ),
            ),
            // ----- 브랜드명 -----
            Positioned(
              top: 28,
              left: 103.5,
              child: Text(
                item.brand,
                style: const TextStyle(fontSize: 14, color: Color(0xFFBEBEBE), fontWeight: FontWeight.w500, letterSpacing: -0.4),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            // ----- 제품명 -----
            Positioned(
              top: 47,
              left: 103.5,
              right: 70,
              child: Text(
                item.name,
                style: const TextStyle(fontSize: 16, color: Color(0xFF393939), fontWeight: FontWeight.w700, letterSpacing: -0.3),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            // ----- 남은 날짜 -----
            Positioned(
              top: 36.75,
              right: 24,
              child: Container(
                width: 49,
                height: 21,
                decoration: BoxDecoration(color: Color(0xFFFDEEF2), borderRadius: BorderRadius.circular(13)),
                alignment: Alignment.center,
                child: Text(
                  'D-3',
                  style: TextStyle(fontSize: 15, color: Color(0xFFFF437A), fontWeight: FontWeight.w700),
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
