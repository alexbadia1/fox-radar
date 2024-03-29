import 'package:equatable/equatable.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:database_repository/database_repository.dart';

abstract class UploadEventState extends Equatable {
  const UploadEventState();
}

/// Initial state is returned to after the event
/// either successfully or failed to upload.
///
/// Removes anything in the UI indicating an event
/// uploaded successfully, is uploading, or failed to upload.
class UploadEventStateInitial extends UploadEventState {
  @override
  List<Object?> get props => [];
}

/// New event was is uploading,
/// expose the upload stream to the UI.
class UploadEventStateUploading extends UploadEventState {
  // Data type: Firebase storage upload task
  final UploadTask uploadTask;
  final EventModel eventModel;
  bool _complete = false;

  UploadEventStateUploading(
      {required this.uploadTask, required this.eventModel});
  @override
  List<Object?> get props => [];

  void uploadComplete() {
    this._complete = true;
  }

  get complete => this._complete;
}
