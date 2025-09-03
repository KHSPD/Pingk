import 'package:pingk/common/constants.dart';

// ====================================================================================================
// 경매 상품 정보
// ====================================================================================================
class AuctionItem {
  final String idx;
  final String brand;
  final String productName;
  final int originalPrice;
  final int lastPrice;
  final DateTime endAt;

  AuctionItem({required this.idx, required this.brand, required this.productName, required this.originalPrice, required this.lastPrice, required this.endAt});

  String get thumbnail => '$imageServerURL/${idx}_thumb.png';
}

// ====================================================================================================
// 일반 상품 정보
// ====================================================================================================
class GeneralItem {
  String id;
  final String brand;
  final String name;
  final int originalPrice;
  final int price;
  final String thumbnail;
  bool isWished = false;

  GeneralItem({this.id = '', required this.brand, required this.name, required this.originalPrice, required this.price, required this.thumbnail, this.isWished = false});
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
