import 'package:flutter/material.dart';
import 'package:equatable/equatable.dart';

abstract class CategoryPickerState extends Equatable {
  /// ExpansionPanels require a boolean value
  /// for the isExpanded and canTapOnHeader properties
  final bool isOpen;

  /// Stores the users chosen category without actually updating the CreateEventBloc in order
  /// to allow the user to undo their edits to the selected category with the 'cancel' button.
  final String category;

  const CategoryPickerState(this.isOpen, this.category);
} // CategoryPickerState

class CategoryPickerClosed extends CategoryPickerState {
  CategoryPickerClosed({@required bool isOpen, @required String category})
      : super(isOpen, category);

  @override
  List<Object> get props => [super.isOpen, this.category];
} // CategoryPickerClosed

class CategoryPickerOpen extends CategoryPickerState {
  CategoryPickerOpen({@required bool isOpen, @required String category})
      : super(isOpen, category);

  @override
  List<Object> get props => [super.isOpen, this.category];
} // CategoryPickerOpen
