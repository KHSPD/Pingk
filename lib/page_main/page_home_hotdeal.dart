import 'package:flutter/material.dart';
import 'package:pingk/common/my_colors.dart';
import 'package:pingk/common/my_function.dart';

// ====================================================================================================
// 홈 - 핫딜 상품 목록
// ====================================================================================================
class HomeHotdealItems extends StatefulWidget {
  const HomeHotdealItems({super.key});

  @override
  State<HomeHotdealItems> createState() => _HomeHotdealItemsState();
}

class _HomeHotdealItemsState extends State<HomeHotdealItems> {
  // ========== 샘플 상품 데이터 ==========
  final List<HotdealItemData> hotdealProducts = [
    HotdealItemData(
      id: '1',
      image:
          'https://image.istarbucks.co.kr/upload/store/skuimg/2025/07/[9300000005940]_20250721095525217.jpg',
      brand: '스타벅스',
      name: 'B.L.T. 샌드위치',
      originalPrice: 7500,
      price: 4000,
      isWished: false,
    ),
    HotdealItemData(
      id: '2',
      image:
          'https://image.istarbucks.co.kr/upload/store/skuimg/2025/07/[9300000006024]_20250710154216315.jpg',
      brand: '스타벅스',
      name: '렌위치 NY 샌드위치',
      originalPrice: 8800,
      price: 5300,
      isWished: true,
    ),
    HotdealItemData(
      id: '3',
      image:
          'https://image.istarbucks.co.kr/upload/store/skuimg/2021/04/[4004000000036]_20210415143933578.jpg',
      brand: '스타벅스',
      name: '얼 그레이 티',
      originalPrice: 7300,
      price: 6000,
      isWished: false,
    ),
    HotdealItemData(
      id: '4',
      image:
          'https://image.istarbucks.co.kr/upload/store/skuimg/2021/08/[9300000003231]_20210826102030821.jpg',
      brand: '스타벅스',
      name: '오가닉 그릭 요거트 플레인',
      originalPrice: 11000,
      price: 6500,
      isWished: false,
    ),
    HotdealItemData(
      id: '5',
      image:
          'https://image.istarbucks.co.kr/upload/store/skuimg/2025/07/[11171980]_20250707124820844.jpg',
      brand: '스타벅스',
      name: '디스커버리 코리아 머그 414ml',
      originalPrice: 22000,
      price: 14500,
      isWished: true,
    ),
  ];

  // ========== build ==========
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 395,
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
                  '핫딜',
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
              itemCount: hotdealProducts.length,
              itemBuilder: (context, index) {
                return HotdealItemCard(
                  itemData: hotdealProducts[index],
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
      hotdealProducts[index].isWished = !hotdealProducts[index].isWished;
    });
  }
}

// ====================================================================================================
// 핫딜 상품 카드
// ====================================================================================================
class HotdealItemCard extends StatelessWidget {
  final HotdealItemData itemData;
  final VoidCallback onWishToggle;

  const HotdealItemCard({
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
              // 상품 이미지
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
                        color: MyColors.primary,
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
// 핫딜 상품 데이터 클래스
// ====================================================================================================
class HotdealItemData {
  final String id;
  final String image;
  final String brand;
  final String name;
  final int originalPrice;
  final int price;
  bool isWished;

  HotdealItemData({
    required this.id,
    required this.image,
    required this.brand,
    required this.name,
    required this.originalPrice,
    required this.price,
    required this.isWished,
  });
}
