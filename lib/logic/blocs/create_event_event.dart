import 'package:flutter/material.dart';
import 'package:equatable/equatable.dart';

@immutable
abstract class CreateEventEvent extends Equatable{}// CreateEventEvent

class CreateEventSetTitle extends CreateEventEvent {
  final String newTitle;

  CreateEventSetTitle({@required this.newTitle});

  @override
  List<Object> get props => [newTitle];
}// CreateEventSetTitle

class CreateEventSetHost extends CreateEventEvent {
  final String newHost;

  CreateEventSetHost({@required this.newHost});

  @override
  List<Object> get props => [newHost];
}// CreateEventSetHost

class CreateEventSetLocation extends CreateEventEvent {
  final String newLocation;

  CreateEventSetLocation({@required this.newLocation});

  @override
  List<Object> get props => [newLocation];
}// CreateEventSetLocation

class CreateEventSetRoom extends CreateEventEvent {
  final String newRoom;

  CreateEventSetRoom({@required this.newRoom});

  @override
  List<Object> get props => [newRoom];
}// CreateEventSetRoom

class CreateEventSetDescription extends CreateEventEvent {
  final String newDescription;

  CreateEventSetDescription({@required this.newDescription});

  @override
  List<Object> get props => [newDescription];
}// CreateEventSetDescription

class CreateEventSetRawStartDateTime extends CreateEventEvent {
  final DateTime newRawStartDateTime;

  CreateEventSetRawStartDateTime({@required this.newRawStartDateTime});

  @override
  List<Object> get props => [newRawStartDateTime];
}// CreateEventSetRawStartDateTime

class CreateEventSetRawEndDateTime extends CreateEventEvent {
  final DateTime newRawEndDateTime;

  CreateEventSetRawEndDateTime({@required this.newRawEndDateTime});

  @override
  List<Object> get props => [newRawEndDateTime];
}// CreateEventSetRawEndDateTime
