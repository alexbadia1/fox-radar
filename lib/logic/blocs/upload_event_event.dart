import 'package:database_repository/database_repository.dart';
import 'package:flutter/material.dart';
import 'package:equatable/equatable.dart';

abstract class UploadEventEvent extends Equatable {}// UploadEventEvent

/// Starts an upload, if an upload is not already occuring
class UploadEventUpload extends UploadEventEvent {
  final EventModel newEventModel;

  UploadEventUpload(
      {@required this.newEventModel})
      : assert(newEventModel != null);

  @override
  List<Object> get props => [this.newEventModel];
} // UploadEventUpload

/// Cancels the current upload event
class UploadEventCancel extends UploadEventEvent {
  @override
  List<Object> get props => [];
} // UploadEventCancel
