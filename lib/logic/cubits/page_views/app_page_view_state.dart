import 'package:flutter/material.dart';

@immutable
abstract class AppPageViewState {}

class AppPageViewStatePosition extends AppPageViewState {
  final int index;

  AppPageViewStatePosition(this.index);
}
