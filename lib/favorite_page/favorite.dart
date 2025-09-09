import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pingk/_common/item_info.dart';
import 'package:pingk/_common/local_db.dart';
import 'package:pingk/_common/my_functions.dart';
import 'package:pingk/_common/my_widget.dart';

class Favorite extends StatefulWidget {
  const Favorite({super.key});

  @override
  State<Favorite> createState() => _FavoriteState();
}

class _FavoriteState extends State<Favorite> {
  static final List<AlwayslItem> _itemList = [];
  static final List<AlwayslItem> _sortedItemList = [];
  bool _showOnlyAvailable = true;

  // --------------------------------------------------
  // Lifecycle Methods
  // --------------------------------------------------
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _fetchFavoriteItemList();
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  // --------------------------------------------------
  // Favorite Data Load
  // --------------------------------------------------
  Future<void> _fetchFavoriteItemList() async {
    // TODO: 테스트용 코드 - 삭제 할것!
    _itemList.clear();
    _itemList.addAll(await LocalDatabase().getAllFavorites());
    _sortedItemList.clear();
    _sortedItemList.addAll(_itemList.where((item) => item.status == 'ACTIVE'));
    //

    /*
    try {
      if (_itemList.isNotEmpty) return;
      _itemList.addAll(await LocalDatabase().getAllFavorites());
      if (_itemList.isEmpty) return;

      final String apiUrl = '$apiServerURL/api/products/favorites/';
      final String? accessToken = await JwtManager().getAccessToken();

      if (accessToken == null) {
        debugPrint('토큰 없거나 만료됨');
        return;
      }

      final List<String> itemIds = _itemList.map((item) => item.id).toList();
      final uri = Uri.parse(apiUrl).replace(queryParameters: {'productIds': itemIds});
      final response = await http.get(uri, headers: {'Content-Type': 'application/json', 'X-Access-Token': accessToken});
      debugPrint('========== API Response ==========\nURL: $apiUrl\nParams: $uri\nStatus: ${response.statusCode}\nBody: ${response.body}');
      if (response.statusCode == 200) {
        final Map<String, dynamic> body = jsonDecode(response.body);
        if (body['code'] == '200') {
          final result = body['result'] as List<dynamic>;
          for (var item in result) {
            final index = _itemList.indexWhere((fav) => fav.id == item['id']);
            if (index != -1) {
              _itemList[index] = FavoriteItem(
                id: item['id'],
                brand: item['brand'],
                title: item['title'],
                price: item['price'],
                originPrice: item['originPrice'],
                status: item['status'],
              );
            }
          }
        }
      } else {
        _itemList.clear();
        debugPrint('찜 상품 정보 조회 실패');
      }
    } catch (e) {
      _itemList.clear();
      debugPrint(e.toString());
    }
    */
  }

  // --------------------------------------------------
  // 상품 목록 정렬
  // --------------------------------------------------
  void _sortItemList() {
    _showOnlyAvailable = !_showOnlyAvailable;
    if (_showOnlyAvailable) {
      _sortedItemList.clear();
      _sortedItemList.addAll(_itemList.where((item) => item.status == 'ACTIVE'));
    } else {
      _sortedItemList.clear();
      _sortedItemList.addAll(_itemList);
    }
    setState(() {});
  }

  // --------------------------------------------------
  // 아이템 삭제 이벤트
  // --------------------------------------------------
  void _onItemDelete(AlwayslItem item) {
    Popup().show(
      context: context,
      title: '상품 삭제',
      msg: '찜한 상품을 삭제하시겠습니까?',
      btTxt1: '취소',
      btCB1: () {},
      btTxt2: '삭제',
      btCB2: () {
        setState(() {
          LocalDatabase().deleteFavorite(item.id);
          _itemList.remove(item);
          _sortedItemList.remove(item);
        });
      },
    );
  }

  // --------------------------------------------------
  // build
  // --------------------------------------------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFFFFFF),

      // ----- 상단바 -----
      appBar: AppBar(
        title: const Text(
          '내가 찜한 상품',
          style: TextStyle(fontSize: 18, color: Color(0xFF393939), fontWeight: FontWeight.w500, letterSpacing: -0.3),
        ),
        backgroundColor: Color(0xFFFFFFFF),
        elevation: 0,
      ),

      // ----- Body -----
      body: _itemList.isEmpty
          ? const Center(child: Text('찜한 상품이 없습니다.'))
          : CustomScrollView(
              slivers: [
                // 구매 가능 상품만 보기 체크 박스
                SliverToBoxAdapter(
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(0, 20, 30, 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Checkbox(
                          value: _showOnlyAvailable,
                          onChanged: (bool? value) {
                            _sortItemList();
                          },
                          side: BorderSide.none,
                          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          visualDensity: VisualDensity.compact,
                          fillColor: WidgetStateProperty.resolveWith<Color>((Set<WidgetState> states) {
                            if (states.contains(WidgetState.selected)) {
                              return Color(0xFFFF437A);
                            }
                            return Color(0xFFF3F3F3);
                          }),
                        ),
                        GestureDetector(
                          onTap: () {
                            _sortItemList();
                          },
                          child: Text(
                            '구매가능만 보기',
                            style: TextStyle(fontSize: 14, color: Color(0xFF393939), fontWeight: FontWeight.w600, letterSpacing: -0.3),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // GridView
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(22, 0, 22, 150),
                  sliver: SliverGrid(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, mainAxisSpacing: 30, crossAxisSpacing: 10, childAspectRatio: 168 / 275),
                    delegate: SliverChildBuilderDelegate((context, index) {
                      return _favoriteCard(_sortedItemList[index], () {
                        _onItemDelete(_sortedItemList[index]);
                      });
                    }, childCount: _sortedItemList.length),
                  ),
                ),
              ],
            ),
    );
  }

  // --------------------------------------------------
  // 찜한 상품 카드
  // --------------------------------------------------
  Widget _favoriteCard(AlwayslItem item, VoidCallback onItemDelete) {
    return GestureDetector(
      onTap: () {
        context.pushNamed('detail-always', pathParameters: {'itemId': item.id});
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
                onTap: onItemDelete,
                child: Icon(Icons.favorite, color: Color(0xFFFF437A), size: 22),
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

            if (item.status == 'ACTIVE') ...[
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
            ] else ...[
              // ----- 판매 종료 -----
              Positioned(
                right: 10,
                bottom: 6,
                child: Container(
                  width: 80,
                  height: 27,
                  decoration: BoxDecoration(color: Color(0xFFBEBEBE), borderRadius: BorderRadius.circular(20)),
                  alignment: Alignment.center,
                  child: Text(
                    '판매종료',
                    style: const TextStyle(fontSize: 15, color: Color(0xFFFFFFFF), fontWeight: FontWeight.w700, letterSpacing: -0.3),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
