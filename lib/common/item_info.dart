// ====================================================================================================
// 경매 상품 정보 클래스
// ====================================================================================================
import 'package:pingk/common/constants.dart';

class AuctionItem {
  final String idx;
  final String brand;
  final String productName;
  final int lastPrice;
  final DateTime endAt;

  AuctionItem({required this.idx, required this.brand, required this.productName, required this.lastPrice, required this.endAt});

  String get thumbnail => '$imageServerURL/${idx}_thumb.png';
}

// ====================================================================================================
// 일반 상품 정보 클래스
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
// 상품 카테고리 정보 클래스
// ====================================================================================================
class WinnerInfo {
  String nickname;
  String barnd;
  String productName;

  WinnerInfo({required this.nickname, required this.barnd, required this.productName});
}
