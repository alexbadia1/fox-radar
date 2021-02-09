import 'package:flutter/material.dart';
import 'package:equatable/equatable.dart';

abstract class ExpansionPanelState extends Equatable {
  /// ExpansionPanels require a boolean value
  /// for the isExpanded and canTapOnHeader properties
  final bool isOpen;

  /// Stores the users chosen date without actually updating the CreateEventBloc in order
  /// to allow the user to undo their edits to the Start or End Date with the 'cancel' button.
  final DateTime tempDateTime;

  const ExpansionPanelState(this.isOpen, this.tempDateTime);
} // ExpansionPanelState

class ExpansionPanelClosed extends ExpansionPanelState {
  ExpansionPanelClosed(
      {@required bool isOpen,
      @required DateTime tempDateTime})
      : super(isOpen, tempDateTime);

  @override
  List<Object> get props => [super.isOpen, this.tempDateTime];
} // ExpansionPanelClosed

class ExpansionPanelOpenShowDatePicker extends ExpansionPanelState {
  ExpansionPanelOpenShowDatePicker(
      {@required bool isOpen,
      @required DateTime tempDateTime})
      : super(isOpen, tempDateTime);

  @override
  List<Object> get props => [super.isOpen, this.tempDateTime];
} // ExpansionPanelOpenShowDatePicker

class ExpansionPanelOpenShowTimePicker extends ExpansionPanelState {
  ExpansionPanelOpenShowTimePicker(
      {@required bool isOpen,
      @required DateTime tempDateTime})
      : super(isOpen, tempDateTime);

  @override
  List<Object> get props => [super.isOpen, this.tempDateTime];
} // ExpansionPanelOpenShowDatePicker
