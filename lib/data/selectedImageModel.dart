import 'dart:typed_data';
import 'package:flutter/material.dart';

class SelectedImageModel extends ChangeNotifier {
  Uint8List _myImageBytes;
  String _relativePath;
  bool _cover;
  SelectedImageModel({Uint8List newImageBytes, String newRelativePath}){
    _myImageBytes = newImageBytes;
    _relativePath = newRelativePath;
    _cover = false;
  }

  Uint8List getImageBytes ()=> _myImageBytes;
  String getRelativePath ()=> _relativePath;
  bool getCover ()=> _cover;

  void setImageBytes ({Uint8List newImageBytes, String newRelativePath = ''}) {
    _myImageBytes = newImageBytes;
    _relativePath = newRelativePath;
    notifyListeners();
  }

  void setCover (bool newCover) {
    _cover = newCover;
    notifyListeners();
  }
}