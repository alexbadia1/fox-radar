import 'package:flutter/material.dart';
import 'package:equatable/equatable.dart';

@immutable
abstract class CreateEventState extends Equatable{}

class CreateEventInitial extends CreateEventState {
  @override
  List<Object> get props => [];
}// CreateEventInitial

class CreateEventSubmitted extends CreateEventState {
  @override
  List<Object> get props => [];
}// CreateEventInitial

class CreateEventSuccess extends CreateEventState {
  @override
  List<Object> get props => [];
}// CreateEventInitial

class CreateEventFailure extends CreateEventState {
  @override
  List<Object> get props => [];
}// CreateEventInitial