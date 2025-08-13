import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pingk/common/my_colors.dart';
import 'package:pingk/common/my_text.dart';

// ====================================================================================================
// 홈 - 낙찰자 목록
// ====================================================================================================
class HomeWinnersList extends StatefulWidget {
  const HomeWinnersList({super.key});

  @override
  State<HomeWinnersList> createState() => _HomeWinnersListState();
}

class _HomeWinnersListState extends State<HomeWinnersList> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(30, 50, 30, 0),
      child: Column(
        children: [
          Container(
            height: 50,
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
            decoration: BoxDecoration(color: MyColors.background3, borderRadius: BorderRadius.circular(10)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                MyText(
                  '낙찰을 축하합니다!',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400, color: MyColors.text1),
                ),
                MyText(
                  '실시간 당첨자',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w200, color: MyColors.text2),
                ),
              ],
            ),
          ),

          Container(
            height: 50,
            margin: const EdgeInsets.fromLTRB(0, 10, 0, 0),
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
            child: Row(
              children: [
                SvgPicture.asset('assets/icons/icon_medal.svg', width: 14, height: 19, colorFilter: ColorFilter.mode(MyColors.icon1, BlendMode.srcIn)),
                const SizedBox(width: 10),
                Expanded(
                  flex: 4,
                  child: MyText(
                    '달콤한 수박',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w300, color: MyColors.text1),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  flex: 6,
                  child: MyText(
                    '메가커피 | 아이스아메리카노',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w200, color: MyColors.text2),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.right,
                  ),
                ),
              ],
            ),
          ),

          Container(
            height: 50,
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
            child: Row(
              children: [
                SvgPicture.asset('assets/icons/icon_medal.svg', width: 14, height: 19, colorFilter: ColorFilter.mode(MyColors.icon1, BlendMode.srcIn)),
                const SizedBox(width: 10),
                Expanded(
                  flex: 4,
                  child: MyText(
                    '불타는 고구마',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w300, color: MyColors.text1),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  flex: 6,
                  child: MyText(
                    '공차 | 얼그레이 밀크티',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w200, color: MyColors.text2),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.right,
                  ),
                ),
              ],
            ),
          ),

          Container(
            height: 50,
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
            child: Row(
              children: [
                SvgPicture.asset('assets/icons/icon_medal.svg', width: 14, height: 19, colorFilter: ColorFilter.mode(MyColors.icon1, BlendMode.srcIn)),
                const SizedBox(width: 10),
                Expanded(
                  flex: 4,
                  child: MyText(
                    '느린 바다거북',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w300, color: MyColors.text1),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  flex: 6,
                  child: MyText(
                    '파파존스 | 불고기 피자',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w200, color: MyColors.text2),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.right,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
