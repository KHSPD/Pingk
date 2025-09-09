import 'package:pingk/_common/constants.dart';
import 'package:pingk/_common/favorite_data.dart';
import 'package:hive/hive.dart';

part 'item_info.g.dart';

// ====================================================================================================
// 옥션 상품 정보
// ====================================================================================================
class AuctionItem {
  final String id;
  final String brand;
  final String title;
  final int originPrice;
  final int lastPrice;
  final DateTime endAt;

  AuctionItem({required this.id, required this.brand, required this.title, required this.originPrice, required this.lastPrice, required this.endAt});

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
@HiveType(typeId: 0)
class AlwayslItem extends HiveObject {
  final String id;
  String brand;
  String title;
  int originPrice;
  int price;
  String category;
  bool isFavorite = false;
  String status;

  AlwayslItem({
    required this.id,
    required this.brand,
    required this.title,
    required this.originPrice,
    required this.price,
    required this.category,
    this.isFavorite = false,
    this.status = 'ACTIVE',
  });

  String get thumbnail => '$imageServerURL/${id}_thumb.png';

  void toggleFavorite() {
    isFavorite = !isFavorite;
    if (isFavorite) {
      FavoriteData().add(this);
    } else {
      FavoriteData().remove(id);
    }
  }

  void syncWithFavoriteData() {
    isFavorite = FavoriteData().list.any((item) => item.id == id);
  }
}
