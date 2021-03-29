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
      _documentSnapshot = await db.getEventFromEventsCollection(documentId: documentId);

      final EventModel _eventModel = _mapQueryDocumentSnapshotToEventModel(
          documentSnapshot: _documentSnapshot);

      emit(FetchFullEventSuccess(eventModel: _eventModel));

      final _currentState = this.state;
      if (_currentState is FetchFullEventSuccess) {
        _currentState.formatEventDatesAndTimes();
      }// if
    } // try
    catch (error) {

      // print(error);

      emit(FetchFullEventFailure());
    } // catch
    return;
  } // fetchEvent

  EventModel _mapQueryDocumentSnapshotToEventModel(
      {@required DocumentSnapshot documentSnapshot}) {

    // print('Firebase data: ${documentSnapshot.data()}');

    Timestamp _startTimestamp = documentSnapshot.data()['rawStartDateAndTime'];
    Timestamp _endTimestamp = documentSnapshot.data()['rawEndDateAndTime'];

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
        /// DocumentId converted to [STRING] from [STRING] in firebase.
        newId: documentSnapshot.id,

        /// RawStartDate converted to [DATETIME] from [TIMESTAMP] in Firebase.
        newRawStartDateAndTime: tempRawStartDateAndTimeToDateTime ?? null,

        /// RawEndDate converted to [DATETIME] from [TIMESTAMP] in Firebase.
        newRawEndDateAndTime: tempRawEndDateAndTimeToDateTime ?? null,

        ///Category converted to [STRING] from [STRING] in Firebase.
        newCategory: documentSnapshot.data()['category'] ?? '',

        ///Host converted to [STRING] from [STRING] in Firebase.
        newHost: documentSnapshot.data()['host'] ?? '',

        ///Title converted to [STRING] from [STRING] in Firebase.
        newTitle: documentSnapshot.data()['title'] ?? '',

        ///Location Converted to [] from [] in Firebase.
        newLocation: documentSnapshot.data()['location'] ?? '',

        ///Room converted to [STRING] from [String] in Firebase.
        newRoom: documentSnapshot.data()['room'] ?? '',

        ///Summary converted to [STRING] from [STRING] in Firebase.
        newSummary: documentSnapshot.data()['summary'] ?? '',

        ///Highlights converted to [List<String>] from [List<dynamic>] in Firebase.
        newHighlights: List.from(
            documentSnapshot.data()['highlights'] ?? ['', '', '', '', '']),

        ///Implement Firebase Images.
        newImageFitCover: documentSnapshot.data()['imageFitCover'] ?? true,);
  } // _mapQueryDocumentSnaphshotToEventModel

  @override
  void onChange(Change<FetchFullEventState> change) {
    print('Fetch Event Cubit: $change');
    super.onChange(change);
  } // onChange
} // FetchEventCubit
