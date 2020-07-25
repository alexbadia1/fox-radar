import 'package:flutter/material.dart';

class HomePageViewModel extends ChangeNotifier {
  PageController _homePageViewController;
  HomePageViewModel() {
    _homePageViewController = new PageController(initialPage: 0, keepPage: true);
  }

  PageController get homePageViewController => _homePageViewController;
}

class CategoryContentModel extends ChangeNotifier {
  String _category;

  void setCategory(String newCategory){
    if (_category != newCategory) {
      _category = newCategory;
      notifyListeners();
    }
  }
  String getCategory ()=> _category;
}