import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pingk/_common/constants.dart';
import 'package:pingk/main_page/body_always.dart';
import 'package:pingk/detail_page/detail_always.dart';
import 'package:pingk/detail_page/detail_limited.dart';
import 'package:pingk/sign_up_page/phone_number_auth.dart';
import 'package:pingk/sign_up_page/set_bio_auth.dart';
import 'package:pingk/sign_up_page/set_password.dart';
import 'package:pingk/sign_in_page/sign_in.dart';
import 'landing_page/landing.dart';
import 'main_page/main_shell.dart';
import 'main_page/body_home.dart';
import 'main_page/body_auction.dart';
import 'main_page/body_limited.dart';
import 'detail_page/detail_auction.dart';

// ====================================================================================================
// main
// ====================================================================================================
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
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
        GoRoute(path: '/main/auction', name: 'main-auction', builder: (context, state) => const BodyAuction()),
        GoRoute(path: '/main/limited', name: 'main-limited', builder: (context, state) => const BodyLimited()),
        GoRoute(path: '/main/always', name: 'main-always', builder: (context, state) => const Always()),
      ],
    ),

    // ----- 옥션 상품 상세 -----
    GoRoute(
      path: '/detail-auction/:itemId',
      name: 'detail-auction',
      builder: (context, state) {
        final itemId = state.pathParameters['itemId'] ?? '';
        return DetailAuction(itemIdx: itemId);
      },
    ),

    // ----- 한정특가 상품 상세 -----
    GoRoute(
      path: '/detail-limited/:itemId',
      name: 'detail-limited',
      builder: (context, state) {
        final itemId = state.pathParameters['itemId'] ?? '';
        return DetailLimited(itemId: itemId);
      },
    ),

    // ----- 일반 상품 상세 -----
    GoRoute(
      path: '/detail-always/:itemId',
      name: 'detail-always',
      builder: (context, state) {
        final itemId = state.pathParameters['itemId'] ?? '';
        return DetailAlways(itemId: itemId);
      },
    ),
  ],
);
