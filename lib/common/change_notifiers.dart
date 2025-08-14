import 'package:flutter/widgets.dart';
import 'package:pingk/common/constants.dart';

class MyChangeNotifier with ChangeNotifier {
  MainMenu _selectedMainMenu = MainMenu.home;

  MainMenu get selectedMainMenu => _selectedMainMenu;

  void setMainMenu(MainMenu menu) {
    if (_selectedMainMenu != menu) {
      _selectedMainMenu = menu;
      notifyListeners();
    }
  }
}
