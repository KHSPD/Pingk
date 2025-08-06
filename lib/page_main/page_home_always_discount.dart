import 'package:flutter/material.dart';
import 'package:pingk/common/my_colors.dart';
import 'package:pingk/common/my_function.dart';

// ====================================================================================================
// 홈 - 상시 할인 상품 목록
// ====================================================================================================
class HomeAlwaysDiscountItems extends StatefulWidget {
  const HomeAlwaysDiscountItems({super.key});

  @override
  State<HomeAlwaysDiscountItems> createState() =>
      _HomeAlwaysDiscountItemsState();
}

class _HomeAlwaysDiscountItemsState extends State<HomeAlwaysDiscountItems> {
  // ========== 샘플 상품 데이터 ==========
  final List<AlwaysDiscountItemData> alwaysDiscountProducts = [
    AlwaysDiscountItemData(
      id: '1',
      image:
          'https://www.kyochon.com/uploadFiles/TB_ITEM/list-%ED%9B%84%EB%9D%BC%EC%9D%B4%EB%93%9C%EC%8B%B1%EA%B8%80%EC%9C%99(3).png',
      brand: '교촌치킨',
      name: '후라이드싱글윙',
      originalPrice: 7900,
      price: 6800,
      isWished: false,
    ),
    AlwaysDiscountItemData(
      id: '2',
      image:
          'https://www.kyochon.com/uploadFiles/TB_ITEM/%EA%B5%90%EC%B4%8C-%ED%97%88%EB%8B%88-%EC%BD%A4%EB%B3%B4(1).png',
      brand: '교촌치킨',
      name: '허니콤보',
      originalPrice: 23000,
      price: 22000,
      isWished: true,
    ),
    AlwaysDiscountItemData(
      id: '3',
      image:
          'https://www.kyochon.com/uploadFiles/TB_ITEM/%EB%B8%8C%EB%9E%9C%EB%93%9C_list_15-10-221025.png',
      brand: '교촌치킨',
      name: '파채소이살살',
      originalPrice: 19000,
      price: 16500,
      isWished: false,
    ),
    AlwaysDiscountItemData(
      id: '4',
      image:
          'https://www.kyochon.com/uploadFiles/TB_ITEM/list_%ED%9B%84%EB%9D%BC%EC%9D%B4%EB%93%9C%EC%96%91%EB%85%90%EB%B0%98%EB%B0%98%ED%95%9C%EB%A7%88%EB%A6%AC.png',
      brand: '교촌치킨',
      name: '후라이드양념반반한마리',
      originalPrice: 22000,
      price: 21000,
      isWished: false,
    ),
    AlwaysDiscountItemData(
      id: '5',
      image:
          'https://www.kyochon.com/uploadFiles/TB_ITEM/%EB%B8%8C%EB%9E%9C%EB%93%9C_list_15-10-221035.png',
      brand: '교촌치킨',
      name: '살살후라이드',
      originalPrice: 20000,
      price: 19000,
      isWished: true,
    ),
  ];

  // ========== build ==========
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 390,
      margin: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 타이틀 및 더보기 버튼 ----------
          Container(
            margin: const EdgeInsets.fromLTRB(30, 0, 20, 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  ' 상시 할인',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: MyColors.text1,
                  ),
                ),
                GestureDetector(
                  onTap: () {},
                  child: const Text(
                    '상품 더보기',
                    style: TextStyle(
                      fontSize: 14,
                      color: MyColors.text2,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
          // 상품 리스트 ----------
          Expanded(
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.only(right: 20),
              itemCount: alwaysDiscountProducts.length,
              itemBuilder: (context, index) {
                return AlwaysDiscountItemCard(
                  itemData: alwaysDiscountProducts[index],
                  onWishToggle: () => _toggleWish(index),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // ========== 찜 버튼 토글 ==========
  void _toggleWish(int index) {
    setState(() {
      alwaysDiscountProducts[index].isWished =
          !alwaysDiscountProducts[index].isWished;
    });
  }
}

// ====================================================================================================
// 핫딜 상품 카드
// ====================================================================================================
class AlwaysDiscountItemCard extends StatelessWidget {
  final AlwaysDiscountItemData itemData;
  final VoidCallback onWishToggle;

  const AlwaysDiscountItemCard({
    super.key,
    required this.itemData,
    required this.onWishToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 220,
      margin: const EdgeInsets.fromLTRB(20, 5, 0, 5),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: MyColors.background1,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: MyColors.shadow2,
            spreadRadius: 0,
            blurRadius: 4,
            offset: const Offset(2, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 상품 이미지와 찜 버튼 ----------
          Stack(
            alignment: Alignment.bottomRight,
            children: [
              // 상품 이미지 (정사각형 유지)
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: AspectRatio(
                  aspectRatio: 1, // 정사각형 비율 유지
                  child: Image.network(
                    itemData.image,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: MyColors.background2,
                        child: const Icon(
                          Icons.image_not_supported,
                          color: MyColors.text2,
                          size: 40,
                        ),
                      );
                    },
                  ),
                ),
              ),
              // 찜 버튼
              Padding(
                padding: const EdgeInsets.only(bottom: 10, right: 10),
                child: GestureDetector(
                  onTap: onWishToggle,
                  child: Icon(
                    itemData.isWished ? Icons.favorite : Icons.favorite_border,
                    color: itemData.isWished
                        ? MyColors.primary
                        : MyColors.text2,
                    size: 24,
                  ),
                ),
              ),
            ],
          ),
          // 상품 정보 ----------
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 브랜드명
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Text(
                  itemData.brand,
                  style: const TextStyle(
                    fontSize: 12,
                    color: MyColors.text2,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              // 상품명
              Text(
                itemData.name,
                style: const TextStyle(
                  fontSize: 14,
                  color: MyColors.text1,
                  fontWeight: FontWeight.w600,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),

              Container(
                width: double.infinity,
                margin: const EdgeInsets.only(top: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // 할인률
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: MyColors.secondary,
                        borderRadius: BorderRadius.circular(8), // 모서리 라운드 처리
                      ),
                      alignment: Alignment.center,
                      child: RichText(
                        text: TextSpan(
                          text:
                              '${MyFN.discountRate(itemData.originalPrice, itemData.price)}',
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                          children: [
                            const TextSpan(
                              text: '%',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // 가격 정보 ----------
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          '${MyFN.formatNumberWithComma(itemData.originalPrice)}원',
                          style: const TextStyle(
                            fontSize: 11,
                            color: MyColors.text2,
                            decoration: TextDecoration.lineThrough,
                            decorationColor: MyColors.text2,
                          ),
                        ),
                        Text(
                          '${MyFN.formatNumberWithComma(itemData.price)}원',
                          style: const TextStyle(
                            fontSize: 16,
                            color: MyColors.text1,
                            fontWeight: FontWeight.bold,
                          ),
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

// ====================================================================================================
// 상시 할인 상품 데이터 클래스
// ====================================================================================================
class AlwaysDiscountItemData {
  final String id;
  final String image;
  final String brand;
  final String name;
  final int originalPrice;
  final int price;
  bool isWished;

  AlwaysDiscountItemData({
    required this.id,
    required this.image,
    required this.brand,
    required this.name,
    required this.originalPrice,
    required this.price,
    required this.isWished,
  });
}
