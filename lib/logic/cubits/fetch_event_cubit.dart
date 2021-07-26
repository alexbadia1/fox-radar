import 'package:bloc/bloc.dart';
import 'fetch_event_state.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:database_repository/database_repository.dart';

class FetchFullEventCubit extends Cubit<FetchFullEventState> {
  final DatabaseRepository db;

  FetchFullEventCubit({@required this.db}) : super(FetchFullEventInitial());

  void fetchEvent({@required documentId}) async {
    DocumentSnapshot _documentSnapshot;
    try {
      _documentSnapshot =
          await db.getEventFromEventsCollection(documentId: documentId);

      final EventModel _eventModel = _mapQueryDocumentSnapshotToEventModel(
          documentSnapshot: _documentSnapshot);

      emit(FetchFullEventSuccess(eventModel: _eventModel));

      final _currentState = this.state;
      if (_currentState is FetchFullEventSuccess) {
        _currentState.formatEventDatesAndTimes();
      } // if
    } // try
    catch (error) {
      // print(error);

      emit(FetchFullEventFailure());
    } // catch
    return;
  } // fetchEvent

  EventModel _mapQueryDocumentSnapshotToEventModel(
      {@required DocumentSnapshot documentSnapshot}) {
    Timestamp _startTimestamp =
        documentSnapshot.data()[ATTRIBUTE_RAW_START_DATE_TIME];
    Timestamp _endTimestamp =
        documentSnapshot.data()[ATTRIBUTE_RAW_END_DATE_TIME];

    DateTime tempRawStartDateAndTimeToDateTime;
    DateTime tempRawEndDateAndTimeToDateTime;

    if (_startTimestamp != null) {
      tempRawStartDateAndTimeToDateTime = DateTime.fromMillisecondsSinceEpoch(
              _startTimestamp.millisecondsSinceEpoch)
          .toUtc()
          .toLocal();
    } // if

    else {
      tempRawStartDateAndTimeToDateTime = null;
    } // else

    if (_endTimestamp != null) {
      tempRawEndDateAndTimeToDateTime = DateTime.fromMillisecondsSinceEpoch(
              _endTimestamp.millisecondsSinceEpoch)
          .toUtc()
          .toLocal();
    } // if

    else {
      tempRawEndDateAndTimeToDateTime = null;
    } // else

    return EventModel(
      // Title converted to [STRING] from [STRING] in Firebase.
      newTitle: documentSnapshot.data()[ATTRIBUTE_TITLE] ?? '',

      // Host converted to [STRING] from [STRING] in Firebase.
      newHost: documentSnapshot.data()[ATTRIBUTE_HOST] ?? '',

      // Location Converted to [] from [] in Firebase.
      newLocation: documentSnapshot.data()[ATTRIBUTE_LOCATION] ?? '',

      // Room converted to [STRING] from [String] in Firebase.
      newRoom: documentSnapshot.data()[ATTRIBUTE_ROOM] ?? '',

      // RawStartDate converted to [DATETIME] from [TIMESTAMP] in Firebase.
      newRawStartDateAndTime: tempRawStartDateAndTimeToDateTime ?? null,

      // RawEndDate converted to [DATETIME] from [TIMESTAMP] in Firebase.
      newRawEndDateAndTime: tempRawEndDateAndTimeToDateTime ?? null,

      // Category converted to [STRING] from [STRING] in Firebase.
      newCategory: documentSnapshot.data()[ATTRIBUTE_CATEGORY] ?? '',

      // Highlights converted to [List<String>] from [List<dynamic>] in Firebase.
      newHighlights: List.from(
          documentSnapshot.data()[ATTRIBUTE_HIGHLIGHTS] ?? ['', '', '', '', ''],
      ),

      // Description converted to [STRING] from [STRING] in Firebase.
      newDescription: documentSnapshot.data()[ATTRIBUTE_DESCRIPTION] ?? '',

      // Implement Firebase Images.
      newImageFitCover: documentSnapshot.data()[ATTRIBUTE_IMAGE_FIT_COVER] ?? false,

      // DocumentId converted to [STRING] from [STRING] in firebase.
      newEventID: documentSnapshot.id ?? '',

      newAccountID: documentSnapshot.data()[ATTRIBUTE_ACCOUNT_ID] ?? '',
    );
  } // _mapQueryDocumentSnapshotToEventModel

  @override
  void onChange(Change<FetchFullEventState> change) {
    print('Fetch Event Cubit: $change');
    super.onChange(change);
  } // onChange
} // FetchEventCubit
