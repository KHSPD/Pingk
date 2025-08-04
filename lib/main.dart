import 'package:flutter/material.dart';
import 'landing_page/landing_page.dart';

void main() {
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
        '/': (context) => const LandingPage(),
        //'/login': (context) => const LoginPage(),
        //'/home': (context) => const HomePage(),
        //'/auction': (context) => const AuctionPage(),
        //'/hotdeal': (context) => const HotdealPage(),
        //'/discount': (context) => const DiscountPage(),
      },
    );
  }
} 