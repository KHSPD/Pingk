import 'package:flutter/material.dart';

// ----- SnackBar 키 -----
final GlobalKey<ScaffoldMessengerState> snackbarKey = GlobalKey<ScaffoldMessengerState>();

// ----- 메인 메뉴 -----
enum MainMenu { home, favorite, pingkAuction, limitedDeal }

// ----- 바이오인증 상태 -----
const String statusEnabled = 'enabled';
const String statusDisabled = 'disabled';
const String statusNotSet = 'notSet';
