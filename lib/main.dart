import 'package:flutter/material.dart';
import 'package:pingk/common/constants.dart';
import 'package:pingk/page_item_detail/item_general_detail.dart';
import 'package:pingk/page_sign_up/sign_up.dart';
import 'package:pingk/page_sign_in/sign_in.dart';
import 'page_landing/landing.dart';
import 'page_main/main_page.dart';
import 'page_item_detail/item_auction_detail.dart';
import 'common/_temp_items.dart';

// ====================================================================================================
// 앱 진입점
// ====================================================================================================
class PingkApp extends StatelessWidget {
  const PingkApp({super.key});

  @override
  Widget build(BuildContext context) {
    FocusScope.of(context).unfocus();
    return MaterialApp(
      title: 'Pingk',
      initialRoute: '/landing',
      scaffoldMessengerKey: snackbarKey,
      theme: ThemeData(
        // 앱 기본 폰트 설정
        fontFamily: 'Pretendard',
      ),
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/landing':
            return MaterialPageRoute(builder: (context) => const Landing());
          case '/sign_in':
            final phoneNumber = settings.arguments as String?;
            return MaterialPageRoute(builder: (context) => SignIn(phoneNumber: phoneNumber));
          case '/sign_up':
            return MaterialPageRoute(builder: (context) => const SignUp());
          case '/main':
            return MaterialPageRoute(builder: (context) => const Main());
          case '/auction-detail':
            final itemId = settings.arguments as String? ?? '';
            if (itemId.isNotEmpty) {
              return MaterialPageRoute(builder: (context) => PageAuctionDetail(itemId: itemId));
            }
          case '/deal-detail':
            final itemId = settings.arguments as String? ?? '';
            if (itemId.isNotEmpty) {
              return MaterialPageRoute(builder: (context) => PageGeneralDetail(itemId: itemId));
            }
          default:
            return MaterialPageRoute(builder: (context) => const Landing());
        }
        return null;
      },
    );
  }
}

// ====================================================================================================
// 메인 함수
// ====================================================================================================
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // ----- 임시 데이터 처리 -----
  TempItems();
  //
  runApp(const PingkApp());
}
