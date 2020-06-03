import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class ClubEventData {
  String _myHost;
  String _myTitle;
  String _myDate;
  String _myStartTime;
  String _myEndTime;
  String _myLocation;
  String _myRoom;
  String _mySummary;
  String _myCategory;
  List<String> _myHighlights;
  String _image;

  ClubEventData({String newHost, String newTitle, Timestamp newDate, String newStartTime, String newEndTime, String newLocation, String newRoom,
    String newSummary, List<String> newHighlights, String newImage, String newCategory}) {
    DateFormat _formatter = new DateFormat('EEEE, MMMM d, y');
    _myHost = newHost;
    _myTitle = newTitle;
    _myDate = _formatter.format(DateTime.fromMillisecondsSinceEpoch(newDate.millisecondsSinceEpoch).toUtc().toLocal());
    _myStartTime = newStartTime;
    _myEndTime = newEndTime;
    _myLocation = newLocation;
    _myRoom = newRoom;
    _mySummary = newSummary;
    _myHighlights = newHighlights;
    _image = newImage;
    _myCategory = newCategory;
  }//full constructor

  ClubEventData.nullConstructor() {
    _myHost = '[Host Name]';
    _myTitle = '';
    _myLocation = '';
    _myDate =  DateFormat.yMMMMEEEEd().format(DateTime.now());
    _myStartTime = DateFormat.jm().format(DateTime.now());
    _myEndTime = DateFormat.jm().format(DateTime.now());
    _myRoom = '';
    _mySummary = 'Tonight we are celebrating Chinese New Year by painting lanterns! '
        + 'There wil be a quick presentation and then music and latern art... '
        + 'Come join, chill, relax and have fun!';
    _myHighlights = ['Music', 'Guest Speaker', 'Priority Points', 'Candy', "Laterns"];
    _image = 'images/AsianAllianceLanterns.jpg';
  }////null constructor

  String get getImage => _image;
  String get getHost => _myHost;
  String get getSummary => _mySummary;
  String get getRoom => _myRoom;
  String get getLocation => _myLocation;
  String get getEndTime => _myEndTime;
  String get getStartTime => _myStartTime;
  String get getDate => _myDate;
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

  void setDate(String value) {
    _myDate = value;
  }

  void setTitle(String value) {
    _myTitle = value;
  }

  void setHost(String value) {
    _myHost = value;
  }

}//class