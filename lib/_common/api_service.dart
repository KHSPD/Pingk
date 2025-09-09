import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:pingk/_common/constants.dart';
import 'package:pingk/_common/item_info.dart';
import 'package:pingk/_common/token_manager.dart';

class ApiService {
  static final ApiService _instance = ApiService._privateConstructor();
  factory ApiService() => _instance;

  // --------------------------------------------------
  // 변수
  // --------------------------------------------------
  // API 업데이트 주기(분)
  final int _updateInterval = 10;
  // 공개 API용 Dio
  Dio get publicDio => _publicDio;
  final Dio _publicDio = Dio(
    BaseOptions(baseUrl: apiServerURL, connectTimeout: const Duration(seconds: 10), receiveTimeout: const Duration(seconds: 10), headers: {'Content-Type': 'application/json'}),
  );
  // 인증 API용 Dio
  Dio get authDio => _authDio;
  final Dio _authDio = Dio(
    BaseOptions(baseUrl: apiServerURL, connectTimeout: const Duration(seconds: 10), receiveTimeout: const Duration(seconds: 10), headers: {'Content-Type': 'application/json'}),
  );

  // --------------------------------------------------
  // 생성자
  // --------------------------------------------------
  ApiService._privateConstructor() {
    _authDio.interceptors.add(
      // 인증 API용에 엑세스토큰 자동 추가
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final String? accessToken = await JwtManager().getAccessToken();
          if (accessToken != null) {
            options.headers['X-Access-Token'] = accessToken;
          }
          handler.next(options);
        },
      ),
    );
  }

  // --------------------------------------------------
  // 경매 아이템 목록 조회
  // --------------------------------------------------
  final ValueNotifier<List<AuctionItem>> _auctionItemListNotifier = ValueNotifier([]);
  ValueNotifier<List<AuctionItem>> get auctionItemListNotifier => _auctionItemListNotifier;
  DateTime _auctionItemListLastUpdated = DateTime.now();
  Future<void> fetchAuctionItemList({bool forceRefresh = false}) async {
    try {
      if (forceRefresh || _auctionItemListNotifier.value.isEmpty || DateTime.now().difference(_auctionItemListLastUpdated) > Duration(minutes: _updateInterval)) {
        final response = await _authDio.get('/api/auctions');
        debugPrint('========== API Response ==========\nURL: ${response.requestOptions.uri}\nStatus: ${response.statusCode}\nBody: ${response.data}');
        if (response.statusCode == 200) {
          final Map<String, dynamic> body = response.data;
          if (body['code'] == '200') {
            final resultList = body['result'] as List<dynamic>;
            final List<AuctionItem> cacheList = [];
            for (var item in resultList) {
              final auctionItem = AuctionItem(
                id: item['id'],
                brand: item['brand'],
                title: item['title'],
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
      debugPrint(e.toString());
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
        final response = await _authDio.get('/api/auction-winners/recent');
        debugPrint('========== API Response ==========\nURL: ${response.requestOptions.uri}\nStatus: ${response.statusCode}\nBody: ${response.data}');
        if (response.statusCode == 200) {
          final Map<String, dynamic> body = response.data;
          if (body['code'] == '200') {
            final resultList = body['result'] as List<dynamic>;
            final List<WinnerInfo> cacheList = [];
            for (var item in resultList) {
              final winnerInfo = WinnerInfo(nickname: item['nickname'], barnd: item['brand'], productName: item['title'], price: item['price']);
              cacheList.add(winnerInfo);
            }
            _auctionWinnerListLastUpdated = DateTime.now();
            _auctionWinnerListNotifier.value = cacheList;
          }
        }
      } catch (e) {
        debugPrint(e.toString());
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
        final response = await _authDio.get('/api/hot-deals');
        debugPrint('========== API Response ==========\nURL: ${response.requestOptions.uri}\nStatus: ${response.statusCode}\nBody: ${response.data}');
        if (response.statusCode == 200) {
          final Map<String, dynamic> body = response.data;
          if (body['code'] == '200') {
            final result = body['result'] as List<dynamic>;
            final List<LimitedItem> cacheList = [];
            for (var item in result) {
              final limitedItem = LimitedItem(
                id: item['id'],
                brand: item['brand'],
                title: item['title'],
                originPrice: item['originPrice'],
                price: item['price'],
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
      debugPrint(e.toString());
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
        final response = await _authDio.get('/api/products/best');
        debugPrint('========== API Response ==========\nURL: ${response.requestOptions.uri}\nStatus: ${response.statusCode}\nBody: ${response.data}');
        if (response.statusCode == 200) {
          final Map<String, dynamic> body = response.data;
          if (body['code'] == '200') {
            final result = body['result'] as List<dynamic>;
            final List<AlwayslItem> cacheList = [];
            for (var item in result) {
              final bestItem = AlwayslItem(
                id: item['id'],
                brand: item['brand'],
                title: item['title'],
                originPrice: item['originPrice'],
                price: item['price'],
                category: item['category'],
              );
              cacheList.add(bestItem);
              bestItem.syncWithFavoriteData();
            }
            _bestItemListLastUpdated = DateTime.now();
            _bestItemListNotifier.value = cacheList;
          }
        } else {
          debugPrint('베스트 상품 목록 조회 실패');
        }
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}
