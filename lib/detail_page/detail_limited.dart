import 'package:flutter/material.dart';
import 'package:pingk/_common/api_service.dart';
import 'package:pingk/_common/item_info.dart';
import 'package:pingk/_common/my_styles.dart';
import 'package:pingk/_common/my_functions.dart';
import 'package:pingk/_common/my_widget.dart';

// ====================================================================================================
// DetailLimited
// ====================================================================================================
class DetailLimited extends StatefulWidget {
  final String itemId;

  const DetailLimited({super.key, required this.itemId});

  @override
  State<DetailLimited> createState() => _DetailLimitedState();
}

class _DetailLimitedState extends State<DetailLimited> {
  LimitedItem? _itemData;

  // --------------------------------------------------
  // Lifecycle Methods
  // --------------------------------------------------
  @override
  void initState() {
    super.initState();
    _loadItemData();
  }

  @override
  void dispose() {
    super.dispose();
  }

  // --------------------------------------------------
  // 상품 상세정보 로드
  // --------------------------------------------------
  void _loadItemData() {
    _itemData = ApiService().limitedItemListNotifier.value.firstWhere((item) => item.id == widget.itemId);
  }

  @override
  Widget build(BuildContext context) {
    if (_itemData == null) {
      return Scaffold(
        appBar: AppBar(title: const Text(''), backgroundColor: MyColors.background1, foregroundColor: Colors.black),
        body: const Center(child: Text('상품을 찾을 수 없습니다.')),
      );
    }

    return Scaffold(
      backgroundColor: Color(0xFFFFFFFF),

      appBar: AppBar(
        title: const Text(
          '한정특가',
          style: TextStyle(fontSize: 18, color: Color(0xFF393939), fontWeight: FontWeight.w500, letterSpacing: -0.3),
        ),
        backgroundColor: Color(0xFFFFFFFF),
        elevation: 0,
      ),

      bottomNavigationBar: Container(
        padding: const EdgeInsets.fromLTRB(30, 20, 30, 40),
        decoration: const BoxDecoration(
          color: MyColors.background1,
          border: Border(top: BorderSide(color: Colors.grey, width: 0.5)),
        ),
        child: BottomLongButton('구매하기', () => {}),
      ),

      body: SingleChildScrollView(
        child: SizedBox(
          width: double.infinity,
          child: Column(
            children: [
              SizedBox(height: 50),
              // ----- 상품 이미지 -----
              ClipOval(
                child: Container(
                  width: 220,
                  height: 220,
                  decoration: BoxDecoration(color: MyColors.background1),
                  child: AspectRatio(
                    aspectRatio: 1,
                    child: Image.network(
                      _itemData!.thumbnail,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: MyColors.background1,
                          child: const Icon(Icons.image_not_supported, color: MyColors.text2, size: 40),
                        );
                      },
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 30),

              // ----- 상품 정보 -----
              Container(
                width: double.infinity,
                height: 180,
                alignment: Alignment.bottomLeft,
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Stack(
                  children: [
                    // ----- 브랜드명 -----
                    Positioned(
                      top: 0,
                      left: 0,
                      child: Text(
                        _itemData!.brand,
                        style: const TextStyle(fontSize: 13, color: MyColors.text1, fontWeight: FontWeight.w300),
                      ),
                    ),

                    // ----- 상품명 -----
                    Positioned(
                      top: 20,
                      left: 0,
                      child: Text(
                        _itemData!.title,
                        style: const TextStyle(fontSize: 24, color: MyColors.text1, fontWeight: FontWeight.w600),
                        textAlign: TextAlign.left,
                      ),
                    ),

                    Positioned(
                      bottom: 90,
                      right: 0,
                      child: Container(
                        width: 52,
                        height: 23,
                        decoration: BoxDecoration(color: MyColors.background1, borderRadius: BorderRadius.circular(20)),
                        alignment: Alignment.center,
                        child: RichText(
                          text: TextSpan(
                            text: '${MyFN.discountRate(_itemData!.originPrice, _itemData!.price)}%',
                            style: const TextStyle(fontFamily: 'Pretendard', fontSize: 14, color: Colors.white, fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                    ),

                    Positioned(
                      bottom: 52,
                      right: 0,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(bottom: 3),
                            child: Text(
                              '${MyFN.formatNumberWithComma(_itemData!.originPrice)}원',
                              style: const TextStyle(
                                fontSize: 16,
                                color: MyColors.text2,
                                fontWeight: FontWeight.w300,
                                decoration: TextDecoration.lineThrough,
                                decorationColor: MyColors.text2,
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Text(
                            MyFN.formatNumberWithComma(_itemData!.price),
                            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w800, color: MyColors.text1),
                          ),
                          const SizedBox(width: 2),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 3),
                            child: const Text(
                              '원',
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w300, color: MyColors.text1),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 8),

              // ----- 하단 텍스트 -----
              Container(
                width: double.infinity,
                alignment: Alignment.topLeft,
                color: MyColors.background1,
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 40),
                    Text(
                      '확인해주세요!',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: MyColors.text1),
                    ),
                    SizedBox(height: 10),
                    Text(
                      '- 1일 1회 참여가능합니다.\n- 경매는 48시간 진행됩니다.\n- 쿠폰 금액에 따라 10원 단위 또는 100원 단위로\n   경매참여가 가능합니다.',
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.w300, color: MyColors.text2),
                    ),
                    Divider(color: MyColors.text2, thickness: 0.5, height: 50),
                    Text(
                      '상세정보',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: MyColors.text1),
                    ),
                    SizedBox(height: 10),
                    Text(
                      '- 상품 소진 시 이벤트 기관에 상관없이 조기 종료 될 수 있습니다.\n- 핫딜 상품은 1인 1개 구매가능하며, 기간 연장이 불가합니다.',
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.w300, color: MyColors.text2),
                    ),
                    SizedBox(height: 30),
                    Text(
                      '사용장소',
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: MyColors.text2),
                    ),
                    SizedBox(height: 8),
                    Text(
                      '사용가능매장 : BHC 전매장\n사용불가매장 : 제주지역, 공항, 리조트, 휴게소, 군부대 등 특화 매장',
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.w300, color: MyColors.text2),
                    ),
                    SizedBox(height: 30),
                    Text(
                      '상품 주문시 유의사항',
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: MyColors.text2),
                    ),
                    SizedBox(height: 8),
                    Text(
                      '개인용도, 재판매, 현금유통, 재산상이득 행위(카드깡 등)의 주문 이력이 확인 될 경우 주문취소 및 서비스 이용이 제한 됩니다. 발송 실패 된 주문은 주문자에게 환불(캐쉬환불 또는 결제취소)처리 되며 유효기간 이내에 주문정보 수정 후 재발송 가능합니다. 빠른 환불 문의는 1:1문의 접수 바랍니다.',
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.w300, color: MyColors.text2),
                    ),
                    SizedBox(height: 30),
                    Text(
                      '이용안내',
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: MyColors.text2),
                    ),
                    SizedBox(height: 8),
                    Text(
                      '1.BHC 홈페이지 접속   >    2. 온라인 주문 클릭   >    3. 배달지 등록 및 배달지 선택 >    4.모바일쿠폰 주문클릭 후 번호 입력    >    5.결제하기',
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.w300, color: MyColors.text2),
                    ),
                    SizedBox(height: 50),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
