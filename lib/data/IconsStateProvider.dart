import 'package:flutter/material.dart';

class IconStateProvider with ChangeNotifier {
  bool _showDrawer;
  bool _showSearch;

  IconStateProvider(){
    _showDrawer = true;
    _showSearch = true;
  }

  bool get showSearch => _showSearch;

  void setShowSearch(bool value) {
    _showSearch = value;
    notifyListeners();
  }

  bool get showDrawer => _showDrawer;

  void setShowDrawer(bool value) {
    _showDrawer = value;
    notifyListeners();
  }


}