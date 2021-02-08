import 'package:equatable/equatable.dart';

abstract class ExpansionPanelState extends Equatable {
  final bool isOpen;
  const ExpansionPanelState(this.isOpen);
}// ExpansionPanelState

class ExpansionPanelClosed extends ExpansionPanelState {
  ExpansionPanelClosed(bool isOpen) : super(isOpen);

  @override
  List<Object> get props => [super.isOpen];
}// ExpansionPanelClosed

class ExpansionPanelOpenShowDatePicker extends ExpansionPanelState {
  ExpansionPanelOpenShowDatePicker(bool isOpen) : super(isOpen);

  @override
  List<Object> get props => [super.isOpen];
}// ExpansionPanelOpenShowDatePicker

class ExpansionPanelOpenShowTimePicker extends ExpansionPanelState {
  ExpansionPanelOpenShowTimePicker(bool isOpen) : super(isOpen);

  @override
  List<Object> get props => [super.isOpen];
}// ExpansionPanelOpenShowDatePicker

