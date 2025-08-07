import 'package:flutter/material.dart';
import 'page_landing/page_landing.dart';
import 'page_main/page_main.dart';
import 'common/_temp_items.dart';

void main() {
  // TempItems 초기화
  TempItems();
  runApp(const PingkApp());
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
        '/home': (context) => const PageMain(),
        //'/login': (context) => const LoginPage(),
        //'/home': (context) => const HomePage(),
        //'/auction': (context) => const AuctionPage(),
        //'/hotdeal': (context) => const HotdealPage(),
        //'/discount': (context) => const DiscountPage(),
      },
    );
  }
}
