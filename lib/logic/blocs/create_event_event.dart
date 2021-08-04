import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:equatable/equatable.dart';
import 'package:database_repository/database_repository.dart';

@immutable
abstract class CreateEventEvent extends Equatable{}// CreateEventEvent

class CreateEventSetEvent extends CreateEventEvent {
  final EventModel eventModel;

  CreateEventSetEvent({@required this.eventModel});

  @override
  List<Object> get props => [eventModel];
}// CreateEventSetEvent

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

/// Sets the End DateTime to null
class CreateEventRemoveRawEndDateTime extends CreateEventEvent {
  @override
  List<Object> get props => [];
}// CreateEventRemoveRawEndDateTime

class CreateEventSetCategory extends CreateEventEvent {
  final String category;

  CreateEventSetCategory({@required this.category});

  @override
  List<Object> get props => [category];
}// CreateEventSetCategory

class CreateEventAddHighlight extends CreateEventEvent {
  final String highlight;

  CreateEventAddHighlight({@required this.highlight});

  @override
  List<Object> get props => [highlight];
}// CreateEventSetCategory

class CreateEventRemoveHighlight extends CreateEventEvent {
  final int index;

  CreateEventRemoveHighlight({@required this.index});

  @override
  List<Object> get props => [index];
}// CreateEventRemoveHighlight

class CreateEventSetHighlight extends CreateEventEvent {
  final int index;
  final String highlight;

  CreateEventSetHighlight({@required this.index, @required this.highlight});

  @override
  List<Object> get props => [index];
}// CreateEventSetHighlight

class CreateEventSetImage extends CreateEventEvent {
  final Uint8List imageBytes;

  CreateEventSetImage({@required this.imageBytes});

  @override
  List<Object> get props => [imageBytes];
}// CreateEventSetImage

class CreateEventSetImageFitCover extends CreateEventEvent {
  final bool fitCover;
  CreateEventSetImageFitCover({@required this.fitCover});

  @override
  List<Object> get props => [fitCover];
}// CreateEventSetImageFitCover

class CreateEventSetImagePath extends CreateEventEvent {
  final String imagePath;
  CreateEventSetImagePath({@required this.imagePath});

  @override
  List<Object> get props => [imagePath];
}// CreateEventSetImagePath