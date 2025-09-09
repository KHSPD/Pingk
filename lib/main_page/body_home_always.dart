import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:pingk/_common/api_service.dart';
import 'package:pingk/_common/my_functions.dart';
import 'package:pingk/_common/item_info.dart';
import 'package:pingk/_common/my_widget.dart';

// ====================================================================================================
// BodyHomeAlways
// ====================================================================================================
class BodyHomeAlways extends StatefulWidget {
  const BodyHomeAlways({super.key});

  @override
  State<BodyHomeAlways> createState() => _BodyHomeAlwaysState();
}

class _BodyHomeAlwaysState extends State<BodyHomeAlways> {
  final _itemDatas = ApiService().bestItemListNotifier;

  // --------------------------------------------------
  // Lifecycle Methods
  // --------------------------------------------------
  @override
  void initState() {
    super.initState();
    _itemDatas.addListener(_onItemListChanged);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ApiService().fetchBestItemList();
    });
  }

  @override
  void dispose() {
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
  // 찜 버튼 토글
  // --------------------------------------------------
  void _onFavoriteToggle(AlwayslItem item) {
    item.toggleFavorite();
    setState(() {});
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
          // ----- 상시특가 타이틀 -----
          GestureDetector(
            onTap: () {
              context.go('/main/always');
            },
            child: Container(
              margin: const EdgeInsets.fromLTRB(30, 10, 30, 0),
              child: Row(
                children: [
                  RichText(
                    text: TextSpan(
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Color(0xFF393939), letterSpacing: -0.3),
                      children: [
                        const TextSpan(text: '지금 가장 '),
                        const TextSpan(
                          text: '인기있는 ',
                          style: TextStyle(color: Color(0xFFFF437A)),
                        ),
                        const TextSpan(text: '쿠폰은?'),
                      ],
                    ),
                  ),

                  const SizedBox(width: 6),
                  SvgPicture.asset('assets/icons/icon_greater_then.svg', width: 7, height: 11),
                ],
              ),
            ),
          ),
          SizedBox(height: 20),

          // ----- 베스트 상품 리스트 -----
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 22),
            itemCount: _itemDatas.value.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, mainAxisSpacing: 30, crossAxisSpacing: 10, childAspectRatio: 168 / 275),
            itemBuilder: (context, i) {
              return _bestDealCard(_itemDatas.value[i], () {
                _onFavoriteToggle(_itemDatas.value[i]);
              });
            },
          ),

          SizedBox(height: 120),
        ],
      ),
    );
  }

  // --------------------------------------------------
  // 베스트 상품 카드
  // --------------------------------------------------
  Widget _bestDealCard(AlwayslItem item, VoidCallback onWishToggle) {
    return GestureDetector(
      onTap: () {
        context.pushNamed('deal-detail', pathParameters: {'itemId': item.id});
      },
      child: SizedBox(
        width: 168,
        height: 275,

        child: Stack(
          children: [
            // ----- 상품 이미지 -----
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Container(
                decoration: BoxDecoration(color: Color(0xFFF6F1F1), borderRadius: BorderRadius.circular(15)),
                child: ClipRRect(borderRadius: BorderRadius.circular(15), child: MyNetworkImage(item.thumbnail, width: 168, height: 168)),
              ),
            ),

            // ----- 찜 버튼 -----
            Positioned(
              top: 134,
              right: 12,
              child: GestureDetector(
                onTap: onWishToggle,
                child: Icon(item.isFavorite ? Icons.favorite : Icons.favorite_border, color: item.isFavorite ? Color(0xFFFF437A) : Color(0xFFD0D0D0), size: 22),
              ),
            ),

            // ----- 브랜드 -----
            Positioned(
              top: 182,
              left: 10,
              child: Text(
                item.brand,
                style: const TextStyle(fontSize: 13, color: Color(0xFFBEBEBE), fontWeight: FontWeight.w500, letterSpacing: -0.3),
              ),
            ),

            // ----- 상품명 -----
            Positioned(
              top: 198,
              left: 10,
              right: 10,
              child: Text(
                item.title,
                style: const TextStyle(fontSize: 16, color: Color(0xFF393939), fontWeight: FontWeight.w600, letterSpacing: -0.3),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),

            // ----- 할인률 -----
            Positioned(
              left: 10,
              bottom: 4,
              child: Container(
                width: 52,
                height: 23,
                decoration: BoxDecoration(color: Color(0xFFFDEEF2), borderRadius: BorderRadius.circular(20)),
                alignment: Alignment.center,
                child: Text(
                  '${MyFN.discountRate(item.originPrice, item.price)}%',
                  style: const TextStyle(fontFamily: 'Numbers', fontSize: 14, color: Color(0xFFFF437A), fontWeight: FontWeight.w700),
                ),
              ),
            ),

            // ----- 정상가 가격 -----
            Positioned(
              bottom: 28,
              right: 10,
              child: Text(
                '${MyFN.formatNumberWithComma(item.originPrice)}원',
                style: const TextStyle(
                  fontFamily: 'Numbers',
                  fontSize: 14,
                  color: Color(0xFFBEBEBE),
                  fontWeight: FontWeight.w400,
                  decoration: TextDecoration.lineThrough,
                  decorationColor: Color(0xFFBEBEBE),
                  letterSpacing: -0.4,
                ),
              ),
            ),

            // ----- 판매가  -----
            Positioned(
              right: 10,
              bottom: 0,
              child: Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: MyFN.formatNumberWithComma(item.price),
                      style: TextStyle(fontFamily: 'Numbers', color: Color(0xFFFF437A), fontSize: 20, fontWeight: FontWeight.w700, letterSpacing: -0.1),
                    ),
                    WidgetSpan(
                      alignment: PlaceholderAlignment.top,
                      child: Transform.translate(
                        offset: const Offset(1, -5),
                        child: Text(
                          '원',
                          style: const TextStyle(color: Color(0xFFFF437A), fontSize: 16, fontWeight: FontWeight.w500),
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
