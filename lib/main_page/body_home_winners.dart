import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pingk/_common/api_request.dart';
import 'package:pingk/_common/item_info.dart';
import 'package:pingk/_common/my_functions.dart';
import 'package:pingk/_common/my_styles.dart';

// ====================================================================================================
// 홈 - 낙찰자 목록
// ====================================================================================================
class BodyHomeWinnersList extends StatefulWidget {
  const BodyHomeWinnersList({super.key});

  @override
  State<BodyHomeWinnersList> createState() => _BodyHomeWinnersListState();
}

class _BodyHomeWinnersListState extends State<BodyHomeWinnersList> {
  final _itemDatas = ApiRequest().auctionWinnerListNotifier;
  bool _isLoading = true;

  // --------------------------------------------------
  // Lifecycle Methods
  // --------------------------------------------------
  @override
  void initState() {
    super.initState();
    _itemDatas.addListener(_onItemListChanged);
    ApiRequest().fetchAuctionWinnerList().then((_) {
      setState(() {
        _isLoading = false;
      });
    });
  }

  @override
  void dispose() {
    _itemDatas.removeListener(_onItemListChanged);
    super.dispose();
  }

  // --------------------------------------------------
  // 아이템 목록 변경 이벤트
  // --------------------------------------------------
  void _onItemListChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  // --------------------------------------------------
  // build
  // --------------------------------------------------
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(30, 40, 30, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
            child: Text(
              '핑크옥션 낙찰을 축하합니다!',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Color(0xFFFF437A), letterSpacing: -0.3),
            ),
          ),

          Container(
            width: double.infinity,
            margin: const EdgeInsets.only(top: 20),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            decoration: BoxDecoration(
              color: Color(0xFFFFFFFF),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: Color(0xFFF6F1F1), width: 1),
              boxShadow: [MyShadows.pink1],
            ),
            child: _isLoading
                ? SizedBox(
                    height: 120,
                    child: Center(child: CircularProgressIndicator(color: Color(0xFFFF437A))),
                  )
                : Column(children: _itemDatas.value.asMap().entries.map((entry) => _buildWinnerItem(entry.value, entry.key)).toList()),
          ),
        ],
      ),
    );
  }

  // --------------------------------------------------
  // 당첨자 아이템 위젯
  // --------------------------------------------------
  Widget _buildWinnerItem(WinnerInfo winner, int index) {
    bool isLastItem = index == _itemDatas.value.length - 1;

    return Column(
      children: [
        Container(
          width: double.infinity,
          margin: const EdgeInsets.fromLTRB(0, 14, 0, 14),
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
          child: Column(
            children: [
              Row(
                children: [
                  SvgPicture.asset('assets/icons/icon_medal_bold.svg', width: 14, height: 19),
                  const SizedBox(width: 6),
                  Text(
                    winner.nickname,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Color(0xFF4A4A4A), letterSpacing: -0.3),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  Text(
                    '${winner.barnd} | ${winner.productName}',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: Color(0xFF969696), letterSpacing: -0.3),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.right,
                  ),
                  const Spacer(),
                  Text(
                    '${MyFN.formatNumberWithComma(winner.price)} 낙찰',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: Color(0xFFFF437A), letterSpacing: -0.2),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.right,
                  ),
                ],
              ),
            ],
          ),
        ),
        if (!isLastItem) Container(height: 1, margin: const EdgeInsets.symmetric(horizontal: 15), color: Color(0xFFEEEEEE)),
      ],
    );
  }
}
