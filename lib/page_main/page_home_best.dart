import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:pingk/common/my_colors.dart';
import 'package:pingk/common/my_function.dart';
import 'package:pingk/common/item_info.dart';
import 'package:pingk/common/_temp_items.dart';

// ====================================================================================================
// 홈 - 베스트 상품 목록
// ====================================================================================================
class HomeBestItems extends StatefulWidget {
  const HomeBestItems({super.key});

  @override
  State<HomeBestItems> createState() => _HomeBestItemsState();
}

class _HomeBestItemsState extends State<HomeBestItems> {
  final List<GeneralItem> itemList = TempItems.bestItems.sublist(0, 7);

  // --------------------------------------------------
  // build
  // --------------------------------------------------
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 380,
      margin: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ----- 타이틀 및 더보기 버튼 -----
          Container(
            margin: const EdgeInsets.fromLTRB(20, 0, 20, 5),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Lottie.asset('assets/lottie/icon_1.json', width: 46, height: 46, fit: BoxFit.cover),
                const SizedBox(width: 4),
                const Text(
                  '베스트 쿠폰',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: MyColors.text1),
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
          // ----- 상품 리스트 -----
          Expanded(
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.only(right: 20),
              itemCount: itemList.length,
              itemBuilder: (context, index) {
                return _itemCard(itemList[index], () => _toggleWish(index));
              },
            ),
          ),
        ],
      ),
    );
  }

  // --------------------------------------------------
  // 찜 버튼 토글
  // --------------------------------------------------
  void _toggleWish(int index) {
    setState(() {
      itemList[index].isWished = !itemList[index].isWished;
    });
  }

  // --------------------------------------------------
  // 상품 카드
  // --------------------------------------------------
  Widget _itemCard(GeneralItem item, VoidCallback onWishToggle) {
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
          // ----- 상품 이미지와 찜 버튼 -----
          Stack(
            alignment: Alignment.bottomRight,
            children: [
              // 상품 이미지
              // 상품 이미지
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
              // 찜 버튼
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
                        color: MyColors.secondary,
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
}
