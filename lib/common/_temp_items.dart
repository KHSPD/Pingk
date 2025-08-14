import 'package:pingk/common/item_info.dart';
import 'dart:math';

class TempItems {
  static final TempItems _instance = TempItems._internal();
  static final List<GeneralItem> todaysHotDealDatas = [];
  static final List<GeneralItem> bestDatas = [];
  static final List<GeneralItem> discountDatas = [];
  static final List<GeneralItem> comingSoonHotDealDatas = [];

  factory TempItems() {
    return _instance;
  }

  TempItems._internal() {
    // generalItems의 순서를 랜덤하게 섞고, 각 아이템의 id를 1부터 순차적으로 할당
    generalItems.shuffle();
    for (int i = 0; i < generalItems.length; i++) {
      generalItems[i].id = (i + 1).toString();
      generalItems[i].isWished = Random().nextBool();
    }
    // generalItems을 각각 할당
    int total = generalItems.length;
    int part = (total / 3).floor();
    todaysHotDealDatas.addAll(generalItems.sublist(0, part));
    bestDatas.addAll(generalItems.sublist(part, part * 2));
    discountDatas.addAll(generalItems.sublist(part * 2));
    // comingSoonItems에 랜덤하게 5개의 상품을 추가
    final random = Random();
    final tempList = List<GeneralItem>.from(generalItems);
    tempList.shuffle(random);
    comingSoonHotDealDatas.addAll(tempList.take(5));
  }

  static final List<AuctionItem> auctionItems = [
    // --------------------------------------------------
    // 경매 상품
    // --------------------------------------------------
    AuctionItem(
      id: '1',
      brand: '스타벅스',
      name: '아이스아메리카노 Tall',
      lastPrice: 1350,
      endTime: DateTime.now().add(const Duration(days: 1)),
      thumbnail: 'https://image.istarbucks.co.kr/upload/store/skuimg/2025/06/[106509]_20250626092521572.jpg',
      isWished: false,
    ),
    AuctionItem(
      id: '2',
      brand: 'BHC',
      name: '황금올리브 치킨 1마리',
      lastPrice: 32800,
      endTime: DateTime.now().add(const Duration(days: 1)),
      thumbnail: 'https://cdn.imweb.me/upload/S20220826948cbdc34dca3/1e0c8bbbe23a7.jpg',
      isWished: false,
    ),
    AuctionItem(
      id: '3',
      brand: '스타벅스',
      name: '조각 케익 1조각',
      lastPrice: 2010,
      endTime: DateTime.now().add(const Duration(days: 1)),
      thumbnail: 'https://image.istarbucks.co.kr/upload/store/skuimg/2024/10/[9300000005606]_20241022091857939.jpg',
      isWished: false,
    ),
    AuctionItem(
      id: '4',
      brand: '공차',
      name: '브라운슈가 밀크티 펄 쉐이크',
      lastPrice: 650,
      endTime: DateTime.now().add(const Duration(days: 1)),
      thumbnail: 'https://www.gong-cha.co.kr/upload/product/eab6cad14d5d91998574d9f07536d69e.png',
      isWished: false,
    ),
    AuctionItem(
      id: '5',
      brand: '신전떡볶이',
      name: '로제떡볶이',
      lastPrice: 1110,
      endTime: DateTime.now().add(const Duration(days: 1)),
      thumbnail: 'https://sinjeon.co.kr/img/sub/menu01/menu41.png',
      isWished: false,
    ),
    AuctionItem(
      id: '6',
      brand: '신전떡볶이',
      name: '고구마치즈볼',
      lastPrice: 780,
      endTime: DateTime.now().add(const Duration(days: 1)),
      thumbnail: 'https://sinjeon.co.kr/img/sub_re/menu/menu12.png',
      isWished: false,
    ),
  ];

