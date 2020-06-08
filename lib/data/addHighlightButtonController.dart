import 'package:flutter/material.dart';

class AddHighlightButtonController extends ChangeNotifier {
  bool _addHighlightButtonEnabled;

  AddHighlightButtonController() {
   _addHighlightButtonEnabled = true;
  }

  bool getAddHighlightButtonEnabled () => _addHighlightButtonEnabled;

  void setAddHighlightButtonEnabled (bool newAddHighlightButtonEnabled) {
    _addHighlightButtonEnabled = newAddHighlightButtonEnabled;
  }
}