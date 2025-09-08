import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'package:pingk/_common/constants.dart';
import 'package:pingk/_common/item_info.dart';
import 'package:pingk/_common/my_functions.dart';
import 'package:pingk/_common/my_widget.dart';
import 'package:pingk/_common/token_manager.dart';

// ====================================================================================================
// AlwaysDealPage
// ====================================================================================================
class Always extends StatefulWidget {
  const Always({super.key});

  @override
  State<Always> createState() => _AlwaysState();
}

class _AlwaysState extends State<Always> {
  final List<AlwayslItem> _itemList = [];
  final List<String> _categoryList = ['FOOD', 'BEAUTY', 'FASHION', 'LIFESTYLE', 'HOME', 'ELECTRONICS', 'SPORTS', 'BOOKS', 'MUSIC', 'MOVIES', 'GAMES', 'TOYS', 'OTHERS'];
  int _selectedCategoryIdx = 0;
  // ----- API Request 관련 -----
  final int _requestCount = 20;
  bool _isNewRequest = true;
  int _currentPage = 1;
  // ----- 스크롤 관련 -----
  final ScrollController _scrollController = ScrollController();
  bool _dataIsLoading = false;
  bool _hasMoreData = true;
  // ----- 정렬 관련 -----
  final List<String> _sortOptions = ['인기순', '가격낮은순', '가격높은순', '할인률높은순'];
  String _selectedSortOption = '인기순';

  // --------------------------------------------------
  // Lifecycle Methods
  // --------------------------------------------------
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchAlwaysItemList();
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  // --------------------------------------------------
  // 추가 데이터 로드
  // --------------------------------------------------
  Future<void> _loadMoreItems() async {
    if (!_dataIsLoading && _hasMoreData) {
      _currentPage++;
      setState(() {
        _dataIsLoading = true;
      });
      final delayFuture = Future.delayed(const Duration(milliseconds: 500));
      final fetchFuture = _fetchAlwaysItemList();
      await Future.wait([delayFuture, fetchFuture]);
      setState(() {
        _dataIsLoading = false;
      });
    }
  }

