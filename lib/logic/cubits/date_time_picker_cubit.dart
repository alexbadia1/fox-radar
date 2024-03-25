import 'package:bloc/bloc.dart';
import 'date_time_picker_state.dart';

class DateTimePickerCubit extends Cubit<DateTimePickerState> {
  DateTimePickerCubit()
      : super(DateTimePickerClosed(
          isOpen: false,
          tempDateTime: DateTime.now(),
        ));

  void openExpansionPanelToDatePicker({
    DateTime? tempDateTime,
  }) {
    if (tempDateTime == null) {
      tempDateTime = _setDate(currentDateTime: state.tempDateTime, newDate: state.tempDateTime);
    }
    else {
      tempDateTime = _setDate(currentDateTime: state.tempDateTime, newDate: tempDateTime);
    }

    emit(DateTimePickerOpenShowDatePicker(isOpen: true, tempDateTime: tempDateTime));
  }

  void openExpansionPanelToTimePicker({
    DateTime? tempDateTime,
  }) {
    if (tempDateTime == null) {
      tempDateTime = _setTime(currentDateTime: state.tempDateTime, newTime: state.tempDateTime);
    } else {
      tempDateTime = _setTime(currentDateTime: state.tempDateTime, newTime: tempDateTime);
    }

    emit(DateTimePickerOpenShowTimePicker(isOpen: true, tempDateTime: tempDateTime));
  }

  void closeExpansionPanel() {
    final _currentState = this.state;

    emit(DateTimePickerClosed(isOpen: false, tempDateTime: _currentState.tempDateTime));
  }

  DateTime _setTime({required DateTime currentDateTime, required DateTime newTime}) {
    currentDateTime = new DateTime(
      currentDateTime.year,
      currentDateTime.month,
      currentDateTime.day,
      newTime.hour,
      newTime.minute,
    );

    return currentDateTime;
  }

  DateTime _setDate({required DateTime currentDateTime, required DateTime newDate}) {
    currentDateTime = new DateTime(
      newDate.year,
      newDate.month,
      newDate.day,
      currentDateTime.hour,
      currentDateTime.minute,
    );

    return currentDateTime;
  }

  @override
  void onChange(Change<DateTimePickerState> change) {
    print('DateTime Picker Cubit $change');
    super.onChange(change);
  }
}
