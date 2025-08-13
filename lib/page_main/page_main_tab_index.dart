import 'package:flutter/widgets.dart';

class AppChangeNotifier with ChangeNotifier {
  int _selectedMainPageIdx = 0;

  int get selectedMainPageIdx => _selectedMainPageIdx;

  void changeMainPageIdx(int pageIndex) {
    if (_selectedMainPageIdx != pageIndex) {
      _selectedMainPageIdx = pageIndex;
      notifyListeners();
    }
  }
}
