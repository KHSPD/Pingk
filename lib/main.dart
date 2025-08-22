import 'package:flutter/material.dart';
import 'package:pingk/common/change_notifiers.dart';
import 'package:pingk/common/constants.dart';
import 'package:pingk/page_general/page_general_detail.dart';
import 'package:pingk/page_join/page_join.dart';
import 'package:pingk/page_join/page_set_biometric.dart';
import 'package:pingk/page_join/page_set_password.dart';
import 'package:pingk/page_login/page_login.dart';
import 'package:provider/provider.dart';
import 'page_landing/page_landing.dart';
import 'page_main/page_main.dart';
import 'page_auction/page_auction_detail.dart';
import 'common/_temp_items.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // ----- 임시 데이터 처리 -----
  TempItems();
  //
  runApp(ChangeNotifierProvider(create: (context) => MyChangeNotifier(), child: const PingkApp()));
}

class PingkApp extends StatelessWidget {
  const PingkApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pingk',
      initialRoute: '/',
      scaffoldMessengerKey: snackbarKey,
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/':
            return MaterialPageRoute(builder: (context) => const PageLanding());
          case '/login':
            return MaterialPageRoute(builder: (context) => const PageLogin());
          case '/join':
            return MaterialPageRoute(builder: (context) => const PageJoin());
          case '/set-password':
            return MaterialPageRoute(builder: (context) => const PageSetPassword());
          case '/set-biometric':
            return MaterialPageRoute(builder: (context) => const PageSetBiometric());
          case '/main':
            return MaterialPageRoute(builder: (context) => const PageMain());
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
            return MaterialPageRoute(builder: (context) => const PageLanding());
        }
        return null;
      },
    );
  }
}
