import 'package:pingk/_common/constants.dart';

// ====================================================================================================
// 옥션 상품 정보
// ====================================================================================================
class AuctionItem {
  final String id;
  final String brand;
  final String productName;
  final int originPrice;
  final int lastPrice;
  final DateTime endAt;

  AuctionItem({required this.id, required this.brand, required this.productName, required this.originPrice, required this.lastPrice, required this.endAt});

  String get thumbnail => '$imageServerURL/${id}_thumb.png';
}

// ====================================================================================================
// 옥션 낙찰자 정보
// ====================================================================================================
class WinnerInfo {
  String nickname;
  String barnd;
  String productName;
  int price;

  WinnerInfo({required this.nickname, required this.barnd, required this.productName, required this.price});
}

// ====================================================================================================
// 한정특가 상품 정보
// ====================================================================================================
class LimitedItem {
  String id;
  final String brand;
  final String title;
  final int originPrice;
  final int price;
  final DateTime startAt;
  final DateTime endAt;
  bool isWished = false;

  LimitedItem({
    this.id = '',
    required this.brand,
    required this.title,
    required this.originPrice,
    required this.price,
    required this.startAt,
    required this.endAt,
    this.isWished = false,
  });

  String get thumbnail => '$imageServerURL/${id}_thumb.png';
}

// ====================================================================================================
// 상시특가 상품 정보
// ====================================================================================================
class AlwayslItem {
  String id;
  final String brand;
  final String title;
  final int originPrice;
  final int price;
  final String category;
  bool isWished = false;

  AlwayslItem({required this.id, required this.brand, required this.title, required this.originPrice, required this.price, required this.category, this.isWished = false});

  String get thumbnail => '$imageServerURL/${id}_thumb.png';
}
