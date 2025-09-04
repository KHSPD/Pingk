import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:pingk/_common/api_request.dart';
import 'package:pingk/_common/item_info.dart';
import 'package:pingk/_common/my_datetime.dart';
import 'package:pingk/_common/my_styles.dart';
import 'package:pingk/_common/my_functions.dart';
import 'package:pingk/_common/my_widget.dart';

// ====================================================================================================
// BodyLimited
// ====================================================================================================
class BodyLimited extends StatefulWidget {
  const BodyLimited({super.key});

  @override
  State<BodyLimited> createState() => _BodyLimitedState();
}

class _BodyLimitedState extends State<BodyLimited> {
  final List<LimitedItem> _onSaleItemDatas = [];
  final List<LimitedItem> _readyItemDatas = [];

  // --------------------------------------------------
  // Lifecycle Methods
  // --------------------------------------------------
  @override
  void initState() {
    debugPrint('BodyLimited : initState');
    super.initState();
    ApiRequest().limitedItemListNotifier.addListener(_onItemListChanged);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ApiRequest().fetchLimitedItemList().then((_) {
        _onItemListChanged();
      });
    });
  }

  @override
  void dispose() {
    debugPrint('BodyLimited : dispose');
    ApiRequest().limitedItemListNotifier.removeListener(_onItemListChanged);
    super.dispose();
  }

  // --------------------------------------------------
  // 아이템 목록 변경 이벤트
  // --------------------------------------------------
  void _onItemListChanged() {
    _onSaleItemDatas.clear();
    _readyItemDatas.clear();
    final now = MyDateTime().getDateTime();
    for (var item in ApiRequest().limitedItemListNotifier.value) {
      if (item.startAt.isBefore(now)) {
        _onSaleItemDatas.add(item);
      } else {
        _readyItemDatas.add(item);
      }
    }
    if (mounted) {
      setState(() {});
    }
  }

  // --------------------------------------------------
  // Pull to Refresh
  // --------------------------------------------------
  Future<void> _onRefresh() async {
    ApiRequest().fetchLimitedItemList(forceRefresh: true);
    await Future.delayed(const Duration(milliseconds: 500));
  }

  // --------------------------------------------------
  // build
  // --------------------------------------------------
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xFFFAFAFA),
      child: RefreshIndicator(
        onRefresh: _onRefresh,
        displacement: 40.0,
        color: Color(0xFFFF437A),
        backgroundColor: Colors.white,
        child: ListView(
          children: [
            // ----- 상단 문구 -----
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(29, 30, 29, 20),
              child: RichText(
                text: const TextSpan(
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.w600, letterSpacing: -0.3),
                  children: [
                    TextSpan(
                      text: '기간한정',
                      style: TextStyle(color: Color(0xFFFF437A)),
                    ),
                    TextSpan(
                      text: '\n지금이 가장 저렴할 때!',
                      style: TextStyle(color: Color(0xFF393939), height: 1.2),
                    ),
                  ],
                ),
              ),
            ),

            ..._onSaleItemDatas.map((item) => _onSaleItemCard(item)),

            // ----- 다가오는 한정특가 타이틀 -----
            GestureDetector(
              onTap: () {
                context.go('/main/limited');
              },
              child: Container(
                margin: const EdgeInsets.fromLTRB(30, 50, 30, 10),
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

            ..._readyItemDatas.map((item) => _readyLimitedDealCard(item, isNotified: false)),

            // ----- 하단 여백 -----
            const SizedBox(height: 120),
          ],
        ),
      ),
    );
  }

  // --------------------------------------------------
  // On Sale 아이템 카드
  // --------------------------------------------------
  Widget _onSaleItemCard(LimitedItem item) {
    return GestureDetector(
      onTap: () {
        context.pushNamed('detail-limited', pathParameters: {'itemId': item.idx});
      },
      child: Container(
        width: double.infinity,
        height: 220,
        margin: const EdgeInsets.fromLTRB(30, 10, 30, 10),
        decoration: BoxDecoration(color: Color(0xFFFFFFFF), borderRadius: BorderRadius.circular(15), boxShadow: [MyShadows.pink3]),
        child: Stack(
          children: [
            // ----- 브랜드 -----
            Positioned(
              top: 34,
              left: 30,
              child: Text(
                item.brand,
                style: const TextStyle(fontSize: 14, color: Color(0xFFBEBEBE), fontWeight: FontWeight.w500, letterSpacing: -0.4),
              ),
            ),

            // ----- 상품명  -----
            Positioned(
              top: 54,
              left: 30,
              right: 110,
              child: Text(
                item.productName,
                style: const TextStyle(fontSize: 19, color: Color(0xFF393939), fontWeight: FontWeight.w600, letterSpacing: -0.3),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ),

            // ----- 정상가 -----
            Positioned(
              top: 102,
              left: 30,
              right: 150,
              child: RichText(
                text: TextSpan(
                  text: '${MyFN.formatNumberWithComma(item.originPrice)}원',
                  style: const TextStyle(
                    fontFamily: 'Numbers',
                    color: Color(0xFFBEBEBE),
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    letterSpacing: -0.4,
                    decoration: TextDecoration.lineThrough,
                    decorationColor: Color(0xFFBEBEBE),
                  ),
                ),
              ),
            ),

            // ----- 판매가 & 할인률 -----
            Positioned(
              top: 119,
              left: 30,
              right: 150,
              child: Row(
                children: [
                  // 판매가
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: MyFN.formatNumberWithComma(item.price),
                          style: TextStyle(fontFamily: 'Numbers', color: Color(0xFFFF437A), fontSize: 22, fontWeight: FontWeight.w700, letterSpacing: -0.2),
                        ),
                        WidgetSpan(
                          alignment: PlaceholderAlignment.top,
                          child: Transform.translate(
                            offset: const Offset(2, -3),
                            child: Text(
                              '원',
                              style: const TextStyle(color: Color(0xFFFF437A), fontSize: 14, fontWeight: FontWeight.w500),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(width: 10),

                  // 할인률
                  Container(
                    width: 52,
                    height: 23,
                    decoration: BoxDecoration(color: Color(0xFFFDEEF2), borderRadius: BorderRadius.circular(20)),
                    alignment: Alignment.center,
                    child: Text(
                      '${MyFN.discountRate(item.originPrice, item.price)}%',
                      style: const TextStyle(fontFamily: 'Numbers', fontSize: 14, color: Color(0xFFFF437A), fontWeight: FontWeight.w700),
                    ),
                  ),
                ],
              ),
            ),

            // ----- 상품 이미지 -----
            Positioned(
              top: 51,
              right: 25,
              width: 86,
              height: 86,
              child: Container(
                decoration: BoxDecoration(color: Color(0xFFF2F2F2), shape: BoxShape.circle),
                child: ClipOval(child: MyNetworkImage(item.thumbnail)),
              ),
            ),

            // ----- 카운트 다운 -----
            Positioned(
              left: 24,
              bottom: 31,
              right: 24,
              child: Container(
                width: 90,
                height: 27,
                decoration: BoxDecoration(color: Color(0xFFFDEEF2), borderRadius: BorderRadius.circular(15)),
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset('assets/icons/icon_alarm_clock.svg', width: 13, height: 13),
                      const SizedBox(width: 4),
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: '남은시간 | 1Day ',
                              style: const TextStyle(fontSize: 14, color: Color(0xFFFF437A), fontWeight: FontWeight.w500, letterSpacing: -0.3),
                            ),
                            TextSpan(
                              text: '00:00:00',
                              style: const TextStyle(fontFamily: 'Numbers', fontSize: 14, color: Color(0xFFFF437A), fontWeight: FontWeight.w500, letterSpacing: -0.3),
                            ),
                          ],
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
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
  // 다가오는 한정특가 상품 카드
  // --------------------------------------------------
  Widget _readyLimitedDealCard(LimitedItem item, {required bool isNotified}) {
    return GestureDetector(
      onTap: () {
        context.pushNamed('detail-limited', pathParameters: {'itemId': item.idx});
      },
      child: Container(
        width: double.infinity,
        height: 98,
        margin: const EdgeInsets.symmetric(horizontal: 21, vertical: 5),
        decoration: BoxDecoration(
          color: Colors.white,
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
                item.productName,
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
