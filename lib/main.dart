import 'package:flutter/material.dart';
import 'package:pingk/common/change_notifiers.dart';
import 'package:pingk/page_general/page_general_detail.dart';
import 'package:provider/provider.dart';
import 'page_landing/page_landing.dart';
import 'page_main/page_main.dart';
import 'page_auction/page_auction_detail.dart';
import 'common/_temp_items.dart';

void main() {
  // TempItems 초기화
  TempItems();
  runApp(ChangeNotifierProvider(create: (context) => MyChangeNotifier(), child: const PingkApp()));
}

class PingkApp extends StatelessWidget {
  const PingkApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pingk',
      initialRoute: '/',
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/':
            return MaterialPageRoute(builder: (context) => const PageLanding());
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
      },
    );
  }
}
