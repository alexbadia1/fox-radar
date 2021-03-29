import 'package:flutter/material.dart';
import 'package:equatable/equatable.dart';

abstract class CategoryPickerState extends Equatable {
  /// ExpansionPanels require a boolean value
  /// for the isExpanded and canTapOnHeader properties
  final bool isOpen;

  /// Stores the cupertino picker's current index chosen by the user.
  ///
  /// Doesn't update the CreateEventBloc in order to allow
  /// the user to undo their edits to the selected category with the 'cancel' button.
  final int index;

  const CategoryPickerState(this.isOpen, this.index);
} // CategoryPickerState

class CategoryPickerClosed extends CategoryPickerState {
  CategoryPickerClosed({@required bool isOpen, @required int index})
      : super(isOpen, index);

  @override
  List<Object> get props => [super.isOpen, this.index];
} // CategoryPickerClosed

class CategoryPickerOpen extends CategoryPickerState {
  CategoryPickerOpen({@required bool isOpen, @required int index})
      : super(isOpen, index);

  @override
  List<Object> get props => [super.isOpen, this.index];
} // CategoryPickerOpen
