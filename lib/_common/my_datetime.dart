import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:pingk/_common/api_service.dart';
import 'package:pingk/_common/constants.dart';

class MyDateTime {
  static final MyDateTime _instance = MyDateTime._internal();
  factory MyDateTime() => _instance;
  MyDateTime._internal();

  DateTime? _serverTime;
  DateTime? _lastSyncTime;
  Timer? _syncTimer;

  // --------------------------------------------------
  // 서버 시간 동기화 시작
  // --------------------------------------------------
  Future<void> startSync() async {
    await _fetchServerTime();
    // ----- 30분마다 동기화 타이머 -----
    _syncTimer?.cancel();
    _syncTimer = Timer.periodic(Duration(minutes: 30), (timer) async {
      await _fetchServerTime();
    });
  }

  // --------------------------------------------------
  // 서버 시간 동기화
  // --------------------------------------------------
  Future<void> _fetchServerTime() async {
    try {
      final response = await ApiService().publicDio.get('/api/auth/server-time');
      debugPrint('========== API Response ==========\nURL: ${response.requestOptions.uri}\nStatus: ${response.statusCode}\nBody: ${response.data}');
      if (response.statusCode == 200) {
        final Map<String, dynamic> body = response.data;
        if (body['code'] == '200') {
          final serverTimeString = body['result'];
          if (serverTimeString != null) {
            _serverTime = DateTime.parse(serverTimeString);
            _lastSyncTime = DateTime.now();
            debugPrint('서버 시간 동기화 성공');
            return;
          }
        }
      }
      debugPrint('서버 시간 동기화 실패');
    } catch (e) {
      debugPrint('서버 시간 동기화 실패: $e');
    }
  }

  // --------------------------------------------------
  // 현재 시간 리턴
  // --------------------------------------------------
  DateTime getDateTime() {
    if (_serverTime == null) {
      return DateTime.now();
    }
    if (_lastSyncTime == null) {
      return _serverTime!;
    }

    // ----- 마지막 동기화 시간으로부터 경과된 시간 추정 -----
    final elapsed = DateTime.now().difference(_lastSyncTime!);
    return _serverTime!.add(elapsed);
  }

  // --------------------------------------------------
  // 서버 시간 동기화 중지
  // --------------------------------------------------
  void stopSync() {
    _syncTimer?.cancel();
    _syncTimer = null;
  }

  // --------------------------------------------------
  // 디버깅용: 현재 상태 정보 반환
  // --------------------------------------------------
  /*
  DateTime? get lastSyncTime => _lastSyncTime;
  bool get isSynced => _serverTime != null;
  Map<String, dynamic> getDebugInfo() {
    return {
      'serverTime': _serverTime?.toIso8601String(),
      'lastSyncTime': _lastSyncTime?.toIso8601String(),
      'currentEstimatedTime': getDateTime().toIso8601String(),
      'isSynced': isSynced,
      'hasTimer': _syncTimer != null,
    };
  }
  */
}
