import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:fox_radar/logic/logic.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:database_repository/database_repository.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';

class UploadEventBloc extends Bloc<UploadEventEvent, UploadEventState> {
  final DatabaseRepository db;
  final String uid;
  UploadTask uploadTask;

  UploadEventBloc({@required this.db, @required this.uid})
      : assert(db != null),
        assert(uid != null),
        super(UploadEventStateInitial());

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

  Stream<UploadEventState> _mapUploadEventUploadToState({@required UploadEventUpload uploadEventUpload}) async* {
    // Only allow one upload task at a time
    if (uploadTask != null) {
      return;
    } // if

    // Start new upload event
    if (uploadEventUpload.newEventModel != null) {
      CreateEventFormAction action = uploadEventUpload.createEventFormAction;

      // New Event Model tricks equatable into viewing the
      // the next [UploadEventStateUploading] as a new state.
      EventModel newEventModel = uploadEventUpload.newEventModel;

      // Form Action Create
      if (action == CreateEventFormAction.create) {
        newEventModel.eventID = await this.db.createEvent(newEventModel, this.uid);
      } // if

      // Form Action Update
      else if (action == CreateEventFormAction.update) {
        await this.db.updateEvent(newEventModel);
      } // else if

      // TODO: Consider letting the user deleting an image

      // Only upload an image if the user chose one
      if (newEventModel.imageBytes != null) {
        // Begin compression...
        final Future<Uint8List> compressedBytes = this._compressImage(newEventModel.imageBytes);

        // Generate the storage path for the image
        newEventModel.imagePath = this.db.imagePath(eventID: newEventModel.eventID);

        // Upload image bytes to firebase storage bucket using
        // the new event's document id as a the name for the image.
        if (newEventModel.eventID != null && newEventModel.eventID.isNotEmpty) {
          this.uploadTask = this.db.uploadImageToStorage(eventID: newEventModel.eventID, imageBytes: await compressedBytes);

          yield UploadEventStateUploading(
            uploadTask: this.uploadTask,
            eventModel: newEventModel,
          );
        } // if
      } // if
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

  Future<Uint8List> _compressImage(Uint8List bytes) async {
    final megabytes = (bytes.lengthInBytes / 1024.0) / 1000;

    // Allow max size to be around 1.5 MB before compression
    if (megabytes.round() <= 1) {
      return bytes;
    } // if

    // Compress
    try {
      // Turns out the quality factor does not scale linearly
      // quality = 50 does not mean the image size is reduced by 50%.
      int quality = 100 ~/ megabytes + 60;

      // Add max and min
      quality = quality < 1 ? 1 : quality;
      quality = quality > 100 ? 100 : quality;

      final Uint8List compressedBytes = await FlutterImageCompress.compressWithList(
        bytes,
        minHeight: 1350,
        minWidth: 1080,
        quality: quality ?? 100,
        format: CompressFormat.jpeg,
      );
      return compressedBytes;
    } // try
    catch (error) {
      return bytes; // Compression failed, return the original image
    } // catch
  } // compressUint8List

  @override
  void onChange(Change<UploadEventState> change) {
    print('Upload Event Bloc $change');
    super.onChange(change);
  } // onChange

  @override
  Future<void> close() {
    print('Upload Event Bloc Closed!');
    return super.close();
  } // close
} // UploadEventBloc
