import 'package:flutter/material.dart';

class ExpansionTiles extends ChangeNotifier {
  bool _showAddStartTimeCalenderStrip;
  bool _showAddEndTimeCalenderStrip;
  String _tempStartTime;
  String _tempEndTime;
  String _tempStartDate;
  String _tempEndDate;
  List<ExpansionTileData> data = [
    ExpansionTileData(newHeaderDateValue: '', newHeaderTimeValue: '', newHeaderActionValue: 'Start', newIsExpanded: false),
    ExpansionTileData(newHeaderDateValue: '', newHeaderTimeValue: '', newHeaderActionValue: 'Add End Time', newIsExpanded: false),
  ];

  ExpansionTiles(){
    _showAddStartTimeCalenderStrip = true;
    _showAddEndTimeCalenderStrip = true;
    _tempStartDate = '';
    _tempEndDate = '';
    _tempStartTime = '';
    _tempEndTime = '';
  }

  bool getShowAddStartTimeCalenderStrip () => _showAddStartTimeCalenderStrip;
  bool getShowAddEndTimeCalenderStrip () => _showAddEndTimeCalenderStrip;
  String getTempEndTime () => _tempEndTime;
  String getTempStartDate () => _tempStartDate;
  String getTempEndDate () => _tempEndDate;
  String getTempStartTime () => _tempStartTime;

  void setShowAddStartTimeCalenderStrip (bool newShowAddStartTimeCalenderStrip) {
    _showAddStartTimeCalenderStrip = newShowAddStartTimeCalenderStrip;
    notifyListeners();
  }

  void setShowAddEndTimeCalenderStrip (bool newShowAddEndTimeCalenderStrip) {
    _showAddEndTimeCalenderStrip = newShowAddEndTimeCalenderStrip;
    notifyListeners();
  }

  void setTempStartTime (String newTempStartTime) {
    _tempStartTime = newTempStartTime;

  }
  void setTempEndTime (String newTempEndTime) {
    _tempEndTime = newTempEndTime;
  }
  void setTempStartDate (String newTempStartDate) {
    _tempStartDate = newTempStartDate;

  }
  void setTempEndDate (String newTempEndDate) {
    _tempEndDate = newTempEndDate;
  }

  void updateExpansionPanels() {
    notifyListeners();
  }
}






class ExpansionTileData {
  String _myHeaderDateValue;
  String _myHeaderTimeValue;
  String _myHeaderActionValue;
  bool _myIsExpanded;

  ExpansionTileData({String newHeaderTimeValue, String newHeaderDateValue, String newHeaderActionValue,  bool newIsExpanded}){
    _myHeaderTimeValue = newHeaderTimeValue;
    _myHeaderDateValue = newHeaderDateValue;
    _myIsExpanded = newIsExpanded;
    _myHeaderActionValue = newHeaderActionValue;
  }

  String getHeaderDateValue () => _myHeaderDateValue;
  String getHeaderTimeValue () => _myHeaderTimeValue;
  String getHeaderActionValue () => _myHeaderActionValue;
  bool getIsExpanded ()=> _myIsExpanded;

  void setIsExpanded (bool newIsExpanded) {
    _myIsExpanded = newIsExpanded;
  }
  void setHeaderDateValue (String newHeaderDateValue) {
    _myHeaderDateValue = newHeaderDateValue;
  }
  void setHeaderTimeValue (String newHeaderTimeValue) {
    _myHeaderTimeValue = newHeaderTimeValue;
  }
  void setHeaderActionValue (String newHeaderActionValue) {
    _myHeaderActionValue = newHeaderActionValue;
  }
}