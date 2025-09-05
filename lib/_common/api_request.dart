import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pingk/_common/constants.dart';
import 'package:pingk/_common/item_info.dart';
import 'package:pingk/_common/token_manager.dart';

class ApiRequest {
  static final ApiRequest _instance = ApiRequest._internal();
  factory ApiRequest() => _instance;
  ApiRequest._internal();

  final int _updateInterval = 10;

  // --------------------------------------------------
  // 경매 아이템 목록 조회
  // --------------------------------------------------
  final ValueNotifier<List<AuctionItem>> _auctionItemListNotifier = ValueNotifier([]);
  ValueNotifier<List<AuctionItem>> get auctionItemListNotifier => _auctionItemListNotifier;
  DateTime _auctionItemListLastUpdated = DateTime.now();
  Future<void> fetchAuctionItemList({bool forceRefresh = false}) async {
    try {
      if (forceRefresh || _auctionItemListNotifier.value.isEmpty || DateTime.now().difference(_auctionItemListLastUpdated) > Duration(minutes: _updateInterval)) {
        final String apiUrl = '$apiServerURL/api/auctions';
        final String? accessToken = await JwtManager().getAccessToken();

        if (accessToken == null) {
          debugPrint('토큰 없거나 만료됨');
          return;
        }

        final response = await http.get(Uri.parse(apiUrl), headers: {'Content-Type': 'application/json', 'X-Access-Token': accessToken});
        debugPrint('========== API Response ==========\nURL: $apiUrl\nStatus: ${response.statusCode}\nBody: ${response.body}');
        if (response.statusCode == 200) {
          final Map<String, dynamic> body = jsonDecode(response.body);
          if (body['code'] == '200') {
            final resultList = body['result'] as List<dynamic>;
            final List<AuctionItem> cacheList = [];
            for (var item in resultList) {
              final auctionItem = AuctionItem(
                id: item['id'],
                brand: item['brand'],
                productName: item['productName'],
                originPrice: item['originPrice'],
                lastPrice: item['lastPrice'],
                endAt: DateTime.parse(item['endAt'].replaceAll(' ', 'T')),
              );
              cacheList.add(auctionItem);
            }
            _auctionItemListLastUpdated = DateTime.now();
            _auctionItemListNotifier.value = cacheList;
          }
        } else {
          debugPrint('경매 아이템 목록 조회 실패');
        }
      }
    } catch (e) {
      debugPrint('Exception: ${e.toString()}');
    }
  }

  // --------------------------------------------------
  // 경매 당첨자 목록 조회
  // --------------------------------------------------
  final ValueNotifier<List<WinnerInfo>> _auctionWinnerListNotifier = ValueNotifier([]);
  ValueNotifier<List<WinnerInfo>> get auctionWinnerListNotifier => _auctionWinnerListNotifier;
  DateTime _auctionWinnerListLastUpdated = DateTime.now();
  Future<void> fetchAuctionWinnerList({bool forceRefresh = false}) async {
    if (forceRefresh || _auctionWinnerListNotifier.value.isEmpty || DateTime.now().difference(_auctionWinnerListLastUpdated) > Duration(minutes: _updateInterval)) {
      try {
        final String apiUrl = '$apiServerURL/api/auction-winners/recent';
        final String? accessToken = await JwtManager().getAccessToken();

        if (accessToken == null) {
          debugPrint('토큰 없거나 만료됨');
          return;
        }

        final response = await http.get(Uri.parse(apiUrl), headers: {'Content-Type': 'application/json', 'X-Access-Token': accessToken});
        debugPrint('========== API Response ==========\nURL: $apiUrl\nStatus: ${response.statusCode}\nBody: ${response.body}');
        if (response.statusCode == 200) {
          final Map<String, dynamic> body = jsonDecode(response.body);
          if (body['code'] == '200') {
            final resultList = body['result'] as List<dynamic>;
            final List<WinnerInfo> cacheList = [];
            for (var item in resultList) {
              final winnerInfo = WinnerInfo(nickname: item['nickname'], barnd: item['brand'], productName: item['productName'], price: item['price']);
              cacheList.add(winnerInfo);
            }
            _auctionWinnerListLastUpdated = DateTime.now();
            _auctionWinnerListNotifier.value = cacheList;
          }
        }
      } catch (e) {
        debugPrint('Exception: ${e.toString()}');
      }
    }
  }

