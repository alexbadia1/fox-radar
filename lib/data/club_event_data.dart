import 'package:flutter/material.dart';

class ClubEventData extends ChangeNotifier {
  String _myTitle;
  String _myHost;
  String _myLocation;
  String _myRoom;
  String _myStartDate;
  String _myStartTime;
  String _myEndDate;
  String _myEndTime;
  String _myCategory;
  List<String> _myHighlights;
  String _mySummary;
  String _image;

  ClubEventData({String newHost, String newTitle, String newStartDate, String newStartTime, String newEndDate, String newEndTime, String newLocation, String newRoom,
    String newSummary, List<String> newHighlights, String newImage, String newCategory}) {
    _myHost = newHost;
    _myTitle = newTitle;
    _myStartDate = newStartDate;
    _myStartTime = newStartTime;
    _myEndDate = newEndDate;
    _myEndTime = newEndTime;
    _myLocation = newLocation;
    _myRoom = newRoom;
    _mySummary = newSummary;
    _myHighlights = newHighlights;
    _image = newImage;
    _myCategory = newCategory;
  }//full constructor

  ClubEventData.nullConstructor() {
    _myHost = '';
    _myTitle = '';
    _myLocation = '';
    _myStartDate =  '';
    _myEndDate = '';
    _myStartTime = '';
    _myEndTime = '';
    _myRoom = '';
    _mySummary = '';
    _myHighlights = [];
    _image = 'images/AsianAllianceLanterns.jpg';
  }////null constructor

  String get getImage => _image;
  String get getHost => _myHost;
  String get getSummary => _mySummary;
  String get getRoom => _myRoom;
  String get getLocation => _myLocation;
  String get getEndDate => _myEndDate;
  String get getEndTime => _myEndTime;
  String get getStartDate => _myStartDate;
  String get getStartTime => _myStartTime;
  String get getTitle => _myTitle;
  List<String> get getHighlights => _myHighlights;
  String get myCategory => _myCategory;

  void setImage(String value) {
    _image = value;
  }

  void setHighlights(List<String> value) {
    _myHighlights = value;
  }

  void setSummary(String value) {
    _mySummary = value;
  }

  void setRoom(String value) {
    _myRoom = value;
  }

  void setLocation(String value) {
    _myLocation = value;
  }

  void setEndTime(String value) {
    _myEndTime = value;
  }

  void setStartTime(String value) {
    _myStartTime = value;
  }

  void setStartDate(String value) {
    _myStartDate = value;
  }

  void setEndDate(String value) {
    _myEndDate = value;
  }

  void setTitle(String value) {
    _myTitle = value;
  }

  void setHost(String value) {
    _myHost = value;
  }

  void setCategory (String newCategory) {
    _myCategory = newCategory;
  }

  void applyChanges () {
    notifyListeners();
  }

  @override
  String toString() {
    return "Title: $_myTitle\n"
        "Host: $_myHost\n"
        "Location: $_myLocation\n"
        "Room: $_myRoom\n"
        "Start: $_myStartDate $_myStartTime\n"
        "End: $_myEndDate $_myEndTime\n"
        "Category: $_myCategory\n"
        "Highlights: $_myHighlights\n"
        "Summary: $_mySummary";
  }
}//class