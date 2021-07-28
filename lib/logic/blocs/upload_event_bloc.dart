import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:communitytabs/logic/blocs/blocs.dart';
import 'package:communitytabs/logic/logic.dart';
import 'upload_event_event.dart';
import 'upload_event_state.dart';
import 'package:flutter/material.dart';
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
      yield* _mapUploadEventCancelToState(uploadEventCancel: event);
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
      String createEventId;
      EventModel newEventModel = uploadEventUpload.newEventModel;

      // Create new "event" document in the Events Collection
      createEventId = await this
          .db
          .insertNewEventToEventsCollection(newEvent: newEventModel);
      newEventModel.eventID = createEventId;
      newEventModel.imagePath = this.db.imagePath(eventID: createEventId);

      // Upload new event data to the firebase cloud search events document
      if (createEventId != null) {
        String searchEventId;

        searchEventId = await this
            .db
            .insertNewEventToSearchableCollection(newEvent: newEventModel);

        newEventModel.searchID = searchEventId;
      } // if

      // Upload image bytes to firebase storage bucket using
      // the new event's document id as a the name for the image.
      if (createEventId != null) {
        this.uploadTask = this.db.uploadImageToStorage(
            eventID: newEventModel.eventID,
            imageBytes: newEventModel.imageBytes);
      } // if

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

  Stream<UploadEventState> _mapUploadEventCancelToState(
      {@required UploadEventCancel uploadEventCancel}) async* {
    // An event must already be being uploaded
    if (this.uploadTask == null) {
      return;
    } // if

    this.uploadTask.cancel();
    // Maybe delete the event stored, but what
    // if users want to undo canceling an upload event?
  } // UploadEventBloc

  Stream<UploadEventState> _mapUploadEventCompleteToState(
      {@required UploadEventCancel uploadEventCancel}) async* {
    // An event must already be being uploaded
    if (this.uploadTask != null) {
      final state = this.state;
      if (state is UploadEventStateUploading) {
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
