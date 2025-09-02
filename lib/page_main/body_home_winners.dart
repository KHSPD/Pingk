import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:http/http.dart' as http;
import 'package:pingk/common/constants.dart';
import 'package:pingk/common/item_info.dart';
import 'package:pingk/common/my_styles.dart';
import 'package:pingk/common/token_manager.dart';

// ====================================================================================================
// 홈 - 낙찰자 목록
// ====================================================================================================
class BodyHomeWinnersList extends StatefulWidget {
  const BodyHomeWinnersList({super.key});

  @override
  State<BodyHomeWinnersList> createState() => _BodyHomeWinnersListState();
}

class _BodyHomeWinnersListState extends State<BodyHomeWinnersList> {
  final List<WinnerInfo> _winnerDataList = [];
  bool _isLoading = true;

  // --------------------------------------------------
  // Lifecycle Methods
  // --------------------------------------------------
  @override
  void initState() {
    debugPrint('BodyHomeWinnersList : initState');
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadWinners();
    });
  }

  @override
  void dispose() {
    debugPrint('BodyHomeWinnersList : dispose');
    super.dispose();
  }

  // --------------------------------------------------
  // API - 최근 낙찰자 조회
  // --------------------------------------------------
  Future<void> _loadWinners() async {
    try {
      final String apiUrl = '$apiServerURL/api/auction-winners/recent';
      final String? accessToken = await JwtManager().getAccessToken();

      if (accessToken == null) {
        debugPrint('토큰 없거나 만료됨');
        // TODO: 로그인 페이지로 이동
        return;
      }

      final response = await http.get(Uri.parse(apiUrl), headers: {'Content-Type': 'application/json', 'X-Access-Token': accessToken});
      debugPrint('========== API Response: $apiUrl =====\nStatus: ${response.statusCode}\nBody: ${response.body}');
      if (response.statusCode == 200) {
        final Map<String, dynamic> body = jsonDecode(response.body);
        if (body['code'] == '200') {
          final resultList = body['result'] as List<dynamic>;
          _winnerDataList.clear();
          for (var item in resultList) {
            WinnerInfo winnerInfo = WinnerInfo(nickname: item['nickname'], barnd: item['brand'], productName: item['productName']);
            _winnerDataList.add(winnerInfo);
          }
          setState(() {
            _isLoading = false;
          });
        }
      }
    } catch (e) {
      debugPrint('Exception: ${e.toString()}');
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
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SvgPicture.asset('assets/icons/icon_medal_bold.svg', width: 14, height: 19),
                const SizedBox(width: 6),
                Text(
                  '핑크옥션 낙찰을 축하합니다!',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Color(0xFFFF437A), letterSpacing: -0.3),
                ),
              ],
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
              boxShadow: [MyShadows.type2],
            ),
            child: _isLoading
                ? SizedBox(
                    height: 120,
                    child: Center(child: CircularProgressIndicator(color: Color(0xFFFF437A))),
                  )
                : Column(children: _winnerDataList.asMap().entries.map((entry) => _buildWinnerItem(entry.value, entry.key)).toList()),
          ),
        ],
      ),
    );
  }

  // --------------------------------------------------
  // 당첨자 아이템 위젯
  // --------------------------------------------------
  Widget _buildWinnerItem(WinnerInfo winner, int index) {
    bool isLastItem = index == _winnerDataList.length - 1;

    return Column(
      children: [
        Container(
          height: 50,
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
          child: Row(
            children: [
              Expanded(
                flex: 4,
                child: Text(
                  winner.nickname,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Color(0xFF4A4A4A), letterSpacing: -0.3),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                flex: 6,
                child: Text(
                  '${winner.barnd} | ${winner.productName}',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: Color(0xFF969696), letterSpacing: -0.3),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.right,
                ),
              ),
            ],
          ),
        ),
        if (!isLastItem) Container(height: 1, margin: const EdgeInsets.symmetric(horizontal: 15), color: Color(0xFFEEEEEE)),
      ],
    );
  }
}
