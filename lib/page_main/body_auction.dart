import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:pingk/common/api_request.dart';
import 'package:pingk/common/item_info.dart';
import 'package:pingk/common/my_styles.dart';
import 'package:pingk/common/my_functions.dart';
import 'package:pingk/common/my_widget.dart';

// ====================================================================================================
// BodyAuction
// ====================================================================================================
class BodyAuction extends StatefulWidget {
  const BodyAuction({super.key});

  @override
  State<BodyAuction> createState() => _BodyAuctionState();
}

class _BodyAuctionState extends State<BodyAuction> {
  final ValueNotifier<List<AuctionItem>> _itemDatas = ApiRequest().auctionItemListNotifier;

  // --------------------------------------------------
  // Lifecycle Methods
  // --------------------------------------------------
  @override
  void initState() {
    debugPrint('BodyAuction : initState');
    super.initState();
    _itemDatas.addListener(_onItemListChanged);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ApiRequest().fetchAuctionItemList();
    });
  }

  @override
  void dispose() {
    debugPrint('BodyAuction : dispose');
    _itemDatas.removeListener(_onItemListChanged);
    super.dispose();
  }

  // --------------------------------------------------
  // 아이템 목록 변경 이벤트
  // --------------------------------------------------
  void _onItemListChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  // --------------------------------------------------
  // Pull to Refresh
  // --------------------------------------------------
  Future<void> _onRefresh() async {
    ApiRequest().fetchAuctionItemList(forceRefresh: true);
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
              padding: const EdgeInsets.fromLTRB(29, 30, 29, 0),
              child: RichText(
                text: const TextSpan(
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.w600, letterSpacing: -0.3),
                  children: [
                    TextSpan(
                      text: '최저가 쿠폰,',
                      style: TextStyle(color: Color(0xFFFF437A)),
                    ),
                    TextSpan(
                      text: '\n핑크옥션으로 잡자!',
                      style: TextStyle(color: Color(0xFF393939), height: 1.2),
                    ),
                  ],
                ),
              ),
            ),

            // ----- 총 상품 갯수 -----
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(40, 40, 40, 0),
              child: Text(
                '총 ${_itemDatas.value.length}개의 쿠폰',
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF969696), letterSpacing: -0.3),
              ),
            ),

            // ----- 경매 상품 리스트 -----
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _itemDatas.value.length,
              itemBuilder: (context, index) {
                return _itemAuctionCard(_itemDatas.value[index]);
              },
            ),

            const SizedBox(height: 120),
          ],
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
        context.pushNamed('auction-detail', pathParameters: {'itemId': item.idx});
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

            // ----- 옥션가 -----
            Positioned(
              top: 100,
              left: 30,
              right: 150,
              child: Row(
                children: [
                  Text(
                    '현재 옥션가',
                    style: const TextStyle(fontSize: 14, color: Color(0xFFBEBEBE), fontWeight: FontWeight.w500, letterSpacing: -0.4),
                  ),
                  const Spacer(),
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: MyFN.formatNumberWithComma(item.lastPrice),
                          style: TextStyle(fontFamily: 'Numbers', color: Color(0xFFFF437A), fontSize: 16, fontWeight: FontWeight.w700, letterSpacing: -0.2),
                        ),
                        WidgetSpan(
                          alignment: PlaceholderAlignment.top,
                          child: Transform.translate(
                            offset: const Offset(0, -1.5),
                            child: Text(
                              '원',
                              style: const TextStyle(color: Color(0xFFFF437A), fontSize: 14, fontWeight: FontWeight.w500),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // ----- 정상가 -----
            Positioned(
              top: 120,
              left: 30,
              right: 150,
              child: Row(
                children: [
                  Text(
                    '상품 정상가',
                    style: const TextStyle(fontSize: 14, color: Color(0xFFBEBEBE), fontWeight: FontWeight.w500, letterSpacing: -0.4),
                  ),
                  const Spacer(),
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: MyFN.formatNumberWithComma(item.originalPrice),
                          style: TextStyle(fontFamily: 'Numbers', color: Color(0xFFBEBEBE), fontSize: 16, fontWeight: FontWeight.w700, letterSpacing: -0.2),
                        ),
                        WidgetSpan(
                          alignment: PlaceholderAlignment.top,
                          child: Transform.translate(
                            offset: const Offset(0, -1.5),
                            child: Text(
                              '원',
                              style: const TextStyle(color: Color(0xFFBEBEBE), fontSize: 14, fontWeight: FontWeight.w500),
                            ),
                          ),
                        ),
                      ],
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
}
