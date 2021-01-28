import 'dart:async';
import 'package:authentication_repository/authentication_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:database_repository/database_repository.dart';
import 'suggested_events_event.dart';
import 'suggested_events_state.dart';
import 'package:flutter/material.dart';
import 'package:communitytabs/logic/blocs/suggested_events_event.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SuggestedEventsBloc extends Bloc<SuggestedEventsEvent, SuggestedEventsState> {
  final DatabaseRepository db;

  SuggestedEventsBloc({@required this.db}) : super(SuggestedEventsStateFetching());

  @override
  Stream<SuggestedEventsState> mapEventToState(
      SuggestedEventsEvent suggestedEventsEvent) async* {
    if (suggestedEventsEvent is SuggestedEventsEventFetch) {
      yield* _mapSuggestedEventsEventFetchToState();
    } // if

    else {
      yield SuggestedEventsStateFailed();
    } // else
  } // mapEventToState

  Stream<SuggestedEventsState> _mapSuggestedEventsEventFetchToState() async* {
    final _currentState = this.state;
    try {
      /// No posts were fetched yet
      if (_currentState is SuggestedEventsStateFetching) {
        final List<QueryDocumentSnapshot> _docs = await _fetchEventsWithPagination(lastEvent: null, limit: 1);
        final List<EventModel> _eventModels = _mapDocumentSnapshotsToEventModels(docs: _docs);

        yield SuggestedEventsStateSuccess(eventModels: _eventModels, maxEvents: false);
        return;
      } // if

      /// Some posts were fetched already, now fetch 20 more
      if (_currentState is SuggestedEventsStateSuccess) {
        final List<QueryDocumentSnapshot> _docs = await _fetchEventsWithPagination(lastEvent: _currentState.lastEvent, limit: 20);
        final List<EventModel> _eventModels = _mapDocumentSnapshotsToEventModels(docs: _docs);
        /// No event models were returned from the database
        if (_eventModels.isEmpty) {
          yield SuggestedEventsStateSuccess(
            eventModels: _currentState.eventModels,
            maxEvents: true,
          );
        } // if

        /// At least 1 event was returned from the database
        else {
          yield SuggestedEventsStateSuccess(
            eventModels: _currentState.eventModels + _eventModels,
            maxEvents: false,
          );
        } // else
      } // if
    } catch (e) {
      print(e);
      yield SuggestedEventsStateFailed();
    } // catch
  } // _mapSuggestedEventsEventFetchToState

  Future<List<QueryDocumentSnapshot>> _fetchEventsWithPagination({@required QueryDocumentSnapshot lastEvent, @required int limit}) async {
    return db.getEventsWithPagination(
        category: 'Suggested',
        lastEvent: lastEvent,
        limit: limit);
  }// _fetchEventsWithPagination

  List<EventModel> _mapDocumentSnapshotsToEventModels({@required List<QueryDocumentSnapshot> docs}) {
    return docs.map((doc) {
      Timestamp tempRawStartDateAndTime = doc.data()['rawStartDateAndTime'];
      Timestamp tempRawEndDateAndTime = doc.data()['rawEndDateAndTime'];

      DateTime tempRawStartDateAndTimeToDateTime;
      DateTime tempRawEndDateAndTimeToDateTime;

      if (tempRawStartDateAndTime != null)
        tempRawStartDateAndTimeToDateTime = DateTime.fromMillisecondsSinceEpoch(
            tempRawStartDateAndTime.millisecondsSinceEpoch)
            .toUtc()
            .toLocal();
      else
        tempRawStartDateAndTimeToDateTime = null;

      if (tempRawEndDateAndTime != null)
        tempRawEndDateAndTimeToDateTime = DateTime.fromMillisecondsSinceEpoch(
            tempRawEndDateAndTime.millisecondsSinceEpoch)
            .toUtc()
            .toLocal();
      else
        tempRawEndDateAndTimeToDateTime = null;

      return EventModel(

        /// RawStartDate converted to [DATETIME] from [TIMESTAMP] in Firebase.
          newRawStartDateAndTime: tempRawStartDateAndTimeToDateTime ?? null,

          /// RawEndDate converted to [DATETIME] from [TIMESTAMP] in Firebase.
          newRawEndDateAndTime: tempRawEndDateAndTimeToDateTime ?? null,

          ///Category converted to [STRING] from [STRING] in Firebase.
          newCategory: doc.data()['category'] ?? '',

          ///Host converted to [STRING] from [STRING] in Firebase.
          newHost: doc.data()['host'] ?? '',

          ///Title converted to [STRING] from [STRING] in Firebase.
          newTitle: doc.data()['title'] ?? '',

          ///Location Converted to [] from [] in Firebase.
          newLocation: doc.data()['location'] ?? '',

          ///Room converted to [STRING] from [String] in Firebase.
          newRoom: doc.data()['room'] ?? '',

          ///Summary converted to [STRING] from [STRING] in Firebase.
          newSummary: doc.data()['summary'] ?? '',

          ///Highlights converted to [List<String>] from [List<dynamic>] in Firebase.
          newHighlights:
          List.from(doc.data()['highlights'] ?? ['', '', '', '', '']),

          ///Implement Firebase Images.
          newImageFitCover: doc.data()['imageFitCover'] ?? true,
          newImagePath: doc.data()['imagePath'] ?? '');
    }).toList();
  }// _mapDocumentSnapshotsToEventModels

@override
  void onChange(Change<SuggestedEventsState> change) {
    print('Suggestion Bloc: $change');
    super.onChange(change);
  }// onChange
}// SuggestedEventsBloc
