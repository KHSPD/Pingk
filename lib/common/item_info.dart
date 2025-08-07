// ====================================================================================================
// 경매 상품 정보 클래스
// ====================================================================================================
class AuctionItem {
  final String id;
  final String brand;
  final String name;
  final int lastPrice;
  final DateTime endTime;
  final String thumbnail;
  bool isWished = false;

  AuctionItem({required this.id, required this.brand, required this.name, required this.lastPrice, required this.endTime, required this.thumbnail, this.isWished = false});
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
