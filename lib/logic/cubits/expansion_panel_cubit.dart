import 'package:bloc/bloc.dart';
import 'expansion_panel_state.dart';
import 'package:flutter/material.dart';

class ExpansionPanelCubit extends Cubit<ExpansionPanelState> {
  ExpansionPanelCubit()
      : super(ExpansionPanelClosed(
          isOpen: false,
          tempDateTime: DateTime.now(),
        ));

  void openExpansionPanelToDatePicker({
    DateTime tempDateTime,
  }) {
    if (tempDateTime == null) {
      tempDateTime = _setDate(currentDateTime: state.tempDateTime, newDate: state.tempDateTime);
    } // if
    else {
      tempDateTime = _setDate(currentDateTime: state.tempDateTime, newDate: tempDateTime);
    }// else

    emit(ExpansionPanelOpenShowDatePicker(
        isOpen: true, tempDateTime: tempDateTime));
  } // open

  void openExpansionPanelToTimePicker({
    DateTime tempDateTime,
  }) {
    if (tempDateTime == null) {
      tempDateTime = _setTime(currentDateTime: state.tempDateTime, newTime: state.tempDateTime);
    } // if

    else {
      tempDateTime = _setTime(currentDateTime: state.tempDateTime, newTime: tempDateTime);
    }// else

    emit(ExpansionPanelOpenShowTimePicker(
        isOpen: true, tempDateTime: tempDateTime));
  } // open

  void closeExpansionPanel() {
    final _currentState = this.state;

    emit(ExpansionPanelClosed(
        isOpen: false, tempDateTime: _currentState.tempDateTime));
  } // close

  DateTime _setTime(
      {@required DateTime currentDateTime, @required DateTime newTime}) {
    currentDateTime = new DateTime(
      currentDateTime.year,
      currentDateTime.month,
      currentDateTime.day,
      newTime.hour,
      newTime.minute,
    );

    return currentDateTime;
  } // _setTime

  DateTime _setDate(
      {@required DateTime currentDateTime, @required DateTime newDate}) {
    currentDateTime = new DateTime(
      newDate.year,
      newDate.month,
      newDate.day,
      currentDateTime.hour,
      currentDateTime.minute,
    );

    return currentDateTime;
  } // _setDate

  @override
  void onChange(Change<ExpansionPanelState> change) {
    print('Expansion Panel Cubit $change');
    super.onChange(change);
  } // onChange
} // ExpansionPanelCubit
