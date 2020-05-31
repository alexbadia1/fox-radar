import 'package:flutter/material.dart';

class PageViewMetaData with ChangeNotifier {
  int _formStepNum;
  PageController _pageViewController;

  PageViewMetaData(){
    _formStepNum = 1;
    _pageViewController = new PageController(initialPage: 0, keepPage: true);
  }//constructor

  int get formStepNum => _formStepNum;

  PageController get pageViewController => _pageViewController;

  void setFormStepNum(int value) {
    _formStepNum = value;
    notifyListeners();
  }//setFormStepNum
}//class