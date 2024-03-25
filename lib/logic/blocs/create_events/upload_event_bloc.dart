import 'dart:async';
import 'dart:typed_data';
import 'package:fox_radar/logic/logic.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:database_repository/database_repository.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';

class UploadEventBloc extends Bloc<UploadEventEvent, UploadEventState> {
  final DatabaseRepository db;
  final String uid;
  late UploadTask? uploadTask;

  UploadEventBloc({required this.db, required this.uid})
      : super(UploadEventStateInitial());

  @override
  Stream<UploadEventState> mapEventToState(
    UploadEventEvent event,
  ) async* {
    // Start Upload
    if (event is UploadEventUpload) {
      yield* _mapUploadEventUploadToState(uploadEventUpload: event);
    } else if (event is UploadEventCancel) {
      yield* _mapUploadEventCancelToState();
    } else if (event is UploadEventReset) {
      yield* _mapUploadEventResetToState();
    } else if (event is UploadEventComplete) {
      yield* _mapUploadEventCompleteToState();
    }
  }

  Stream<UploadEventState> _mapUploadEventUploadToState({required UploadEventUpload uploadEventUpload}) async* {
    // Only allow one upload task at a time
    if (uploadTask != null) {
      return;
    }

    // Start new upload event
    if (uploadEventUpload.newEventModel != null) {
      CreateEventFormAction action = uploadEventUpload.createEventFormAction;

      // New Event Model tricks equatable into viewing the
      // the next [UploadEventStateUploading] as a new state.
      EventModel newEventModel = uploadEventUpload.newEventModel;

      // Form Action Create
      if (action == CreateEventFormAction.create) {
        newEventModel.eventID = await this.db.createEvent(newEventModel, this.uid);
      }

      // Form Action Update
      else if (action == CreateEventFormAction.update) {
        await this.db.updateEvent(newEventModel);
      }

      // TODO: Consider letting the user deleting an image

      // Only upload an image if the user chose one
      if (newEventModel.imageBytes != null) {
        // Begin compression...
        final Future<Uint8List> compressedBytes = this._compressImage(newEventModel.imageBytes!);

        // Generate the storage path for the image
        newEventModel.imagePath = this.db.imagePath(eventID: newEventModel.eventID!);

        // Upload image bytes to firebase storage bucket using
        // the new event's document id as a the name for the image.
        if (newEventModel.eventID != null && newEventModel.eventID!.isNotEmpty) {
          this.uploadTask = this.db.uploadImageToStorage(eventID: newEventModel.eventID!, imageBytes: await compressedBytes);

          yield UploadEventStateUploading(
            uploadTask: this.uploadTask!,
            eventModel: newEventModel,
          );
        }
      }
    }
  }

  Stream<UploadEventStateInitial> _mapUploadEventResetToState() async* {
    // Only can reset the event BloC if there was an event uploaded
    if (this.uploadTask != null) {
      yield (UploadEventStateInitial());
      this.uploadTask = null;
    }
  }

  Stream<UploadEventState> _mapUploadEventCancelToState() async* {
    // An event must already be being uploaded
    if (this.uploadTask == null) {
      return;
    }

    this.uploadTask?.cancel();
    // Maybe delete the event stored, but what
    // if users want to undo canceling an upload event?
  }

  Stream<UploadEventState> _mapUploadEventCompleteToState() async* {
    // An event must already be being uploaded
    if (this.uploadTask != null) {
      final state = this.state;
      if (state is UploadEventStateUploading) {
        // Emit state, but with upload complete flag
        state.uploadComplete();
        yield state;
      }
    }
  }

  Future<Uint8List> _compressImage(Uint8List bytes) async {
    final megabytes = (bytes.lengthInBytes / 1024.0) / 1000;

    // Allow max size to be around 1.5 MB before compression
    if (megabytes.round() <= 1) {
      return bytes;
    }

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
    } catch (error) {
      return bytes; // Compression failed, return the original image
    }
  }

  @override
  void onChange(Change<UploadEventState> change) {
    print('Upload Event Bloc $change');
    super.onChange(change);
  }

  @override
  Future<void> close() {
    print('Upload Event Bloc Closed!');
    return super.close();
  }
}
