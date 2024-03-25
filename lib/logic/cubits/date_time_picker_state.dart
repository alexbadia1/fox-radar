import 'package:equatable/equatable.dart';

abstract class DateTimePickerState extends Equatable {
  /// ExpansionPanels require a boolean value
  /// for the isExpanded and canTapOnHeader properties
  final bool isOpen;

  /// Stores the users chosen date without actually updating the CreateEventBloc in order
  /// to allow the user to undo their edits to the Start or End Date with the 'cancel' button.
  final DateTime tempDateTime;

  const DateTimePickerState(this.isOpen, this.tempDateTime);
}

class DateTimePickerClosed extends DateTimePickerState {
  DateTimePickerClosed(
      {required bool isOpen,
      required DateTime tempDateTime})
      : super(isOpen, tempDateTime);

  @override
  List<Object?> get props => [super.isOpen, this.tempDateTime];
}

class DateTimePickerOpenShowDatePicker extends DateTimePickerState {
  DateTimePickerOpenShowDatePicker(
      {required bool isOpen,
      required DateTime tempDateTime})
      : super(isOpen, tempDateTime);

  @override
  List<Object> get props => [super.isOpen, this.tempDateTime];
}

class DateTimePickerOpenShowTimePicker extends DateTimePickerState {
  DateTimePickerOpenShowTimePicker(
      {required bool isOpen,
      required DateTime tempDateTime})
      : super(isOpen, tempDateTime);

  @override
  List<Object?> get props => [super.isOpen, this.tempDateTime];
}
