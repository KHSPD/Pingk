import 'package:flutter/material.dart';
import 'package:pingk/common/_temp_items.dart';
import 'package:pingk/common/item_info.dart';
import 'package:pingk/common/my_colors.dart';

// ====================================================================================================
// 핫딜 상품 목록
// ====================================================================================================
class PageHotdeal extends StatefulWidget {
  const PageHotdeal({super.key});

  @override
  State<PageHotdeal> createState() => _PageHotdealState();
}

class _PageHotdealState extends State<PageHotdeal> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: MyColors.background2,
      child: ListView.builder(
        padding: const EdgeInsets.all(30),
        itemCount: TempItems.todaysHotDealDatas.length,
        itemBuilder: (context, index) {
          final item = TempItems.todaysHotDealDatas[index];
          return _itemCard(item);
        },
      ),
    );
  }

  // --------------------------------------------------
  // 상품 카드
  // --------------------------------------------------
  Widget _itemCard(GeneralItem item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: MyColors.background1,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: MyColors.shadow2, blurRadius: 8, offset: const Offset(0, 2))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            alignment: Alignment.bottomRight,
            children: [
              // ----- 상품 이미지 -----
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                child: AspectRatio(
                  aspectRatio: 1,
                  child: Image.network(
                    item.thumbnail,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: MyColors.background2,
                        child: const Icon(Icons.image_not_supported, color: MyColors.tertiary, size: 48),
                      );
                    },
                  ),
                ),
              ),

              // ----- 남은 시간 (우측 상단) -----
              Positioned(
                top: 12,
                right: 12,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(color: MyColors.text1.withValues(alpha: 0.8), borderRadius: BorderRadius.circular(6)),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.access_time, color: MyColors.text4, size: 20),
                      const SizedBox(width: 6),
                      Text(
                        '20:45:12',
                        style: const TextStyle(color: MyColors.text4, fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),

              // ----- 찜하기 버튼 (오른쪽 하단) -----
              Padding(
                padding: const EdgeInsets.only(bottom: 20, right: 20),
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      item.isWished = !item.isWished;
                    });
                  },
                  child: Icon(item.isWished ? Icons.favorite : Icons.favorite_border, color: item.isWished ? MyColors.primary : MyColors.secondary, size: 35),
                ),
              ),
            ],
          ),

          // ----- 상품 정보 -----
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 브랜드명
                Text(
                  item.brand,
                  style: const TextStyle(color: MyColors.text2, fontSize: 14, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 4),

                // 상품명
                Text(
                  item.name,
                  style: const TextStyle(color: MyColors.text1, fontSize: 18, fontWeight: FontWeight.bold),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),

                // 가격 정보
                Row(
                  children: [
                    // 원가 (취소선)
                    Text(
                      '${item.originalPrice.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}원',
                      style: const TextStyle(color: MyColors.text2, fontSize: 14, decoration: TextDecoration.lineThrough),
                    ),
                    const Spacer(),
                    // 할인가
                    Text(
                      '${item.price.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}원',
                      style: const TextStyle(color: MyColors.text3, fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(width: 14),
                    // 할인율 계산
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(color: MyColors.text3, borderRadius: BorderRadius.circular(5)),
                      child: Text(
                        '${((item.originalPrice - item.price) / item.originalPrice * 100).round()}%',
                        style: const TextStyle(color: MyColors.text4, fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
