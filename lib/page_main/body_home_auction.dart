import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:pingk/common/my_functions.dart';
import 'package:pingk/common/item_info.dart';
import 'package:pingk/common/_temp_items.dart';
import '../common/my_styles.dart';

// ====================================================================================================
// BodyHomeAuctionItems
// ====================================================================================================
class BodyHomeAuctionItems extends StatefulWidget {
  const BodyHomeAuctionItems({super.key});

  @override
  State<BodyHomeAuctionItems> createState() => _BodyHomeAuctionItemsState();
}

class _BodyHomeAuctionItemsState extends State<BodyHomeAuctionItems> {
  final List<AuctionItem> itemList = TempItems.auctionItems;
  final PageController _pageController = PageController(viewportFraction: 0.74);
  int _selectedItemIdx = 0;

  // --------------------------------------------------
  // Lifecycle Methods
  // --------------------------------------------------
  @override
  void initState() {
    debugPrint('BodyHomeAuctionItems : initState');
    super.initState();

    // 페이지뷰 최초 애니메이션 적용하기 위해 추가
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    debugPrint('BodyHomeAuctionItems : dispose');
    _pageController.dispose();
    super.dispose();
  }

  // --------------------------------------------------
  // build
  // --------------------------------------------------
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: Color(0xFFFBF9F9)),
      child: Column(
        children: [
          // ----- 상단 문구 -----
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(50, 20, 50, 10),
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

          // ----- 상품 목록 -----
          SizedBox(
            width: double.infinity,
            height: 418,
            child: PageView.builder(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  _selectedItemIdx = index;
                });
              },
              itemCount: itemList.length,
              itemBuilder: (context, index) {
                return AnimatedBuilder(
                  animation: _pageController,
                  builder: (context, child) {
                    double scale = 1.0;
                    double opacity = 1.0;
                    if (_pageController.position.haveDimensions) {
                      final double v = (_pageController.page! - index).abs();
                      scale = (1 - (v * 0.2)).clamp(0.8, 1.0);
                      opacity = (1 - (v * 0.5)).clamp(0.5, 1.0);
                    }
                    return Transform.scale(
                      scale: scale,
                      child: Opacity(opacity: opacity, child: _itemAuctionCard(itemList[index])),
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
                boxShadow: [MyShadows.type1],
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
  Widget _itemAuctionCard(AuctionItem item) {
    return GestureDetector(
      onTap: () {
        context.go('/main/auction');
      },
      child: Container(
        width: 300,
        height: 388,
        margin: const EdgeInsets.fromLTRB(0, 15, 0, 15),
        decoration: BoxDecoration(
          color: Color(0xFFFFFFFF),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: Color(0xFFF6F1F1), width: 1),
          boxShadow: [MyShadows.type1],
        ),
        child: Stack(
          children: [
            // ----- 상품 이미지 -----
            Positioned(
              top: 30,
              left: 0,
              right: 0,
              child: Center(
                child: SizedBox(
                  width: 180,
                  height: 180,
                  child: AspectRatio(aspectRatio: 1, child: Image.network(item.thumbnail, fit: BoxFit.cover)),
                ),
              ),
            ),

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
                item.name,
                style: const TextStyle(fontSize: 20, color: Color(0xFF393939), fontWeight: FontWeight.w600),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ),

            // ----- 카운트 다운 -----
            Positioned(
              top: 332,
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
                    TweenAnimationBuilder<Duration>(
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
                          style: const TextStyle(fontFamily: 'SpoqaHanSansNeo', color: Color(0xFFFF437A), fontWeight: FontWeight.w500, fontSize: 14, letterSpacing: -0.2),
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        );
                      },
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
          ],
        ),
      ),
    );
  }
}
