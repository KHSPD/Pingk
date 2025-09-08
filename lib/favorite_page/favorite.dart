import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pingk/_common/constants.dart';
import 'package:pingk/_common/item_info.dart';
import 'package:pingk/_common/local_db.dart';
import 'package:pingk/_common/token_manager.dart';

class Favorite extends StatefulWidget {
  const Favorite({super.key});

  @override
  State<Favorite> createState() => _FavoriteState();
}

class _FavoriteState extends State<Favorite> {
  static final List<FavoriteItem> _itemList = [];

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
        debugPrint('찜 상품 정보 조회 실패');
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
      body: const Center(child: Text('찜한 상품이 없습니다.')),
    );
  }
}
