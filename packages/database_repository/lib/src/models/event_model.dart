import 'dart:typed_data';

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
  Uint8List _imageBytes;
  bool _imageFitCover;
  String _imagePath;

  EventModel(
      {String newHost,
        String newTitle,
        String newLocation,
        String newRoom,
        String newSummary,
        List<String> newHighlights,
        Uint8List newImageBytes,
        String newCategory,
        DateTime newRawStartDateAndTime,
        DateTime newRawEndDateAndTime,
        bool newImageFitCover,
      String newId,
      String newImagePath}) {

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
    _imageBytes = newImageBytes;
    _imageFitCover = newImageFitCover;
    _myCategory = newCategory;
    _rawStartDateAndTime = newRawStartDateAndTime;
    _rawEndDateAndTime = newRawEndDateAndTime;
    _imagePath = newImagePath;
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
    _myCategory = '';
    _mySummary = '';
    _myHighlights = [];
    _imageFitCover = false;
    _imageBytes = null;
    _rawStartDateAndTime = DateTime.now();
    _rawEndDateAndTime = null;
    _imagePath = '';
  } ////null constructor

  /// Name: copyWith
  ///
  /// Description: copies all of the objects attributes
  ///              into a new instance of the object, allowing
  ///              specified attributes to be changed while copying.
  ///
  /// Design Notes: Null values are used to indicate to copy
  ///               previous attributes to the new object instance
  ///
  ///               Pass in empty strings to end date and end time, to set
  ///               rawEndDateAndTime to null.
  copyWith({
    String id,
    DateTime rawStartDateAndTime,
    DateTime rawEndDateAndTime,
    String title,
    String host,
    String location,
    String room,
    String startDate,
    String startTime,
    String endDate,
    String endTime,
    String category,
    List<String> highlights,
    String summary,
    Uint8List imageBytes,
    bool imageFitCover,
    String imagePath,
   }) {


    // Use previous rawEndDateAndTime
    if (rawEndDateAndTime == null) {
      rawEndDateAndTime = this._rawEndDateAndTime;
    }// if

    // If the endDate and endTime are set to empty string
    // Override the rawEndDateAndTime to 'null'
    if (endDate == '' && endTime == '') {
      rawEndDateAndTime = null;
    }// if

    return EventModel(
      newId: id ?? this._id,
      newRawStartDateAndTime: rawStartDateAndTime ?? this._rawStartDateAndTime,
      newRawEndDateAndTime: rawEndDateAndTime,
      newTitle: title ?? this._myTitle,
      newHost: host ?? this._myHost,
      newLocation: location ?? this._myLocation,
      newCategory: category ?? this._myCategory,
      newHighlights: highlights ?? this._myHighlights,
      newImageFitCover: imageFitCover ?? this._imageFitCover,
      newImageBytes: imageBytes ?? this._imageBytes,
      newRoom: room ?? this._myRoom,
      newSummary: summary ?? this._mySummary,
      newImagePath: imagePath ?? this._imagePath,
    );
  }// copyWith

  bool get getImageFitCover => _imageFitCover;
  Uint8List get getImageBytes => _imageBytes;
  String get getHost => _myHost;
  String get getSummary => _mySummary;
  String get getRoom => _myRoom;
  String get getLocation => _myLocation;
  String get getEndDate => _myEndDate;
  String get getEndTime => _myEndTime;
  String get getStartDate => _myStartDate;
  String get getStartTime => _myStartTime;
  String get getTitle => _myTitle;
  String get getImagePath => _imagePath;
  String get id => _id;
  List<String> get getHighlights => _myHighlights;
  String get myCategory => _myCategory;
  DateTime get getRawStartDateAndTime => _rawStartDateAndTime;
  DateTime get getRawEndDateAndTime => _rawEndDateAndTime;

  void setId (String newId) {
    _id = newId;
  }

  void setImageFitCover (bool newImageFitCover) {
    _imageFitCover = newImageFitCover;
  }

  void setRawStartDateAndTime(DateTime value) {
    _rawStartDateAndTime = value;
  }

  void setRawEndDateAndTime(DateTime value) {
    _rawEndDateAndTime = value;
  }

  void setImageBytes(Uint8List value) {
    _imageBytes = value;
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
    return "Id: $_id"
        "\nTitle: $_myTitle"
        "\nHost: $_myHost"
        "\nLocation: $_myLocation"
        "\nRoom: $_myRoom"
        "\nStart: $_rawStartDateAndTime"
        "\nEnd: $_rawEndDateAndTime"
        "\nCategory: $_myCategory"
        "\nHighlights: $_myHighlights"
        "\nSummary: $_mySummary"
        "\nImage Path: $_imagePath"
        "\nImage Bytes $_imageBytes";
  }// toString

} //class