  // --------------------------------------------------
  // 일반 상품
  // --------------------------------------------------
  static final List<GeneralItem> generalItems = [
    GeneralItem(
      id: '1',
      brand: '스타벅스',
      name: 'B.L.T. 샌드위치',
      originalPrice: 7500,
      price: 4000,
      thumbnail: 'https://image.istarbucks.co.kr/upload/store/skuimg/2025/07/[9300000005940]_20250721095525217.jpg',
    ),
    GeneralItem(
      id: '2',
      brand: '스타벅스',
      name: '렌위치 NY 샌드위치',
      originalPrice: 8800,
      price: 5300,
      thumbnail: 'https://image.istarbucks.co.kr/upload/store/skuimg/2025/07/[9300000006024]_20250710154216315.jpg',
    ),
    GeneralItem(
      id: '3',
      brand: '스타벅스',
      name: '얼 그레이 티',
      originalPrice: 7300,
      price: 6000,
      thumbnail: 'https://image.istarbucks.co.kr/upload/store/skuimg/2021/04/[4004000000036]_20210415143933578.jpg',
    ),
    GeneralItem(
      id: '4',
      brand: '스타벅스',
      name: '오가닉 그릭 요거트 플레인',
      originalPrice: 11000,
      price: 6500,
      thumbnail: 'https://image.istarbucks.co.kr/upload/store/skuimg/2021/08/[9300000003231]_20210826102030821.jpg',
    ),
    GeneralItem(
      id: '5',
      brand: '스타벅스',
      name: '디스커버리 코리아 머그 414ml',
      originalPrice: 22000,
      price: 14500,
      thumbnail: 'https://image.istarbucks.co.kr/upload/store/skuimg/2025/07/[11171980]_20250707124820844.jpg',
    ),
    GeneralItem(
      id: '6',
      brand: '스타벅스',
      name: '블랙&화이트 콜드 브루',
      originalPrice: 7300,
      price: 6000,
      thumbnail: 'https://image.istarbucks.co.kr/upload/store/skuimg/2025/07/[9200000006301]_20250703090404091.jpg',
    ),
    GeneralItem(
      id: '7',
      brand: '스타벅스',
      name: '나이트로 바닐라 크림',
      originalPrice: 8200,
      price: 6500,
      thumbnail: 'https://image.istarbucks.co.kr/upload/store/skuimg/2025/06/[9200000002487]_20250626171201110.jpg',
    ),
    GeneralItem(
      id: '8',
      brand: '스타벅스',
      name: '아이스 로스티드 마카다미아 라떼',
      originalPrice: 6500,
      price: 6000,
      thumbnail: 'https://image.istarbucks.co.kr/upload/store/skuimg/2025/07/[9200000006265]_20250708142305891.jpg',
    ),
    GeneralItem(
      id: '9',
      brand: '스타벅스',
      name: '라벤더 카페 브레베',
      originalPrice: 7000,
      price: 6500,
      thumbnail: 'https://image.istarbucks.co.kr/upload/store/skuimg/2022/04/[9200000004119]_20220412083025862.png',
    ),
    GeneralItem(
      id: '10',
      brand: '스타벅스',
      name: '클래식 아포가토',
      originalPrice: 7700,
      price: 6200,
      thumbnail: 'https://image.istarbucks.co.kr/upload/store/skuimg/2021/02/[9200000001631]_20210225090916684.jpg',
    ),
    GeneralItem(
      id: '11',
      brand: '스타벅스',
      name: '더 멜론 오브 멜론 프라푸치노',
      originalPrice: 8800,
      price: 7800,
      thumbnail: 'https://image.istarbucks.co.kr/upload/store/skuimg/2025/07/[9200000005295]_20250708143557285.jpg',
    ),
    GeneralItem(
      id: '12',
      brand: '스타벅스',
      name: '자몽 망고 코코 프라푸치노',
      originalPrice: 7500,
      price: 7000,
      thumbnail: 'https://image.istarbucks.co.kr/upload/store/skuimg/2025/07/[9200000005363]_20250718081110007.jpg',
    ),
    GeneralItem(
      id: '13',
      brand: '스타벅스',
      name: '여수 바다 자몽 피지오',
      originalPrice: 6500,
      price: 5000,
      thumbnail: 'https://image.istarbucks.co.kr/upload/store/skuimg/2023/09/[9200000004751]_20230907153225204.jpg',
    ),
    GeneralItem(
      id: '14',
      brand: '스타벅스',
      name: '민트 블렌드 티',
      originalPrice: 7300,
      price: 6000,
      thumbnail: 'https://image.istarbucks.co.kr/upload/store/skuimg/2021/04/[4004000000056]_20210415135215632.jpg',
    ),
    GeneralItem(
      id: '15',
      brand: '스타벅스',
      name: '초코 쿠키 틴 세트',
      originalPrice: 25000,
      price: 22000,
      thumbnail: 'https://image.istarbucks.co.kr/upload/store/skuimg/2025/01/[9300000005687]_20250124083719905.jpg',
    ),

    // --------------------------------------------------
    GeneralItem(
      id: '16',
      brand: '던킨도넛츠',
      name: '페이머스 글레이즈드',
      originalPrice: 4800,
      price: 3500,
      thumbnail: 'https://www.dunkindonuts.co.kr/storage/product/mainimgfile/P3tLi275D0A00m8A7O2HSEuLeTVGMZy0aUfySsQA.png',
    ),
    GeneralItem(
      id: '17',
      brand: '던킨도넛츠',
      name: '딸기 크림 가득 수줍은 스마일',
      originalPrice: 6500,
      price: 4500,
      thumbnail: 'https://www.dunkindonuts.co.kr/storage/product/mainimgfile/uX4SDTXvHN5E9ZLD8TWbgMu7kmNOYw49groGFJ00.png',
    ),
    GeneralItem(
      id: '18',
      brand: '던킨도넛츠',
      name: '해피먼치킨컵(10개)',
      originalPrice: 8900,
      price: 7900,
      thumbnail: 'https://www.dunkindonuts.co.kr/storage/product/mainimgfile/xNfaXO3RKbS1mphLYxyIBodnSW24JiwyWALz0ytz.png',
    ),
    GeneralItem(
      id: '19',
      brand: '던킨도넛츠',
      name: '미니도넛세트',
      originalPrice: 15000,
      price: 9900,
      thumbnail: 'https://www.dunkindonuts.co.kr/storage/product/mainimgfile/dwjSDvdA2ltp51FrAUl0aUJK8mDS6qfRyvfSWIM9.png',
    ),
    GeneralItem(
      id: '20',
      brand: '던킨도넛츠',
      name: '새우볼&칙피스샐러드',
      originalPrice: 8900,
      price: 7900,
      thumbnail: 'https://www.dunkindonuts.co.kr/storage/product/mainimgfile/I03RqzNQNgmjCl99js4CBDW3t6RLUx2cMEmLxVxb.png',
    ),
    GeneralItem(
      id: '21',
      brand: '던킨도넛츠',
      name: '플레인 스콘',
      originalPrice: 4800,
      price: 3500,
      thumbnail: 'https://www.dunkindonuts.co.kr/storage/product/mainimgfile/bEmTR6IxTlDFTVgMKn9oxplq9SyFZRxzovJRh3Sp.png',
    ),
    GeneralItem(
      id: '22',
      brand: '던킨도넛츠',
      name: '바스크 치즈케이크',
      originalPrice: 6500,
      price: 4500,
      thumbnail: 'https://www.dunkindonuts.co.kr/storage/product/mainimgfile/PyeBisDMpgWy3MWJowhfjnEoMmVnZ50Cm4U9Fcrj.png',
    ),
    GeneralItem(
      id: '23',
      brand: '던킨도넛츠',
      name: '던킨 카페모카롤',
      originalPrice: 5500,
      price: 5000,
      thumbnail: 'https://www.dunkindonuts.co.kr/storage/product/mainimgfile/IDHqab1ZEtuEjdNHxqgP3elIVa76sW3zDLdHSIpl.png',
    ),
    GeneralItem(
      id: '24',
      brand: '던킨도넛츠',
      name: '쿠키앤 크림 도넛',
      originalPrice: 5800,
      price: 5200,
      thumbnail: 'https://www.dunkindonuts.co.kr/storage/product/mainimgfile/qSfeVHFHQbrZ9CpDJ5VD8ZsLQ9BOOeHAFtXpdbuQ.png',
    ),
    GeneralItem(
      id: '25',
      brand: '던킨도넛츠',
      name: '던킨 글레이즈드 팝콘',
      originalPrice: 8500,
      price: 7500,
      thumbnail: 'https://www.dunkindonuts.co.kr/storage/product/mainimgfile/5I4XlnUDgiKBvLXx5iPAAN8BHqB7GcJuXCsX4Tg1.png',
    ),
    GeneralItem(
      id: '26',
      brand: '던킨도넛츠',
      name: '크리스피 치즈볼',
      originalPrice: 6600,
      price: 5500,
      thumbnail: 'https://www.dunkindonuts.co.kr/storage/product/mainimgfile/NCyly5JkhWdGHz9em5XTW8h9YZD1pahK1RbTi239.png',
    ),
    GeneralItem(
      id: '27',
      brand: '던킨도넛츠',
      name: '라이스칩 플레인',
      originalPrice: 18500,
      price: 16000,
      thumbnail: 'https://www.dunkindonuts.co.kr/storage/product/mainimgfile/QCxjNXqw5d0MyblqnN89yHqoQNkaI0Ic7WVUpnOx.png',
    ),
    GeneralItem(
      id: '28',
      brand: '던킨도넛츠',
      name: '통닭가슴살&에그샐러드',
      originalPrice: 11900,
      price: 10900,
      thumbnail: 'https://www.dunkindonuts.co.kr/storage/product/mainimgfile/ePml726hInoDX01szhR92Ogha7cNgWHTSHP4XkOC.png',
    ),
    GeneralItem(
      id: '29',
      brand: '던킨도넛츠',
      name: '콰트로 치즈 크로크무슈',
      originalPrice: 6400,
      price: 6000,
      thumbnail: 'https://www.dunkindonuts.co.kr/storage/product/mainimgfile/02Zpq7XKbcffasRUPX9CKjQFncso4RRLus5siFzt.png',
    ),
    GeneralItem(
      id: '30',
      brand: '던킨도넛츠',
      name: '칠리 베이컨 에그 랩 샌드위치',
      originalPrice: 7700,
      price: 5600,
      thumbnail: 'https://www.dunkindonuts.co.kr/storage/product/mainimgfile/yuXCvJLswjwCtsQm8poyPuYE7orWfA99PgAUvTmS.png',
    ),
    GeneralItem(
      id: '31',
      brand: '던킨도넛츠',
      name: '케이준 치킨 샐러드',
      originalPrice: 10000,
      price: 8500,
      thumbnail: 'https://www.dunkindonuts.co.kr/storage/product/mainimgfile/TPnD5qQOWzDlyHtX2bYfbEhhBoKGASDVXF0fiWnX.png',
    ),

    // --------------------------------------------------
    GeneralItem(
      id: '32',
      brand: '교촌치킨',
      name: '후라이드싱글윙',
      originalPrice: 7900,
      price: 6800,
      thumbnail: 'https://www.kyochon.com/uploadFiles/TB_ITEM/list-%ED%9B%84%EB%9D%BC%EC%9D%B4%EB%93%9C%EC%8B%B1%EA%B8%80%EC%9C%99(3).png',
    ),
    GeneralItem(
      id: '33',
      brand: '교촌치킨',
      name: '허니콤보',
      originalPrice: 23000,
      price: 22000,
      thumbnail: 'https://www.kyochon.com/uploadFiles/TB_ITEM/%EA%B5%90%EC%B4%8C-%ED%97%88%EB%8B%88-%EC%BD%A4%EB%B3%B4(1).png',
    ),
    GeneralItem(
      id: '34',
      thumbnail: 'https://www.kyochon.com/uploadFiles/TB_ITEM/%EB%B8%8C%EB%9E%9C%EB%93%9C_list_15-10-221025.png',
      brand: '교촌치킨',
      name: '파채소이살살',
      originalPrice: 19000,
      price: 16500,
    ),
    GeneralItem(
      id: '35',
      brand: '교촌치킨',
      name: '후라이드양념반반한마리',
      originalPrice: 22000,
      price: 21000,
      thumbnail: 'https://www.kyochon.com/uploadFiles/TB_ITEM/list_%ED%9B%84%EB%9D%BC%EC%9D%B4%EB%93%9C%EC%96%91%EB%85%90%EB%B0%98%EB%B0%98%ED%95%9C%EB%A7%88%EB%A6%AC.png',
    ),
    GeneralItem(
      id: '36',
      brand: '교촌치킨',
      name: '살살후라이드',
      originalPrice: 20000,
      price: 19000,
      thumbnail: 'https://www.kyochon.com/uploadFiles/TB_ITEM/%EB%B8%8C%EB%9E%9C%EB%93%9C_list_15-10-221035.png',
    ),
    GeneralItem(
      id: '37',
      brand: '교촌치킨',
      name: '다담덮밥(간장맛)',
      originalPrice: 8500,
      price: 7500,
      thumbnail: 'https://www.kyochon.com/uploadFiles/TB_ITEM/01_list-%EB%8B%A4%EB%8B%B4%EB%8D%AE%EB%B0%A5(%EA%B0%84%EC%9E%A5%EB%A7%9B)(3).png',
    ),
    GeneralItem(
      id: '38',
      brand: '교촌치킨',
      name: '국물맵떡',
      originalPrice: 9000,
      price: 8000,
      thumbnail: 'https://www.kyochon.com/uploadFiles/TB_ITEM/KakaoTalk_Photo_2022-11-22-14-02-39%20002.png',
    ),
    GeneralItem(id: '39', brand: '교촌치킨', name: '모둠어묵탕[홀전용]', originalPrice: 16000, price: 13000, thumbnail: 'https://www.kyochon.com/uploadFiles/TB_ITEM/list_fishcake.png'),
    GeneralItem(
      id: '40',
      brand: '교촌치킨',
      name: '레드스틱[S]',
      originalPrice: 13000,
      price: 11000,
      thumbnail: 'https://www.kyochon.com/uploadFiles/TB_ITEM/30020_%EB%A0%88%EB%93%9C%EC%8A%A4%ED%8B%B1s_list.png',
    ),
    GeneralItem(
      id: '41',
      brand: '교촌치킨',
      name: '양념치킨한마리',
      originalPrice: 22000,
      price: 20000,
      thumbnail: 'https://www.kyochon.com/uploadFiles/TB_ITEM/list_%EC%96%91%EB%85%90%EC%B9%98%ED%82%A8%ED%95%9C%EB%A7%88%EB%A6%AC.png',
    ),
  ];
}
