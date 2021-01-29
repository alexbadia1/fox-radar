import 'dart:async';
import 'package:bloc/bloc.dart';
import 'suggested_events_event.dart';
import 'suggested_events_state.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:database_repository/database_repository.dart';
import 'package:communitytabs/logic/blocs/suggested_events_event.dart';

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

        yield SuggestedEventsStateSuccess(eventModels: _eventModels, maxEvents: false, lastEvent: _docs.last);
        return;
      } // if

      /// Some posts were fetched already, now fetch 20 more
      if (_currentState is SuggestedEventsStateSuccess) {
        final List<QueryDocumentSnapshot> _docs = await _fetchEventsWithPagination(lastEvent: _currentState.lastEvent, limit: 50);
        final List<EventModel> _eventModels = _mapDocumentSnapshotsToEventModels(docs: _docs);

        /// No event models were returned from the database
        if (_eventModels.isEmpty) {
          yield SuggestedEventsStateSuccess(
            eventModels: _currentState.eventModels,
            maxEvents: true,
              lastEvent: _docs.last ?? _currentState.lastEvent,
          );
        } // if

        /// At least 1 event was returned from the database
        else {
          _eventModels.forEach((element) { _currentState.eventModels.add(element);});

          yield SuggestedEventsStateSuccess(
            eventModels: _currentState.eventModels,
            maxEvents: false,
            lastEvent: _docs.last ?? _currentState.lastEvent,
          );
        } // else
      } // if
    } catch (e) {
      print(e);
      yield SuggestedEventsStateFailed();
    } // catch
  } // _mapSuggestedEventsEventFetchToState

  Future<List<QueryDocumentSnapshot>> _fetchEventsWithPagination({@required QueryDocumentSnapshot lastEvent, @required int limit}) async {
    return db.getEventsWithPaginationFromSearchEventsCollection(
        category: 'Movies & Theatre',
        lastEvent: lastEvent,
        limit: limit);
  }// _fetchEventsWithPagination

  List<EventModel> _mapDocumentSnapshotsToEventModels({@required List<QueryDocumentSnapshot> docs}) {
    return docs.map((doc) {
      return EventModel(
          /// DocumentId converted to [STRING] from [STRING] in firebase.
          newId: doc.data()['id'] ?? '',

          /// RawStartDate converted to [DATETIME] from [TIMESTAMP] in Firebase.
          newRawStartDateAndTime: null,

          /// RawEndDate converted to [DATETIME] from [TIMESTAMP] in Firebase.
          newRawEndDateAndTime: null,

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
