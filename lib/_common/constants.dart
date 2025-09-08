import 'package:flutter/material.dart';

const String apiServerURL = "http://gkpin.iptime.org:18080";
const String imageServerURL = "http://gkpin.iptime.org:18081";
const int apiTimeout = 20;

// ----- SnackBar 키 -----
final GlobalKey<ScaffoldMessengerState> snackbarKey = GlobalKey<ScaffoldMessengerState>();

// ----- 메세지 -----
const String messageError = '오류가 발생했습니다.\n잠시 후 다시 시도해주세요.';
