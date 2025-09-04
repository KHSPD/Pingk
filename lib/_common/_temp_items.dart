import 'package:pingk/_common/item_info.dart';
import 'dart:math';

class TempItems {
  static final TempItems _instance = TempItems._internal();
  static final List<LimitedItem> bestDatas = [];
  static final List<LimitedItem> discountDatas = [];

  factory TempItems() {
    return _instance;
  }

  TempItems._internal() {
    // generalItems의 순서를 랜덤하게 섞고, 각 아이템의 id를 1부터 순차적으로 할당
    generalItems.shuffle();
    for (int i = 0; i < generalItems.length; i++) {
      generalItems[i].idx = (i + 1).toString();
      generalItems[i].isWished = Random().nextBool();
    }
    // generalItems을 각각 할당
    int total = generalItems.length;
    int part = (total / 3).floor();
    bestDatas.addAll(generalItems.sublist(part, part * 2));
    discountDatas.addAll(generalItems.sublist(part * 2));
  }

  // --------------------------------------------------
  // 일반 상품
  // --------------------------------------------------
  static final List<LimitedItem> generalItems = [
    LimitedItem(idx: '1', productIdx: '1', brand: '스타벅스', productName: 'B.L.T. 샌드위치', originPrice: 7500, price: 4000, startAt: DateTime.now(), endAt: DateTime.now()),
    LimitedItem(idx: '2', productIdx: '2', brand: '스타벅스', productName: '렌위치 NY 샌드위치', originPrice: 8800, price: 5300, startAt: DateTime.now(), endAt: DateTime.now()),
    LimitedItem(idx: '3', productIdx: '3', brand: '스타벅스', productName: '얼 그레이 티', originPrice: 7300, price: 6000, startAt: DateTime.now(), endAt: DateTime.now()),
    LimitedItem(idx: '4', productIdx: '4', brand: '스타벅스', productName: '오가닉 그릭 요거트 플레인', originPrice: 11000, price: 6500, startAt: DateTime.now(), endAt: DateTime.now()),
    LimitedItem(idx: '5', productIdx: '5', brand: '스타벅스', productName: '블랙&화이트 콜드 브루', originPrice: 7300, price: 6000, startAt: DateTime.now(), endAt: DateTime.now()),
    LimitedItem(idx: '6', productIdx: '6', brand: '스타벅스', productName: '블랙&화이트 콜드 브루', originPrice: 7300, price: 6000, startAt: DateTime.now(), endAt: DateTime.now()),
    LimitedItem(idx: '7', productIdx: '7', brand: '스타벅스', productName: '나이트로 바닐라 크림', originPrice: 8200, price: 6500, startAt: DateTime.now(), endAt: DateTime.now()),
    LimitedItem(idx: '8', productIdx: '8', brand: '스타벅스', productName: '아이스 로스티드 마카다미아 라떼', originPrice: 6500, price: 6000, startAt: DateTime.now(), endAt: DateTime.now()),
    LimitedItem(idx: '9', productIdx: '9', brand: '스타벅스', productName: '라벤더 카페 브레베', originPrice: 7000, price: 6500, startAt: DateTime.now(), endAt: DateTime.now()),
    LimitedItem(idx: '10', productIdx: '10', brand: '스타벅스', productName: '클래식 아포가토', originPrice: 7700, price: 6200, startAt: DateTime.now(), endAt: DateTime.now()),
    LimitedItem(idx: '11', productIdx: '11', brand: '스타벅스', productName: '더 멜론 오브 멜론 프라푸치노', originPrice: 8800, price: 7800, startAt: DateTime.now(), endAt: DateTime.now()),
    LimitedItem(idx: '12', productIdx: '12', brand: '스타벅스', productName: '자몽 망고 코코 프라푸치노', originPrice: 7500, price: 7000, startAt: DateTime.now(), endAt: DateTime.now()),
    LimitedItem(idx: '13', productIdx: '13', brand: '스타벅스', productName: '여수 바다 자몽 피지오', originPrice: 6500, price: 5000, startAt: DateTime.now(), endAt: DateTime.now()),
    LimitedItem(idx: '14', productIdx: '14', brand: '스타벅스', productName: '민트 블렌드 티', originPrice: 7300, price: 6000, startAt: DateTime.now(), endAt: DateTime.now()),
    LimitedItem(idx: '15', productIdx: '15', brand: '스타벅스', productName: '초코 쿠키 틴 세트', originPrice: 25000, price: 22000, startAt: DateTime.now(), endAt: DateTime.now()),
    LimitedItem(idx: '16', productIdx: '16', brand: '던킨도넛츠', productName: '페이머스 글레이즈드', originPrice: 4800, price: 3500, startAt: DateTime.now(), endAt: DateTime.now()),
    LimitedItem(idx: '17', productIdx: '17', brand: '던킨도넛츠', productName: '딸기 크림 가득 수줍은 스마일', originPrice: 6500, price: 4500, startAt: DateTime.now(), endAt: DateTime.now()),
    LimitedItem(idx: '18', productIdx: '18', brand: '던킨도넛츠', productName: '해피먼치킨컵(10개)', originPrice: 8900, price: 7900, startAt: DateTime.now(), endAt: DateTime.now()),
    LimitedItem(idx: '19', productIdx: '19', brand: '던킨도넛츠', productName: '미니도넛세트', originPrice: 15000, price: 9900, startAt: DateTime.now(), endAt: DateTime.now()),
    LimitedItem(idx: '20', productIdx: '20', brand: '던킨도넛츠', productName: '새우볼&칙피스샐러드', originPrice: 8900, price: 7900, startAt: DateTime.now(), endAt: DateTime.now()),
    LimitedItem(idx: '21', productIdx: '21', brand: '던킨도넛츠', productName: '플레인 스콘', originPrice: 4800, price: 3500, startAt: DateTime.now(), endAt: DateTime.now()),
    LimitedItem(idx: '22', productIdx: '22', brand: '던킨도넛츠', productName: '바스크 치즈케이크', originPrice: 6500, price: 4500, startAt: DateTime.now(), endAt: DateTime.now()),
  ];
}
