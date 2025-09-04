import 'package:pingk/_common/constants.dart';

// ====================================================================================================
// 경매 상품 정보
// ====================================================================================================
class AuctionItem {
  final String idx;
  final String brand;
  final String productName;
  final int originPrice;
  final int lastPrice;
  final DateTime endAt;

  AuctionItem({required this.idx, required this.brand, required this.productName, required this.originPrice, required this.lastPrice, required this.endAt});

  String get thumbnail => '$imageServerURL/${idx}_thumb.png';
}

// ====================================================================================================
// 한정특가 상품 정보
// ====================================================================================================
class LimitedItem {
  String idx;
  final String productIdx;
  final String brand;
  final String productName;
  final int originPrice;
  final int price;
  final DateTime startAt;
  final DateTime endAt;
  bool isWished = false;

  LimitedItem({
    this.idx = '',
    required this.productIdx,
    required this.brand,
    required this.productName,
    required this.originPrice,
    required this.price,
    required this.startAt,
    required this.endAt,
    this.isWished = false,
  });

  String get thumbnail => '$imageServerURL/${productIdx}_thumb.png';
}

// ====================================================================================================
// 옥션 입찰자 정보
// ====================================================================================================
class WinnerInfo {
  String nickname;
  String barnd;
  String productName;
  int price;

  WinnerInfo({required this.nickname, required this.barnd, required this.productName, required this.price});
}
