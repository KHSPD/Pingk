import 'package:flutter/material.dart';
import 'package:pingk/page_main/page_main_tab_index.dart';
import 'package:provider/provider.dart';
import 'page_landing/page_landing.dart';
import 'page_main/page_main.dart';
import 'common/_temp_items.dart';

void main() {
  // TempItems 초기화
  TempItems();
  runApp(ChangeNotifierProvider(create: (context) => MainTabIdx(), child: const PingkApp()));
}

class PingkApp extends StatelessWidget {
  const PingkApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pingk',
      initialRoute: '/',
      routes: {
        '/': (context) => const PageLanding(),
        '/main': (context) => const PageMain(),
        //'/login': (context) => const LoginPage(),
        //'/home': (context) => const HomePage(),
        //'/auction': (context) => const AuctionPage(),
        //'/hotdeal': (context) => const HotdealPage(),
        //'/discount': (context) => const DiscountPage(),
      },
    );
  }
}
