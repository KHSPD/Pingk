import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pingk/common/my_colors.dart';
import 'package:pingk/common/my_functions.dart';
import 'package:pingk/common/item_info.dart';
import 'package:pingk/common/_temp_items.dart';
import 'package:pingk/common/my_widget.dart';

// ====================================================================================================
// 홈 - 상시특가 상품 목록
// ====================================================================================================
class HomeDiscountItems extends StatefulWidget {
  const HomeDiscountItems({super.key});

  @override
  State<HomeDiscountItems> createState() => _HomeDiscountItemsState();
}

class _HomeDiscountItemsState extends State<HomeDiscountItems> {
  final List<GeneralItem> bestCouponDatas = TempItems.bestDatas.sublist(0, 7);
  final List<GeneralItem> discountDatas = TempItems.discountDatas.sublist(0, 7);

  // --------------------------------------------------
  // build
  // --------------------------------------------------
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        SizedBox(height: 30),
        // ----- 타이틀 및 더보기 버튼 -----
        Container(
          margin: const EdgeInsets.fromLTRB(30, 20, 30, 0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const MyText(
                '베스트 쿠폰',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: MyColors.text1),
              ),
              const Spacer(),
              SvgPicture.asset('assets/icons/icon_arrow_right.svg', width: 16, height: 11.34, colorFilter: ColorFilter.mode(MyColors.icon1, BlendMode.srcIn)),
            ],
          ),
        ),

        // ----- 베스트 쿠폰 리스트 -----
        SizedBox(
          child: Column(children: [for (int i = 0; i < (bestCouponDatas.length < 4 ? bestCouponDatas.length : 4); i++) _bestDealCard(bestCouponDatas[i], () => _toggleWish(i))]),
        ),
      ],
    );
  }

  // --------------------------------------------------
  // 찜 버튼 토글
  // --------------------------------------------------
  void _toggleWish(int index) {
    setState(() {
      bestCouponDatas[index].isWished = !bestCouponDatas[index].isWished;
    });
  }

  // --------------------------------------------------
  // 베스트 쿠폰 상품 카드
  // --------------------------------------------------
  Widget _bestDealCard(GeneralItem item, VoidCallback onWishToggle) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, '/deal-detail', arguments: item.id);
      },
      child: Container(
        width: double.infinity,
        height: 126,
        margin: const EdgeInsets.fromLTRB(30, 15, 30, 15),
        child: Stack(
          children: [
            // ----- 상품 이미지 -----
            Positioned(
              top: 0,
              left: 0,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(5),
                child: Container(
                  width: 126,
                  height: 126,
                  decoration: BoxDecoration(color: MyColors.background3, borderRadius: BorderRadius.circular(5)),
                  child: AspectRatio(
                    aspectRatio: 1,
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
            ),

            // ----- 찜 버튼 -----
            Positioned(
              top: 96,
              left: 96,
              child: GestureDetector(
                onTap: onWishToggle,
                child: Icon(item.isWished ? Icons.favorite : Icons.favorite_border, color: item.isWished ? MyColors.primary : MyColors.secondary, size: 22),
              ),
            ),

            // ----- 브랜드 -----
            Positioned(
              top: 2,
              left: 140,
              child: MyText(
                item.brand,
                style: const TextStyle(fontSize: 13, color: MyColors.text2, fontWeight: FontWeight.w600),
              ),
            ),

            // ----- 상품명 -----
            Positioned(
              top: 20,
              left: 140,
              right: 100,
              child: MyText(
                item.name,
                style: const TextStyle(fontSize: 16, color: MyColors.text1, fontWeight: FontWeight.w400),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),

            // ----- 할인률 -----
            Positioned(
              bottom: 0,
              left: 140,
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

            // ----- 판매가  -----
            Positioned(
              bottom: 0,
              right: 16,
              child: MyText(
                MyFN.formatNumberWithComma(item.price),
                style: const TextStyle(fontSize: 23, color: MyColors.text1, fontWeight: FontWeight.w800),
                overflow: TextOverflow.ellipsis,
              ),
            ),

            Positioned(
              bottom: 2,
              right: 0,
              child: MyText(
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
}
