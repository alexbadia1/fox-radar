import 'package:flutter/material.dart';
import 'package:equatable/equatable.dart';
import 'package:communitytabs/logic/logic.dart';
import 'package:database_repository/database_repository.dart';

abstract class UploadEventEvent extends Equatable {} // UploadEventEvent

/// Starts an upload, if an upload is not already occurring
class UploadEventUpload extends UploadEventEvent {
  final CreateEventFormAction createEventFormAction;
  final EventModel newEventModel;

  UploadEventUpload(
      {@required this.newEventModel, @required this.createEventFormAction})
      : assert(newEventModel != null);

  @override
  List<Object> get props => [this.newEventModel, this.createEventFormAction];
} // UploadEventUpload

/// Cancels the current upload event
class UploadEventCancel extends UploadEventEvent {
  @override
  List<Object> get props => [];
} // UploadEventCancel

/// Resets the upload bloc
class UploadEventReset extends UploadEventEvent {
  @override
  List<Object> get props => [];
} // UploadEventReset

/// Upload was completed
class UploadEventComplete extends UploadEventEvent {
  @override
  List<Object> get props => [];
} // UploadEventCancel
