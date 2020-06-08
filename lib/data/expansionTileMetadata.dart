import 'package:flutter/material.dart';

class ExpansionTiles extends ChangeNotifier {
  bool _showAddStartTimeCalenderStrip;
  bool _showAddEndTimeCalenderStrip;
  DateTime originalStartDateAndTime;
  DateTime _tempStartTime;
  DateTime _tempEndTime;
  DateTime _tempStartDate;
  DateTime _tempEndDate;
  List<ExpansionTileData> data = [
    ExpansionTileData(newHeaderActionValue: 'Start', newIsExpanded: false),
    ExpansionTileData(newHeaderActionValue: 'Add End Time', newIsExpanded: false),
  ];

  ExpansionTiles(){
    _showAddStartTimeCalenderStrip = true;
    _showAddEndTimeCalenderStrip = true;
  }

  bool getShowAddStartTimeCalenderStrip () => _showAddStartTimeCalenderStrip;
  bool getShowAddEndTimeCalenderStrip () => _showAddEndTimeCalenderStrip;
  DateTime getTempEndTime () => _tempEndTime;
  DateTime getTempStartDate () => _tempStartDate;
  DateTime getTempEndDate () => _tempEndDate;
  DateTime getTempStartTime () => _tempStartTime;

  void setShowAddStartTimeCalenderStrip (bool newShowAddStartTimeCalenderStrip) {
    _showAddStartTimeCalenderStrip = newShowAddStartTimeCalenderStrip;
    notifyListeners();
  }

  void setShowAddEndTimeCalenderStrip (bool newShowAddEndTimeCalenderStrip) {
    _showAddEndTimeCalenderStrip = newShowAddEndTimeCalenderStrip;
    notifyListeners();
  }

  void setTempStartTime (DateTime newTempStartTime) {
    _tempStartTime = newTempStartTime;

  }
  void setTempEndTime (DateTime newTempEndTime) {
    _tempEndTime = newTempEndTime;
  }
  void setTempStartDate (DateTime newTempStartDate) {
    _tempStartDate = newTempStartDate;

  }
  void setTempEndDate (DateTime newTempEndDate) {
    _tempEndDate = newTempEndDate;
  }

  void updateExpansionPanels() {
    notifyListeners();
  }
}






class ExpansionTileData {
  DateTime _myHeaderDateValue;
  DateTime _myHeaderTimeValue;
  String _myHeaderActionValue;
  bool _myIsExpanded;

  ExpansionTileData({DateTime newHeaderTimeValue, DateTime newHeaderDateValue, String newHeaderActionValue,  bool newIsExpanded}){
    _myHeaderTimeValue = newHeaderTimeValue;
    _myHeaderDateValue = newHeaderDateValue;
    _myIsExpanded = newIsExpanded;
    _myHeaderActionValue = newHeaderActionValue;
  }

  DateTime getHeaderDateValue () => _myHeaderDateValue;
  DateTime getHeaderTimeValue () => _myHeaderTimeValue;
  String getHeaderActionValue () => _myHeaderActionValue;
  bool getIsExpanded ()=> _myIsExpanded;

  void setIsExpanded (bool newIsExpanded) {
    _myIsExpanded = newIsExpanded;
  }
  void setHeaderDateValue (DateTime newHeaderDateValue) {
    _myHeaderDateValue = newHeaderDateValue;
  }
  void setHeaderTimeValue (DateTime newHeaderTimeValue) {
    _myHeaderTimeValue = newHeaderTimeValue;
  }
  void setHeaderActionValue (String newHeaderActionValue) {
    _myHeaderActionValue = newHeaderActionValue;
  }
}