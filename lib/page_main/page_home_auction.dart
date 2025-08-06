import 'package:flutter/material.dart';
import 'package:pingk/common/my_function.dart';
import '../common/my_colors.dart';

// ====================================================================================================
// 홈 - 경매 상품 목록
// ====================================================================================================
class HomeAuctionItems extends StatefulWidget {
  const HomeAuctionItems({super.key});

  @override
  State<HomeAuctionItems> createState() => _HomeAuctionItemsState();
}

class _HomeAuctionItemsState extends State<HomeAuctionItems> {
  final PageController _pageController = PageController();
  int _selectedItemIdx = 0;

  // ========== 샘플 상품 데이터 ==========
  final List<Map<String, dynamic>> auctionItems = [
    {
      'brand': '스타벅스',
      'name': '아이스아메리카노 Tall',
      'lastPrice': '1350',
      'image':
          'https://image.istarbucks.co.kr/upload/store/skuimg/2025/06/[106509]_20250626092521572.jpg',
    },
    {
      'brand': 'BHC',
      'name': '황금올리브 치킨 1마리',
      'lastPrice': '11100',
      'image':
          'https://cdn.imweb.me/upload/S20220826948cbdc34dca3/1e0c8bbbe23a7.jpg',
    },
    {
      'brand': '스타벅스',
      'name': '조각 케익 1조각',
      'lastPrice': '2010',
      'image':
          'https://image.istarbucks.co.kr/upload/store/skuimg/2024/10/[9300000005606]_20241022091857939.jpg',
    },
    {
      'brand': '스타벅스',
      'name': '이름 모를 라떼',
      'lastPrice': '650',
      'image':
          'https://image.istarbucks.co.kr/upload/store/skuimg/2025/06/[9200000004750]_20250626093847447.jpg',
    },
  ];

  // ========== dispose ==========
  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  // ========== build ==========
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 650,
      child: Column(
        children: [
          // 상단 문구 ----------
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(30, 20, 30, 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  text: const TextSpan(
                    style: TextStyle(fontSize: 24, color: Colors.black87),
                    children: [
                      TextSpan(
                        text: '경매',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      TextSpan(text: '로 저렴하게'),
                    ],
                  ),
                ),
                RichText(
                  text: const TextSpan(
                    style: TextStyle(fontSize: 24, color: Colors.black87),
                    children: [
                      TextSpan(
                        text: '쿠폰 쇼핑',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      TextSpan(text: '하세요!'),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // 상품 목록 ----------
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  _selectedItemIdx = index;
                });
              },
              itemCount: auctionItems.length,
              itemBuilder: (context, index) {
                return _auctionItemCard(auctionItems[index]);
              },
            ),
          ),

          // 페이지 인디케이터 ----------
          Container(
            margin: const EdgeInsets.fromLTRB(0, 16, 0, 40),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                auctionItems.length,
                (index) => Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _selectedItemIdx == index
                        ? MyColors.primary
                        : MyColors.tertiary.withAlpha(80),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ========== 경매 상품 미리보기 ==========
  Widget _auctionItemCard(Map<String, dynamic> item) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: MyColors.background1,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: const Color.fromARGB(15, 191, 19, 19),
            spreadRadius: 5,
            blurRadius: 10,
            offset: const Offset(0, 0),
          ),
        ],
      ),
      child: Column(
        children: [
          // 남은 시간 카운트 다운 ----------
          Container(
            alignment: Alignment.centerRight,
            child: Container(
              margin: const EdgeInsets.fromLTRB(0, 10, 10, 20),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
              decoration: BoxDecoration(
                color: MyColors.tertiary,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Text(
                '00:00:00',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ),
          ),

          // 상품 이미지 ----------
          ClipOval(
            child: Image.network(
              item['image'],
              fit: BoxFit.cover,
              width: 200,
              height: 200,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  height: 200,
                  width: 200,
                  color: Colors.grey[300],
                  child: const Icon(Icons.image, size: 50, color: Colors.grey),
                );
              },
            ),
          ),

          // 상품 정보 ----------
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item['brand'],
                  style: const TextStyle(fontSize: 16, color: Colors.grey),
                ),
                const SizedBox(height: 4),
                Text(
                  item['name'],
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'Last Price',
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                ),
                Row(
                  children: [
                    Text(
                      MyFN.formatNumberWithComma(item['lastPrice']),
                      style: const TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                        color: MyColors.text1,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '원',
                      style: TextStyle(fontSize: 16, color: MyColors.text1),
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
