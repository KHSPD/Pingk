import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pingk/common/constants.dart';
import 'package:pingk/common/my_datetime.dart';
import 'package:pingk/page_item_detail/item_general_detail.dart';
import 'package:pingk/page_sign_up/phone_number_auth.dart';
import 'package:pingk/page_sign_up/set_bio_auth.dart';
import 'package:pingk/page_sign_up/set_password.dart';
import 'package:pingk/page_sign_in/sign_in.dart';
import 'page_landing/landing.dart';
import 'page_main/main_shell.dart';
import 'page_main/body_home.dart';
import 'page_main/body_auction.dart';
import 'page_main/body_limited_deal.dart';
import 'page_item_detail/item_auction_detail.dart';
import 'common/_temp_items.dart';

// ====================================================================================================
// main
// ====================================================================================================
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  TempItems();

  runApp(const PingkApp());
}

// ====================================================================================================
// 앱 진입점
// ====================================================================================================
class PingkApp extends StatelessWidget {
  const PingkApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Pingk',
      scaffoldMessengerKey: snackbarKey,
      theme: ThemeData(
        fontFamily: 'Texts', // 앱 기본 폰트
      ),
      routerConfig: appRouter,
    );
  }
}

// ====================================================================================================
// Router
// ====================================================================================================
final GoRouter appRouter = GoRouter(
  initialLocation: '/landing',
  routes: [
    // ----- 랜딩 -----
    GoRoute(path: '/landing', name: 'landing', builder: (context, state) => const Landing()),

    // ----- 회원가입 -----
    GoRoute(path: '/phone_number_auth', name: 'phone_number_auth', builder: (context, state) => const PhoneNumberAuth()),
    GoRoute(path: '/set_password', name: 'set_password', builder: (context, state) => const SetPassword()),
    GoRoute(path: '/set_bio_auth', name: 'set_bio_auth', builder: (context, state) => const SetBioAuth()),

    // ----- 로그인 -----
    GoRoute(
      path: '/sign_in',
      name: 'sign_in',
      builder: (context, state) {
        final phoneNumber = state.extra as String?;
        return SignIn(phoneNumber: phoneNumber);
      },
    ),

    // ----- 메인 -----
    ShellRoute(
      builder: (context, state, child) => MainShell(child: child),
      routes: [
        GoRoute(path: '/main/home', name: 'main-home', builder: (context, state) => const BodyHome()),
        GoRoute(path: '/main/favorite', name: 'main-favorite', builder: (context, state) => const Center()),
        GoRoute(path: '/main/auction', name: 'main-auction', builder: (context, state) => const BodyAuction()),
        GoRoute(path: '/main/limited-deal', name: 'main-limited-deal', builder: (context, state) => const BodyLimitedDeal()),
      ],
    ),

    GoRoute(
      path: '/auction-detail/:itemId',
      name: 'auction-detail',
      builder: (context, state) {
        final itemId = state.pathParameters['itemId'] ?? '';
        return PageAuctionDetail(itemIdx: itemId);
      },
    ),
    GoRoute(
      path: '/deal-detail/:itemId',
      name: 'deal-detail',
      builder: (context, state) {
        final itemId = state.pathParameters['itemId'] ?? '';
        return PageGeneralDetail(itemId: itemId);
      },
    ),
  ],
);
