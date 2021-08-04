import 'dart:async';
import 'package:bloc/bloc.dart';
import 'upload_event_event.dart';
import 'upload_event_state.dart';
import 'package:flutter/material.dart';
import 'package:communitytabs/logic/logic.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:database_repository/database_repository.dart';

class UploadEventBloc extends Bloc<UploadEventEvent, UploadEventState> {
  final DatabaseRepository db;
  UploadTask uploadTask;

  UploadEventBloc({@required this.db}) : super(UploadEventStateInitial());

  @override
  Stream<UploadEventState> mapEventToState(
    UploadEventEvent event,
  ) async* {
    // Start Upload
    if (event is UploadEventUpload) {
      yield* _mapUploadEventUploadToState(uploadEventUpload: event);
    } // if

    else if (event is UploadEventCancel) {
      yield* _mapUploadEventCancelToState();
    } // else if

    else if (event is UploadEventReset) {
      yield* _mapUploadEventResetToState();
    } // else if

    else if (event is UploadEventComplete) {
      yield* _mapUploadEventCompleteToState();
    } // else if
  } // mapEventToState

  Stream<UploadEventState> _mapUploadEventUploadToState(
      {@required UploadEventUpload uploadEventUpload}) async* {
    // Only allow one upload task at a time
    if (uploadTask != null) {
      return;
    } // if

    // Start new upload event
    if (uploadEventUpload.newEventModel != null) {
      CreateEventFormAction action = uploadEventUpload.createEventFormAction;
      EventModel newEventModel = uploadEventUpload.newEventModel;

      // Form Action Create
      if (action == CreateEventFormAction.create) {
        // Store full event details
        newEventModel.eventID = await this
            .db
            .insertNewEventToEventsCollection(newEvent: newEventModel);

        // Make the event searchable
        if (newEventModel.eventID != null || newEventModel.eventID.isNotEmpty) {
          newEventModel.searchID = await this
              .db
              .insertNewEventToSearchableCollection(newEvent: newEventModel);
        } // if
      } // if

      // Form Action Update
      else if (action == CreateEventFormAction.update) {
        await this.db.updateEventInEventsCollection(newEvent: newEventModel);
        await this
            .db
            .updateEventInSearchEventsCollection(newEvent: newEventModel);
      } // else if

      // TODO: Consider letting the user deleting an image
      // Only upload an image if the user chose one
      if (newEventModel.imageBytes != null) {
        // Generate the storage path for the image
        newEventModel.imagePath = this.db.imagePath(eventID: newEventModel.eventID);

        // Upload image bytes to firebase storage bucket using
        // the new event's document id as a the name for the image.
        if (newEventModel.eventID != null && newEventModel.eventID.isNotEmpty) {
          this.uploadTask = this.db.uploadImageToStorage(
              eventID: newEventModel.eventID,
              imageBytes: newEventModel.imageBytes);
        } // if
      }// if

      yield UploadEventStateUploading(
        uploadTask: this.uploadTask,
        eventModel: newEventModel,
      );
    } // if
  } // _mapUploadEventUploadToState

  Stream<UploadEventStateInitial> _mapUploadEventResetToState() async* {
    // Only can reset the event BloC if there was an event uploaded
    if (this.uploadTask != null) {
      yield (UploadEventStateInitial());
      this.uploadTask = null;
    } // if
  } // _mapUploadEventResetToState

  Stream<UploadEventState> _mapUploadEventCancelToState() async* {
    // An event must already be being uploaded
    if (this.uploadTask == null) {
      return;
    } // if

    this.uploadTask.cancel();
    // Maybe delete the event stored, but what
    // if users want to undo canceling an upload event?
  } // UploadEventBloc

  Stream<UploadEventState> _mapUploadEventCompleteToState() async* {
    // An event must already be being uploaded
    if (this.uploadTask != null) {
      final state = this.state;
      if (state is UploadEventStateUploading) {
        // Emit state, but with upload complete flag
        state.uploadComplete();
        yield state;
      } // if
    } // if
  } // _mapUploadEventCompleteToState

  // TODO: Remove print when Create Event Bloc changes
  @override
  void onChange(Change<UploadEventState> change) {
    print('Upload Event Bloc $change');
    super.onChange(change);
  } // onChange

  // TODO: Remove print when Create Event Bloc is closed
  @override
  Future<void> close() {
    print('Upload Event Bloc Closed!');
    return super.close();
  } // close
} // UploadEventBloc
