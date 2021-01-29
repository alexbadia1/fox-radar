import 'package:intl/intl.dart';
import 'package:flutter/material.dart';

class EventModel extends ChangeNotifier {
  String _id;
  DateTime _rawStartDateAndTime;
  DateTime _rawEndDateAndTime;
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
  String _imagePath;
  bool _imageFitCover;

  EventModel(
      {String newHost,
        String newTitle,
        String newLocation,
        String newRoom,
        String newSummary,
        List<String> newHighlights,
        String newImagePath,
        String newCategory,
        DateTime newRawStartDateAndTime,
        DateTime newRawEndDateAndTime,
        bool newImageFitCover,
      String newId}) {

    _id = newId;
    _myHost = newHost;
    _myTitle = newTitle;
    newRawStartDateAndTime == null ? _myStartDate = '' : _myStartDate = DateFormat('E, MMMM d, y').format(newRawStartDateAndTime);
    newRawStartDateAndTime == null ? _myStartTime = '' : _myStartTime = DateFormat.jm().format(newRawStartDateAndTime);
    newRawEndDateAndTime == null ? _myEndDate = '' : _myEndDate = DateFormat('E, MMMM d, y').format(newRawEndDateAndTime);
    newRawEndDateAndTime == null ? _myEndTime = '' : _myEndTime = DateFormat.jm().format(newRawEndDateAndTime);
    _myLocation = newLocation;
    _myRoom = newRoom;
    _mySummary = newSummary;
    _myHighlights = newHighlights;
    _imagePath = newImagePath;
    _imageFitCover = newImageFitCover;
    _myCategory = newCategory;
    _rawStartDateAndTime = newRawStartDateAndTime;
    _rawEndDateAndTime = newRawEndDateAndTime;
    _imageFitCover = false;
  } //full constructor

  EventModel.nullConstructor() {
    _id = '';
    _myHost = '';
    _myTitle = '';
    _myLocation = '';
    _myStartDate = '';
    _myEndDate = '';
    _myStartTime = '';
    _myEndTime = '';
    _myRoom = '';
    _mySummary = '';
    _myHighlights = [];
    _imageFitCover = false;
    _imagePath = '';
  } ////null constructor

  bool get getImageFitCover => _imageFitCover;
  String get getImagePath => _imagePath;
  String get getHost => _myHost;
  String get getSummary => _mySummary;
  String get getRoom => _myRoom;
  String get getLocation => _myLocation;
  String get getEndDate => _myEndDate;
  String get getEndTime => _myEndTime;
  String get getStartDate => _myStartDate;
  String get getStartTime => _myStartTime;
  String get getTitle => _myTitle;
  String get id => _id;
  List<String> get getHighlights => _myHighlights;
  String get myCategory => _myCategory;
  DateTime get getRawStartDateAndTime => _rawStartDateAndTime;
  DateTime get getRawEndDateAndTime => _rawEndDateAndTime;

  void setImageFitCover (bool newImageFitCover) {
    _imageFitCover = newImageFitCover;
  }

  void setRawStartDateAndTime(DateTime value) {
    _rawStartDateAndTime = value;
  }

  void setRawEndDateAndTime(DateTime value) {
    _rawEndDateAndTime = value;
  }

  void setImagePath(String value) {
    _imagePath = value;
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

  void setTitle(String value) {
    _myTitle = value;
  }

  void setHost(String value) {
    _myHost = value;
  }

  void setCategory(String newCategory) {
    _myCategory = newCategory;
  }

  void applyChanges() {
    notifyListeners();
  }

  @override
  String toString() {
    return "Title: $_myTitle\n"
        "Host: $_myHost\n"
        "Location: $_myLocation\n"
        "Room: $_myRoom\n"
        "Start: $_rawStartDateAndTime\n"
        "End: $_rawEndDateAndTime\n"
        "Category: $_myCategory\n"
        "Highlights: $_myHighlights\n"
        "Summary: $_mySummary";
  }

} //class


class ArtsEventsData extends EventModel {}
class SportsEventsData extends EventModel {}
class DiversityEventsData extends EventModel {}
class StudentEventsData extends EventModel {}
class FoodEventsData extends EventModel {}
class GreekEventsData extends EventModel {}
class SuggestedEventsData extends EventModel {}