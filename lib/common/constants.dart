import 'package:flutter/material.dart';

const String appServerURL = "http://gkpin.iptime.org:18080";
const int apiTimeout = 20;
const String messageNetworkError = '네트워크 오류가 발생했습니다.\n잠시 후 다시 시도해주세요.';

// ----- SnackBar 키 -----
final GlobalKey<ScaffoldMessengerState> snackbarKey = GlobalKey<ScaffoldMessengerState>();

// ----- 메인 메뉴 -----
enum MainMenu { home, favorite, pingkAuction, limitedDeal }

const String tempAccessToken = '6546846846543546846sa84df6as84fd6a8s4fd6as54fd68as4df68as46fd8';
const String tempRefreshToken = '8as84fa3s2f1a3s25f1as68f1a3sddf1as3d2f1asd6df84asdf3as51fa3s2f1';
