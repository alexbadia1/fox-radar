import 'package:flutter/material.dart';

class IconStateProvider with ChangeNotifier {
  bool _showDrawer;
  bool _showSearch;
  int _formStepNum;
  PageController _pageViewController;

  IconStateProvider(){
    _showDrawer = true;
    _showSearch = true;
    _formStepNum = 1;
    _pageViewController = new PageController(initialPage: 0, keepPage: true);
  }

  int get formStepNum => _formStepNum;

  void setFormStepNum(int value) {
    _formStepNum = value;
    notifyListeners();
  }

  bool get showSearch => _showSearch;

  void setShowSearch(bool value) {
    _showSearch = value;
    notifyListeners();
  }

  PageController get pageViewController => _pageViewController;

  void setPageViewController(PageController value) {
    _pageViewController = value;
    notifyListeners();
  }

  bool get showDrawer => _showDrawer;

  void setShowDrawer(bool value) {
    _showDrawer = value;
    notifyListeners();
  }


}