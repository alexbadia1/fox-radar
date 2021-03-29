import 'package:flutter/material.dart';
import 'package:equatable/equatable.dart';

@immutable
abstract class SlidingUpPanelState extends Equatable{}

class SlidingUpPanelClosed extends SlidingUpPanelState {
  @override
  List<Object> get props => [];
}

class SlidingUpPanelOpen extends SlidingUpPanelState {
  @override
  List<Object> get props => [];
}