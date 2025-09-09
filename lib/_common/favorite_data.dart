import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter/foundation.dart';
import 'package:pingk/_common/api_service.dart';
import 'package:pingk/_common/item_info.dart';

class FavoriteData {
  static final FavoriteData _instance = FavoriteData._privateConstructor();
  factory FavoriteData() => _instance;
  FavoriteData._privateConstructor() {
    _initialize();
  }

  bool _isInitialized = false;
  late Box _box;
  final _key = 'favorites';
  List<AlwayslItem> list = [];

  // 외부 위젯들이 모니터링할 수 있는 상태 변수
  final ValueNotifier<int> monitorCountNotifier = ValueNotifier<int>(0);

  // ----- Hive 초기화 -----
  Future<void> _initialize() async {
    if (_isInitialized) return;
    try {
      await Hive.initFlutter();
      _box = await Hive.openBox(_key);
      _isInitialized = true;
      final data = _box.get(_key);
      if (data != null) {
        list = List<AlwayslItem>.from(data);
      } else {
        list = [];
      }
    } catch (e) {
      debugPrint('Hive 초기화 실패: $e');
    }
  }

  // ----- 찜 추가 -----
  Future<bool> add(AlwayslItem item) async {
    if (!_isInitialized) {
      await _initialize();
    }
    try {
      if (list.any((existingItem) => existingItem.id == item.id)) {
        return false;
      }
      item.isFavorite = true;
      list.add(item);
      await _box.put(_key, list);
      debugPrint('찜 추가: ${item.title}');
      return true;
    } catch (e) {
      debugPrint('찜 추가 실패: $e');
      return false;
    }
  }

  // ----- 찜 제거 -----
  Future<bool> remove(String itemId) async {
    if (!_isInitialized) {
      await _initialize();
    }
    try {
      final index = list.indexWhere((item) => item.id == itemId);
      if (index == -1) {
        return false;
      }
      list.removeAt(index);
      await _box.put(_key, list);
      monitorCountNotifier.value++;
      return true;
    } catch (e) {
      debugPrint('찜 제거 실패: $e');
      return false;
    }
  }

  // ----- 전체 비우기 -----
  Future<void> clear() async {
    if (!_isInitialized) {
      await _initialize();
    }
    try {
      list.clear();
      await _box.put(_key, list);
      monitorCountNotifier.value++;
    } catch (_) {
      return;
    }
  }

  // ----- 찜 여부 확인 -----
  bool isFavorite(String itemId) {
    return list.any((item) => item.id == itemId);
  }
}
