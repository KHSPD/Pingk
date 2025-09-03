import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pingk/common/constants.dart';
import 'package:pingk/common/item_info.dart';
import 'package:pingk/common/token_manager.dart';

class ApiRequest {
  static final ApiRequest _instance = ApiRequest._internal();
  factory ApiRequest() => _instance;
  ApiRequest._internal();

  final int _updateInterval = 10;

  // --------------------------------------------------
  // 경매 아이템 목록 조회
  // --------------------------------------------------
  final ValueNotifier<List<AuctionItem>> _auctionItemListNotifier = ValueNotifier([]);
  DateTime _auctionItemListLastUpdated = DateTime.now();
  ValueNotifier<List<AuctionItem>> get auctionItemListNotifier => _auctionItemListNotifier;

  Future<List<AuctionItem>> fetchAuctionItemList({bool forceRefresh = false}) async {
    try {
      if (forceRefresh || _auctionItemListNotifier.value.isEmpty || DateTime.now().difference(_auctionItemListLastUpdated) > Duration(minutes: _updateInterval)) {
        final String apiUrl = '$apiServerURL/api/auctions';
        final String? accessToken = await JwtManager().getAccessToken();

        if (accessToken == null) {
          debugPrint('토큰 없거나 만료됨');
          return [];
        }

        final response = await http.get(Uri.parse(apiUrl), headers: {'Content-Type': 'application/json', 'X-Access-Token': accessToken});
        debugPrint('========== API Response ==========\nURL: $apiUrl\nStatus: ${response.statusCode}\nBody: ${response.body}');
        if (response.statusCode == 200) {
          final Map<String, dynamic> body = jsonDecode(response.body);
          if (body['code'] == '200') {
            final resultList = body['result'] as List<dynamic>;
            final List<AuctionItem> cacheList = [];
            for (var item in resultList) {
              AuctionItem auctionItem = AuctionItem(
                // TODO: originalPrice 수정
                idx: item['idx'],
                brand: item['brand'],
                productName: item['productName'],
                originalPrice: item['originalPrice'],
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
    return _auctionItemListNotifier.value;
  }

  // --------------------------------------------------
  // 경매 당첨자 목록 조회
  // --------------------------------------------------
  final ValueNotifier<List<WinnerInfo>> _auctionWinnerListNotifier = ValueNotifier([]);
  DateTime _auctionWinnerListLastUpdated = DateTime.now();
  ValueNotifier<List<WinnerInfo>> get auctionWinnerListNotifier => _auctionWinnerListNotifier;
  Future<List<WinnerInfo>> fetchAuctionWinnerList({bool forceRefresh = false}) async {
    if (forceRefresh || _auctionWinnerListNotifier.value.isEmpty || DateTime.now().difference(_auctionWinnerListLastUpdated) > Duration(minutes: _updateInterval)) {
      try {
        final String apiUrl = '$apiServerURL/api/auction-winners/recent';
        final String? accessToken = await JwtManager().getAccessToken();

        if (accessToken == null) {
          debugPrint('토큰 없거나 만료됨');
          return [];
        }

        final response = await http.get(Uri.parse(apiUrl), headers: {'Content-Type': 'application/json', 'X-Access-Token': accessToken});
        debugPrint('========== API Response ==========\nURL: $apiUrl\nStatus: ${response.statusCode}\nBody: ${response.body}');
        if (response.statusCode == 200) {
          final Map<String, dynamic> body = jsonDecode(response.body);
          if (body['code'] == '200') {
            final resultList = body['result'] as List<dynamic>;
            final List<WinnerInfo> cacheList = [];
            for (var item in resultList) {
              // TODO: 가격 추가
              WinnerInfo winnerInfo = WinnerInfo(nickname: item['nickname'], barnd: item['brand'], productName: item['productName'], price: item['price']);
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
    return _auctionWinnerListNotifier.value;
  }
}
