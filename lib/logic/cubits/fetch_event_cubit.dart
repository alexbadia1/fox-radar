import 'package:bloc/bloc.dart';
import 'fetch_event_state.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:database_repository/database_repository.dart';

class FetchFullEventCubit extends Cubit<FetchFullEventState> {
  final DatabaseRepository db;

  FetchFullEventCubit({@required this.db}) : super(FetchFullEventInitial());

  void fetchEvent({@required documentId}) async {
    DocumentSnapshot _docSnap =
        await db.getEventFromEventsCollection(documentId: documentId);

    // Failed to retrieve the event from firebase
    if (_docSnap == null) {
      emit(FetchFullEventFailure("Failed to retrieve the event from firebase"));
      return;
    } // if

    final EventModel _eventModel =
        _mapQueryDocumentSnapshotToEventModel(doc: _docSnap);

    // Something went wrong parsing the data
    if (_eventModel == null) {
      emit(FetchFullEventFailure("Something went wrong parsing the data"));
      return;
    } // if

    // All good!
    emit(FetchFullEventSuccess(eventModel: _eventModel));
    return;
  } // fetchEvent

  EventModel _mapQueryDocumentSnapshotToEventModel(
      {@required DocumentSnapshot doc}) {
    Map<String, dynamic> docSnap = doc.data() as Map;
    Timestamp _startTimestamp = docSnap[ATTRIBUTE_RAW_START_DATE_TIME];
    Timestamp _endTimestamp = docSnap[ATTRIBUTE_RAW_END_DATE_TIME];

    DateTime tempRawStartDateAndTimeToDateTime;
    DateTime tempRawEndDateAndTimeToDateTime;

    tempRawStartDateAndTimeToDateTime = _startTimestamp != null
        ? DateTime.fromMillisecondsSinceEpoch(
                _startTimestamp.millisecondsSinceEpoch)
            .toUtc()
            .toLocal()
        : null;

    tempRawEndDateAndTimeToDateTime = _endTimestamp != null
        ? DateTime.fromMillisecondsSinceEpoch(
                _endTimestamp.millisecondsSinceEpoch)
            .toUtc()
            .toLocal()
        : null;

    return EventModel(
      // Title converted to [STRING] from [STRING] in Firebase.
      newTitle: docSnap[ATTRIBUTE_TITLE] ?? '',

      // Host converted to [STRING] from [STRING] in Firebase.
      newHost: docSnap[ATTRIBUTE_HOST] ?? '',

      // Location Converted to [] from [] in Firebase.
      newLocation: docSnap[ATTRIBUTE_LOCATION] ?? '',

      // Room converted to [STRING] from [String] in Firebase.
      newRoom: docSnap[ATTRIBUTE_ROOM] ?? '',

      // RawStartDate converted to [DATETIME] from [TIMESTAMP] in Firebase.
      newRawStartDateAndTime: tempRawStartDateAndTimeToDateTime ?? null,

      // RawEndDate converted to [DATETIME] from [TIMESTAMP] in Firebase.
      newRawEndDateAndTime: tempRawEndDateAndTimeToDateTime ?? null,

      // Category converted to [STRING] from [STRING] in Firebase.
      newCategory: docSnap[ATTRIBUTE_CATEGORY] ?? '',

      // Highlights converted to [List<String>] from [List<dynamic>] in Firebase.
      newHighlights: List.from(
        docSnap[ATTRIBUTE_HIGHLIGHTS] ?? ['', '', '', '', ''],
      ),

      // Description converted to [STRING] from [STRING] in Firebase.
      newDescription: docSnap[ATTRIBUTE_DESCRIPTION] ?? '',

      // Implement Firebase Images.
      newImageFitCover: docSnap[ATTRIBUTE_IMAGE_FIT_COVER] ?? false,

      // DocumentId converted to [STRING] from [STRING] in firebase.
      newEventID: doc.id ?? '',
    );
  } // _mapQueryDocumentSnapshotToEventModel

  @override
  void onChange(Change<FetchFullEventState> change) {
    print('Fetch Event Cubit: $change');
    super.onChange(change);
  } // onChange
}// FetchEventCubit