  // --------------------------------------------------
  // 상시특가 상품 조회
  // --------------------------------------------------
  Future<void> _fetchAlwaysItemList() async {
    try {
      final String apiUrl = '$apiServerURL/api/products';
      final String? accessToken = await JwtManager().getAccessToken();

      if (accessToken == null) {
        debugPrint('토큰 없거나 만료됨');
        return;
      }

      // ----- Request Parameters -----
      if (_isNewRequest) {
        _itemList.clear();
        _currentPage = 1;
        _isNewRequest = false;
        _hasMoreData = true;
        // 스크롤을 맨 위로 초기화
        if (_scrollController.hasClients) {
          _scrollController.animateTo(0.0, duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
        }
      }
      Map<String, dynamic> params = {};
      params['page'] = _currentPage;
      params['size'] = _requestCount;
      params['category'] = _categoryList[_selectedCategoryIdx];

      // 쿼리 스트림 생성
      final uri = Uri.parse(apiUrl).replace(queryParameters: params.map((key, value) => MapEntry(key, value.toString())));
      final response = await http.get(uri, headers: {'Content-Type': 'application/json', 'X-Access-Token': accessToken});
      debugPrint('========== API Response ==========\nURL: $apiUrl\nParams: $uri\nStatus: ${response.statusCode}\nBody: ${response.body}');
      if (response.statusCode == 200) {
        final Map<String, dynamic> body = jsonDecode(response.body);
        if (body['code'] == '200') {
          final result = body['result'];
          _currentPage = result['page'];
          final content = result['content'] as List<dynamic>;
          final List<AlwayslItem> newItems = [];
          for (var item in content) {
            final alwaysItem = AlwayslItem(
              id: item['id'],
              brand: item['brand'],
              title: item['productName'],
              originPrice: item['originPrice'],
              price: item['price'],
              category: item['category'],
            );
            newItems.add(alwaysItem);
          }

          // 로드할 데이터가 더 있는지 확인
          final totalPage = result['totalPages'];
          if (newItems.isEmpty || _currentPage >= totalPage) {
            _hasMoreData = false;
          }
          setState(() {
            _itemList.addAll(newItems);
          });
        }
      } else {
        debugPrint('경매 아이템 목록 조회 실패');
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  // --------------------------------------------------
  // build
  // --------------------------------------------------
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xFFFFFFFF),
      child: Stack(
        children: [
          NotificationListener<ScrollNotification>(
            onNotification: (ScrollNotification scrollInfo) {
              if (scrollInfo is ScrollUpdateNotification || scrollInfo is ScrollEndNotification) {
                if (scrollInfo.metrics.pixels >= scrollInfo.metrics.maxScrollExtent + 20) {
                  _loadMoreItems();
                }
              }
              return false;
            },
            child: NestedScrollView(
              controller: _scrollController,
              headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
                return [
                  // ----- 상단 문구 -----
                  SliverToBoxAdapter(
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.fromLTRB(29, 30, 29, 0),
                      child: RichText(
                        text: const TextSpan(
                          style: TextStyle(fontSize: 28, fontWeight: FontWeight.w600, letterSpacing: -0.3),
                          children: [
                            TextSpan(
                              text: '상시특가로 매일매일',
                              style: TextStyle(color: Color(0xFFFF437A)),
                            ),
                            TextSpan(
                              text: '\n똑똑한 쇼핑하세요!',
                              style: TextStyle(color: Color(0xFF393939), height: 1.2),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  const SliverToBoxAdapter(child: SizedBox(height: 10)),

                  // ----- 카테고리 선택 -----
                  SliverPersistentHeader(
                    pinned: true,
                    delegate: _CategoryHeaderDelegate(_categoryList, _selectedCategoryIdx, (index) {
                      if (index != _selectedCategoryIdx) {
                        _isNewRequest = true;
                        _selectedCategoryIdx = index;
                        _fetchAlwaysItemList();
                      }
                    }),
                  ),

                  const SliverToBoxAdapter(child: SizedBox(height: 40)),

                  // ----- 총 상품 수 및 정렬 옵션 -----
                  SliverToBoxAdapter(
                    child: Container(
                      padding: const EdgeInsets.fromLTRB(29, 0, 29, 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '총 ${_itemList.length}개의 쿠폰',
                            style: const TextStyle(fontSize: 14, color: Color(0xFFBEBEBE), fontWeight: FontWeight.w600, letterSpacing: -0.3),
                          ),
                          _buildSortDropdown(),
                        ],
                      ),
                    ),
                  ),
                ];
              },

              // ----- NestedScrollView - body -----
              body: GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(22, 0, 22, 150),
                itemCount: _itemList.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, mainAxisSpacing: 30, crossAxisSpacing: 10, childAspectRatio: 168 / 275),
                itemBuilder: (context, index) {
                  return _alwaysCard(_itemList[index], () {});
                },
              ),
            ),
          ),

          // 로딩 오버레이
          if (_dataIsLoading)
            Container(
              color: const Color(0x30000000),
              child: Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFFF437A)))),
            ),
        ],
      ),
    );
  }

  // --------------------------------------------------
  // 정렬 드롭다운 메뉴
  // --------------------------------------------------
  Widget _buildSortDropdown() {
    return Container(
      height: 30,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _selectedSortOption,
          alignment: Alignment.centerRight,
          dropdownColor: Colors.white,
          icon: Icon(Icons.keyboard_arrow_down, size: 20, color: Color(0xFFFF437A)),
          selectedItemBuilder: (context) => _sortOptions
              .map(
                (option) => Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      option,
                      style: TextStyle(fontSize: 14, color: Color(0xFFFF437A), fontWeight: FontWeight.w600, letterSpacing: -0.3),
                    ),
                    const SizedBox(width: 4),
                  ],
                ),
              )
              .toList(),
          items: _sortOptions
              .map(
                (option) => DropdownMenuItem<String>(
                  value: option,
                  alignment: Alignment.centerLeft,
                  child: Text(
                    option,
                    style: TextStyle(fontSize: 14, color: Color(0xFF393939), fontWeight: FontWeight.w500, letterSpacing: -0.3),
                  ),
                ),
              )
              .toList(),
          onChanged: (newValue) {
            if (newValue != null && newValue != _selectedSortOption) {
              setState(() => _selectedSortOption = newValue);
            }
          },
        ),
      ),
    );
  }

  // --------------------------------------------------
  // 베스트 상품 카드
  // --------------------------------------------------
  Widget _alwaysCard(AlwayslItem item, VoidCallback onWishToggle) {
    return GestureDetector(
      onTap: () {
        context.pushNamed('always-detail', pathParameters: {'itemId': item.id});
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
                child: Icon(item.isWished ? Icons.favorite : Icons.favorite_border, color: item.isWished ? Color(0xFFFF437A) : Color(0xFFD0D0D0), size: 22),
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

// ====================================================================================================
// CategoryHeaderDelegate
// ====================================================================================================
class _CategoryHeaderDelegate extends SliverPersistentHeaderDelegate {
  final List<String> categoryList;
  final int selectedIndex;
  final Function(int) onCategorySelected;

  _CategoryHeaderDelegate(this.categoryList, this.selectedIndex, this.onCategorySelected);

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: Colors.white,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 21, vertical: 10),
        child: Row(
          children: categoryList.asMap().entries.map((entry) {
            int index = entry.key;
            String category = entry.value;
            bool isSelected = index == selectedIndex;
            return GestureDetector(
              onTap: () {
                onCategorySelected(index);
              },
              child: Container(
                margin: const EdgeInsets.only(right: 8),
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: isSelected ? const Color(0xFFFF437A) : Colors.transparent,
                  borderRadius: BorderRadius.circular(30),
                  border: isSelected ? null : Border.all(color: const Color(0xFFBEBEBE), width: 1),
                ),
                alignment: Alignment.center,
                child: Text(
                  category,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                    color: isSelected ? Colors.white : const Color(0xFFBEBEBE),
                    letterSpacing: -0.3,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  @override
  double get maxExtent => 58;

  @override
  double get minExtent => 58;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }
}