  // --------------------------------------------------
  // 한정특가 상품 조회
  // --------------------------------------------------
  final ValueNotifier<List<LimitedItem>> _limitedItemListNotifier = ValueNotifier([]);
  ValueNotifier<List<LimitedItem>> get limitedItemListNotifier => _limitedItemListNotifier;
  DateTime _limitedItemListLastUpdated = DateTime.now();
  Future<void> fetchLimitedItemList({bool forceRefresh = false}) async {
    try {
      if (forceRefresh || _limitedItemListNotifier.value.isEmpty || DateTime.now().difference(_limitedItemListLastUpdated) > Duration(minutes: _updateInterval)) {
        final String apiUrl = '$apiServerURL/api/hot-deals';
        final String? accessToken = await JwtManager().getAccessToken();

        if (accessToken == null) {
          debugPrint('토큰 없거나 만료됨');
          return;
        }

        final response = await http.get(Uri.parse(apiUrl), headers: {'Content-Type': 'application/json', 'X-Access-Token': accessToken});
        debugPrint('========== API Response ==========\nURL: $apiUrl\nStatus: ${response.statusCode}\nBody: ${response.body}');
        if (response.statusCode == 200) {
          final Map<String, dynamic> body = jsonDecode(response.body);
          if (body['code'] == '200') {
            final result = body['result'] as List<dynamic>;
            final List<LimitedItem> cacheList = [];
            for (var item in result) {
              final limitedItem = LimitedItem(
                id: item['id'],
                brand: item['brand'],
                title: item['productName'],
                originPrice: item['originPrice'],
                price: item['hotDealPrice'],
                startAt: DateTime.parse(item['startAt'].replaceAll(' ', 'T')),
                endAt: DateTime.parse(item['endAt'].replaceAll(' ', 'T')),
              );
              cacheList.add(limitedItem);
            }
            _limitedItemListLastUpdated = DateTime.now();
            _limitedItemListNotifier.value = cacheList;
          }
        } else {
          debugPrint('경매 아이템 목록 조회 실패');
        }
      }
    } catch (e) {
      debugPrint('Exception: ${e.toString()}');
    }
  }

  // --------------------------------------------------
  // 베스트 상품 조회
  // --------------------------------------------------
  final ValueNotifier<List<AlwayslItem>> _bestItemListNotifier = ValueNotifier([]);
  ValueNotifier<List<AlwayslItem>> get bestItemListNotifier => _bestItemListNotifier;
  DateTime _bestItemListLastUpdated = DateTime.now();
  Future<void> fetchBestItemList({bool forceRefresh = false}) async {
    try {
      if (forceRefresh || _bestItemListNotifier.value.isEmpty || DateTime.now().difference(_bestItemListLastUpdated) > Duration(minutes: _updateInterval)) {
        final String apiUrl = '$apiServerURL/api/products/popularity';
        final String? accessToken = await JwtManager().getAccessToken();

        if (accessToken == null) {
          debugPrint('토큰 없거나 만료됨');
          return;
        }

        final response = await http.get(Uri.parse(apiUrl), headers: {'Content-Type': 'application/json', 'X-Access-Token': accessToken});
        debugPrint('========== API Response ==========\nURL: $apiUrl\nStatus: ${response.statusCode}\nBody: ${response.body}');
        if (response.statusCode == 200) {
          final Map<String, dynamic> body = jsonDecode(response.body);
          if (body['code'] == '200') {
            final result = body['result'] as List<dynamic>;
            final List<AlwayslItem> cacheList = [];
            for (var item in result) {
              final bestItem = AlwayslItem(
                id: item['id'],
                brand: item['brand'],
                title: item['productName'],
                originPrice: item['originPrice'],
                price: item['price'],
                category: item['categoryType'],
              );
              cacheList.add(bestItem);
            }
            _bestItemListLastUpdated = DateTime.now();
            _bestItemListNotifier.value = cacheList;
          }
        } else {
          debugPrint('경매 아이템 목록 조회 실패');
        }
      }
    } catch (e) {
      debugPrint('Exception: ${e.toString()}');
    }
  }
}
