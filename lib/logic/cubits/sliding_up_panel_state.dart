import 'package:flutter/material.dart';
import 'package:equatable/equatable.dart';
import 'package:database_repository/database_repository.dart';

@immutable
abstract class SlidingUpPanelState extends Equatable {
  final EventModel initialEventModel;

  SlidingUpPanelState(this.initialEventModel);
}// SlidingUpPanelState

class SlidingUpPanelClosed extends SlidingUpPanelState {
  SlidingUpPanelClosed(initialEventModel) : super(initialEventModel);

  @override
  List<Object> get props => [];
} // SlidingUpPanelClosed

class SlidingUpPanelOpen extends SlidingUpPanelState {
  SlidingUpPanelOpen(initialEventModel) : super(initialEventModel);

  @override
  List<Object> get props => [];
} // SlidingUpPanelOpen
