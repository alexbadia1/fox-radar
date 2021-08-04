import 'package:bloc/bloc.dart';
import 'date_time_picker_state.dart';
import 'package:flutter/material.dart';

class DateTimePickerCubit extends Cubit<DateTimePickerState> {
  DateTimePickerCubit()
      : super(DateTimePickerClosed(
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
    } // else

    emit(DateTimePickerOpenShowDatePicker(isOpen: true, tempDateTime: tempDateTime));
  } // open

  void openExpansionPanelToTimePicker({
    DateTime tempDateTime,
  }) {
    if (tempDateTime == null) {
      tempDateTime = _setTime(currentDateTime: state.tempDateTime, newTime: state.tempDateTime);
    } // if

    else {
      tempDateTime = _setTime(currentDateTime: state.tempDateTime, newTime: tempDateTime);
    } // else

    emit(DateTimePickerOpenShowTimePicker(isOpen: true, tempDateTime: tempDateTime));
  } // open

  void closeExpansionPanel() {
    final _currentState = this.state;

    emit(DateTimePickerClosed(isOpen: false, tempDateTime: _currentState.tempDateTime));
  } // close

  DateTime _setTime({@required DateTime currentDateTime, @required DateTime newTime}) {
    currentDateTime = new DateTime(
      currentDateTime.year,
      currentDateTime.month,
      currentDateTime.day,
      newTime.hour,
      newTime.minute,
    );

    return currentDateTime;
  } // _setTime

  DateTime _setDate({@required DateTime currentDateTime, @required DateTime newDate}) {
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
  void onChange(Change<DateTimePickerState> change) {
    print('DateTime Picker Cubit $change');
    super.onChange(change);
  } // onChange
} // DateTimePickerCubit
