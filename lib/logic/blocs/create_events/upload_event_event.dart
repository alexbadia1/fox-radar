import 'package:equatable/equatable.dart';
import 'package:fox_radar/logic/logic.dart';
import 'package:database_repository/database_repository.dart';

abstract class UploadEventEvent extends Equatable {} // UploadEventEvent

/// Starts an upload, if an upload is not already occurring
class UploadEventUpload extends UploadEventEvent {
  final CreateEventFormAction createEventFormAction;
  final EventModel? newEventModel;

  UploadEventUpload({
    required this.newEventModel,
    required this.createEventFormAction,
  });

  @override
  List<Object?> get props => [this.newEventModel, this.createEventFormAction];
}

/// Cancels the current upload event
class UploadEventCancel extends UploadEventEvent {
  @override
  List<Object?> get props => [];
}

/// Resets the upload bloc
class UploadEventReset extends UploadEventEvent {
  @override
  List<Object?> get props => [];
}

/// Upload was completed
class UploadEventComplete extends UploadEventEvent {
  @override
  List<Object?> get props => [];
}
