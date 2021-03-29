import 'package:intl/intl.dart';

class SearchResultModel {
  String _myTitle = '[Event Title]';
  String _myHost = '[Event Host]';
  String _myLocation = '[Event Location]';
  String _myCategory = '[Event Category]';
  String _eventId = '[Event Id]';
  bool _imageFitCover = true;
  String _myStartDate = '[Event Start Date]';
  String _myStartTime = '[Event Start Time]';

  SearchResultModel({
    String newHost,
    String newTitle,
    String newLocation,
    String newCategory,
    bool newImageFitCover,
    String newEventId,
    DateTime newRawStartDateAndTime,
  }) {
    _eventId = newEventId;
    _myHost = newHost;
    _myTitle = newTitle;
    _myLocation = newLocation;
    _imageFitCover = newImageFitCover;
    _myCategory = newCategory;
    newRawStartDateAndTime == null
        ? _myStartDate = ''
        : _myStartDate =
            DateFormat('E, MMMM d, y').format(newRawStartDateAndTime);
    newRawStartDateAndTime == null
        ? _myStartTime = ''
        : _myStartTime = DateFormat.jm().format(newRawStartDateAndTime);
  } //full constructor

  SearchResultModel.nullConstructor() {
    _eventId = '';
    _myHost = '';
    _myTitle = '';
    _myLocation = '';
    _imageFitCover = false;
  } ////null constructor

  bool get getImageFitCover => _imageFitCover;
  String get getHost => _myHost;
  String get getLocation => _myLocation;
  String get getTitle => _myTitle;
  String get eventId => _eventId;
  String get myCategory => _myCategory;
  String get myStartDate => _myStartDate;
  String get myStartTime => _myStartTime;

  @override
  String toString() {
    return "Title: $_myTitle\n"
        "Host: $_myHost\n"
        "Location: $_myLocation\n"
        "Category: $_myCategory\n"
        "fullEventId: $_eventId\n"
        "imageFitCover: $_imageFitCover";
  } // toString
} //class
