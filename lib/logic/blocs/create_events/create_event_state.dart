import 'package:flutter/material.dart';
import 'package:equatable/equatable.dart';
import 'package:database_repository/database_repository.dart';

@immutable
abstract class CreateEventState extends Equatable{
  final EventModel eventModel;
  CreateEventState(this.eventModel);

  @override
  List<Object?> get props => [eventModel];
}

class CreateEventValid extends CreateEventState {
  CreateEventValid(EventModel eventModel) : super(eventModel);

  @override
  List<Object?> get props => [super.eventModel];
}

class CreateEventInvalid extends CreateEventState {
  CreateEventInvalid(EventModel eventModel) : super(eventModel);

  @override
  List<Object?> get props => [super.eventModel];
}