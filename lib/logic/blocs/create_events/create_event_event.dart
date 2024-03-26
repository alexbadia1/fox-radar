import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:equatable/equatable.dart';
import 'package:database_repository/database_repository.dart';

@immutable
abstract class CreateEventEvent extends Equatable {} // CreateEventEvent

class CreateEventSetEvent extends CreateEventEvent {
  final EventModel eventModel;

  CreateEventSetEvent({required this.eventModel});

  @override
  List<Object?> get props => [eventModel];
}

class CreateEventSetTitle extends CreateEventEvent {
  final String newTitle;

  CreateEventSetTitle({required this.newTitle});

  @override
  List<Object?> get props => [newTitle];
}

class CreateEventSetHost extends CreateEventEvent {
  final String newHost;

  CreateEventSetHost({required this.newHost});

  @override
  List<Object?> get props => [newHost];
}

class CreateEventSetLocation extends CreateEventEvent {
  final String newLocation;

  CreateEventSetLocation({required this.newLocation});

  @override
  List<Object?> get props => [newLocation];
}

class CreateEventSetRoom extends CreateEventEvent {
  final String newRoom;

  CreateEventSetRoom({required this.newRoom});

  @override
  List<Object?> get props => [newRoom];
}

class CreateEventSetDescription extends CreateEventEvent {
  final String newDescription;

  CreateEventSetDescription({required this.newDescription});

  @override
  List<Object?> get props => [newDescription];
}

class CreateEventSetRawStartDateTime extends CreateEventEvent {
  final DateTime newRawStartDateTime;

  CreateEventSetRawStartDateTime({required this.newRawStartDateTime});

  @override
  List<Object?> get props => [newRawStartDateTime];
}

class CreateEventSetRawEndDateTime extends CreateEventEvent {
  final DateTime newRawEndDateTime;

  CreateEventSetRawEndDateTime({required this.newRawEndDateTime});

  @override
  List<Object?> get props => [newRawEndDateTime];
}

/// Sets the End DateTime to null
class CreateEventRemoveRawEndDateTime extends CreateEventEvent {
  @override
  List<Object?> get props => [];
}

class CreateEventSetCategory extends CreateEventEvent {
  final String category;

  CreateEventSetCategory({required this.category});

  @override
  List<Object?> get props => [category];
}

class CreateEventAddHighlight extends CreateEventEvent {
  final String highlight;

  CreateEventAddHighlight({required this.highlight});

  @override
  List<Object?> get props => [highlight];
}

class CreateEventRemoveHighlight extends CreateEventEvent {
  final int index;

  CreateEventRemoveHighlight({required this.index});

  @override
  List<Object?> get props => [index];
}

class CreateEventSetHighlight extends CreateEventEvent {
  final int index;
  final String highlight;

  CreateEventSetHighlight({required this.index, required this.highlight});

  @override
  List<Object?> get props => [index];
}

class CreateEventSetImage extends CreateEventEvent {
  final Uint8List imageBytes;

  CreateEventSetImage({required this.imageBytes});

  @override
  List<Object?> get props => [imageBytes];
}

class CreateEventSetImageFitCover extends CreateEventEvent {
  final bool fitCover;
  CreateEventSetImageFitCover({required this.fitCover});

  @override
  List<Object?> get props => [fitCover];
}

class CreateEventSetImagePath extends CreateEventEvent {
  final String imagePath;
  CreateEventSetImagePath({required this.imagePath});

  @override
  List<Object?> get props => [imagePath];
}
