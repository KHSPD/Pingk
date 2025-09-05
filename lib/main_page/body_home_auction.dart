import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:pingk/_common/api_request.dart';
import 'package:pingk/_common/my_datetime.dart';
import 'package:pingk/_common/my_functions.dart';
import 'package:pingk/_common/item_info.dart';
import 'package:pingk/_common/my_widget.dart';
import '../_common/my_styles.dart';

// ====================================================================================================
// BodyHomeAuctionItems
// ====================================================================================================
class BodyHomeAuctionItems extends StatefulWidget {
  const BodyHomeAuctionItems({super.key});

  @override
  State<BodyHomeAuctionItems> createState() => _BodyHomeAuctionItemsState();
}

class _BodyHomeAuctionItemsState extends State<BodyHomeAuctionItems> {
  final PageController _pageController = PageController(viewportFraction: 0.73);
  final _itemDatas = ApiRequest().auctionItemListNotifier;
  int _selectedItemIdx = 0;
  bool _isLoading = true;

  // --------------------------------------------------
  // Lifecycle Methods
  // --------------------------------------------------
  @override
  void initState() {
    super.initState();
    _itemDatas.addListener(_onItemListChanged);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ApiRequest().fetchAuctionItemList().then((_) {
        setState(() {
          _isLoading = false;
        });
      });
    });
  }

  @override
  void dispose() {
    _itemDatas.removeListener(_onItemListChanged);
    _pageController.dispose();
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
  // build
  // --------------------------------------------------
  @override
  Widget build(BuildContext context) {
    final itemList = _itemDatas.value;

    return Container(
      decoration: BoxDecoration(color: Color(0xFFFBF9F9)),
      child: Column(
        children: [
          // ----- 상단 문구 -----
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(50, 20, 50, 0),
            child: Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: '핑크옥션',
                    style: TextStyle(color: Color(0xFFFF437A), fontSize: 28, fontWeight: FontWeight.w600, letterSpacing: -0.84),
                  ),
                  TextSpan(
                    text: '으로\n저렴한 쇼핑하세요',
                    style: TextStyle(color: Color(0xFF393939), fontSize: 28, fontWeight: FontWeight.w600, height: 1.2, letterSpacing: -0.84),
                  ),
                ],
              ),
            ),
          ),

          // ----- 페이지 넘버 -----
          Container(
            width: double.infinity,
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.fromLTRB(70, 0, 70, 0),
            child: RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: '${_selectedItemIdx + 1}',
                    style: TextStyle(color: Color(0xFF393939), fontSize: 14, fontWeight: FontWeight.w600, letterSpacing: -0.3),
                  ),
                  TextSpan(
                    text: ' / ${itemList.length}',
                    style: TextStyle(color: Color(0xFF969696), fontSize: 14, fontWeight: FontWeight.w600, letterSpacing: -0.3),
                  ),
                ],
              ),
            ),
          ),

          // ----- 상품 목록 -----
          SizedBox(
            width: double.infinity,
            height: 418,
            child: _isLoading
                ? SizedBox(
                    height: 120,
                    child: Center(child: CircularProgressIndicator(color: Color(0xFFFF437A))),
                  )
                : PageView.builder(
                    controller: _pageController,
                    itemCount: itemList.length,
                    onPageChanged: (index) {
                      setState(() {
                        _selectedItemIdx = index;
                      });
                    },
                    itemBuilder: (context, index) {
                      return AnimatedBuilder(
                        animation: _pageController,
                        builder: (context, child) {
                          double scale = 1.0;
                          double bgColorIntensity = 0.0;

                          if (_pageController.position.haveDimensions && _pageController.page != null) {
                            // PageController가 준비된 경우 (렌더링 중)
                            final double v = (_pageController.page! - index).abs();
                            scale = (1 - (v * 0.2)).clamp(0.8, 1.0);
                            bgColorIntensity = (v * 0.5).clamp(0.0, 0.5);
                          } else {
                            // PageController가 준비되지 않은 경우(최초 렌더링 시)
                            scale = index == 0 ? 1.0 : 0.8;
                            bgColorIntensity = index == 0 ? 0.0 : 0.5;
                          }

                          return Transform.scale(
                            scale: scale,
                            child: _itemAuctionCard(itemList[index], bgCololIntensity: bgColorIntensity),
                          );
                        },
                      );
                    },
                  ),
          ),

          // ----- 더 보기 버튼 -----
          GestureDetector(
            onTap: () {
              context.go('/main/auction');
            },
            child: Container(
              width: double.infinity,
              height: 52,
              margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                gradient: const LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [Color(0xFFFF8CA6), Color(0xFFFF437A), Color(0xFFFF437A), Color(0xFFFF8CA6)],
                  stops: [0.0, 0.3, 0.7, 1.0],
                ),
                boxShadow: [MyShadows.gray1],
              ),
              child: Center(
                child: Text(
                  '더 많은 핑크옥션 보기',
                  style: const TextStyle(color: Color(0xFFFFFFFF), fontSize: 16, fontWeight: FontWeight.w600, letterSpacing: -0.3),
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
  Widget _itemAuctionCard(AuctionItem item, {double bgCololIntensity = 0.0}) {
    return GestureDetector(
      onTap: () {
        context.pushNamed('detail-auction', pathParameters: {'itemId': item.id});
      },
      child: Container(
        margin: const EdgeInsets.fromLTRB(0, 15, 0, 15),
        decoration: BoxDecoration(
          color: Color(0xFFFFFFFF),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: Color(0xFFF6F1F1), width: 1),
          boxShadow: [MyShadows.gray1],
        ),
        child: Stack(
          children: [
            // ----- 상품 이미지 -----
            Positioned(top: 20, left: 0, right: 0, child: Center(child: MyNetworkImage(item.thumbnail, width: 200, height: 200))),

            // ----- 가로줄 -----
            Positioned(top: 231, left: 0, right: 0, child: Container(height: 1, color: Color(0xFFF6F1F1))),

            // ----- 브랜드 -----
            Positioned(
              top: 254,
              left: 24,
              right: 24,
              child: Text(
                item.brand,
                style: const TextStyle(fontSize: 14, color: Color(0xFFBEBEBE), fontWeight: FontWeight.w500),
              ),
            ),

            // ----- 상품명  -----
            Positioned(
              top: 274,
              left: 24,
              right: 24,
              child: Text(
                item.productName,
                style: const TextStyle(fontSize: 20, color: Color(0xFF393939), fontWeight: FontWeight.w600),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ),

            // ----- 카운트 다운 -----
            Positioned(
              top: 334,
              left: 24,
              child: Container(
                width: 106,
                height: 26,
                decoration: BoxDecoration(color: Color(0xFFFFEFF4), borderRadius: BorderRadius.circular(20)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset('assets/icons/icon_alarm_clock.svg', width: 11, height: 12),
                    //
                    SizedBox(width: 2),
                    //
                    item.endAt.isAfter(MyDateTime().getDateTime())
                        ? TweenAnimationBuilder<Duration>(
                            duration: item.endAt.difference(MyDateTime().getDateTime()),
                            tween: Tween<Duration>(begin: item.endAt.difference(MyDateTime().getDateTime()), end: Duration.zero),
                            builder: (BuildContext context, Duration value, Widget? child) {
                              final hours = value.inHours.toString().padLeft(2, '0');
                              final minutes = (value.inMinutes % 60).toString().padLeft(2, '0');
                              final seconds = (value.inSeconds % 60).toString().padLeft(2, '0');
                              return Text(
                                '$hours:$minutes:$seconds',
                                style: const TextStyle(fontFamily: 'SpoqaHanSansNeo', color: Color(0xFFFF437A), fontWeight: FontWeight.w500, fontSize: 14, letterSpacing: -0.2),
                                textAlign: TextAlign.center,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              );
                            },
                          )
                        : Text(
                            '00:00:00',
                            style: const TextStyle(fontFamily: 'SpoqaHanSansNeo', color: Color(0xFFFF437A), fontWeight: FontWeight.w500, fontSize: 14, letterSpacing: -0.2),
                            textAlign: TextAlign.center,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                  ],
                ),
              ),
            ),

            // ----- Last Price -----
            Positioned(
              top: 314,
              right: 24,
              child: Text(
                '현재 옥션가',
                style: const TextStyle(fontSize: 14, color: Color(0xFFBEBEBE), fontWeight: FontWeight.w500, letterSpacing: -0.4),
              ),
            ),

            Positioned(
              top: 330,
              right: 24,
              child: Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: MyFN.formatNumberWithComma(item.lastPrice),
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

            // ----- 오버레이 색상 -----
            Positioned(
              top: 0,
              right: 0,
              left: 0,
              bottom: 0,
              child: Container(
                decoration: BoxDecoration(color: Color.lerp(Color(0x00FFFFFF), Color(0xFFFF437A), bgCololIntensity), borderRadius: BorderRadius.circular(18)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
