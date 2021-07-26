import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:rxdart/rxdart.dart';
import 'suggested_events_event.dart';
import 'suggested_events_state.dart';
import 'package:flutter/material.dart';
import 'package:communitytabs/logic/logic.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:database_repository/database_repository.dart';

class SuggestedEventsBloc extends Bloc<SuggestedEventsEvent, SuggestedEventsState> {
  final DatabaseRepository db;
  final int paginationLimit = PAGINATION_LIMIT;

  SuggestedEventsBloc({@required this.db})
      : assert(db != null),
        super(SuggestedEventsStateFetching());

  // Adds a debounce, to prevent the spamming of requesting events
  @override
  Stream<Transition<SuggestedEventsEvent, SuggestedEventsState>>
      transformEvents(Stream<SuggestedEventsEvent> events, transitionFn) {
    return super.transformEvents(
        events.debounceTime(const Duration(milliseconds: 0)), transitionFn);
  } // transformEvents

  @override
  Stream<SuggestedEventsState> mapEventToState(
      SuggestedEventsEvent suggestedEventsEvent) async* {
    // Fetch some events
    if (suggestedEventsEvent is SuggestedEventsEventFetch) {
      yield* _mapSuggestedEventsEventFetchToState();
    } // if

    // Reload the events list
    else if (suggestedEventsEvent is SuggestedEventsEventReload) {
      yield* _mapSuggestedEventsEventReloadToState();
    } // else if

    // The event added to the bloc has not associated state
    // either create one, or check the [suggested_events_state.dart]
    else {
      yield SuggestedEventsStateFailed();
    } // else
  } // mapEventToState

  Stream<SuggestedEventsState> _mapSuggestedEventsEventReloadToState() async* {
    // Get the current state for later use...
    final _currentState = this.state;
    bool _maxEvents = false;

    // Change "isFetching" to true, to show a
    // loading widget at the bottom of the list view.
    if (_currentState is SuggestedEventsStateSuccess) {
      yield SuggestedEventsStateSuccess(
        eventModels: _currentState.eventModels,
        maxEvents: _currentState.maxEvents,
        lastEvent: _currentState.lastEvent,
        isFetching: true,
      );
    } // if

    try {
      // No posts were fetched yet
      final List<QueryDocumentSnapshot> _docs =
          await _fetchEventsWithPagination(
              lastEvent: null, limit: paginationLimit);
      final List<SearchResultModel> _eventModels =
          _mapDocumentSnapshotsToSearchEventModels(docs: _docs);

      // Failed Reload from a failed state
      if (_currentState is SuggestedEventsStateFailed && _docs.isEmpty) {
        yield SuggestedEventsStateReloadFailed();
        yield SuggestedEventsStateFailed();
        return;
      } // if

      if (_eventModels.length != this.paginationLimit) {
        _maxEvents = true;
      } // if

      yield SuggestedEventsStateSuccess(
        eventModels: _eventModels,
        maxEvents: _maxEvents,
        lastEvent: _docs.last,
        isFetching: false,
      );
    } // try
    catch (e) {
      yield SuggestedEventsStateFailed();
    } // catch
  } // _mapSuggestedEventsEventReloadToState

  Stream<SuggestedEventsState> _mapSuggestedEventsEventFetchToState() async* {
    // Get the current state for later use...
    final _currentState = this.state;
    bool _maxEvents = false;

    try {
      // No posts were fetched yet
      if (_currentState is SuggestedEventsStateFetching) {
        final List<QueryDocumentSnapshot> _docs =
            await _fetchEventsWithPagination(
                lastEvent: null, limit: paginationLimit);
        final List<SearchResultModel> _eventModels =
            _mapDocumentSnapshotsToSearchEventModels(docs: _docs);

        if (_eventModels.length != this.paginationLimit) {
          _maxEvents = true;
        } // if

        yield SuggestedEventsStateSuccess(
          eventModels: _eventModels,
          maxEvents: _maxEvents,
          lastEvent: _docs.last,
          isFetching: false,
        );
      } // if

      // Some posts were fetched already, now fetch 20 more
      else if (_currentState is SuggestedEventsStateSuccess) {
        final List<QueryDocumentSnapshot> _docs =
            await _fetchEventsWithPagination(
                lastEvent: _currentState.lastEvent, limit: paginationLimit);

        // No event models were returned from the database
        if (_docs.isEmpty) {
          yield SuggestedEventsStateSuccess(
            eventModels: _currentState.eventModels,
            maxEvents: true,
            lastEvent: _currentState.lastEvent,
            isFetching: false,
          );
        } // if

        // At least 1 event was returned from the database
        else {
          final List<SearchResultModel> _eventModels =
              _mapDocumentSnapshotsToSearchEventModels(docs: _docs);

          if (_eventModels.length != this.paginationLimit) {
            _maxEvents = true;
          } // if

          yield SuggestedEventsStateSuccess(
            eventModels: _currentState.eventModels + _eventModels,
            maxEvents: _maxEvents,
            lastEvent: _docs?.last ?? _currentState.lastEvent,
            isFetching: false,
          );
        } // else
      } // if
    } catch (e) {
      yield SuggestedEventsStateFailed();
    } // catch
  } // _mapSuggestedEventsEventFetchToState

  Future<List<QueryDocumentSnapshot>> _fetchEventsWithPagination(
      {@required QueryDocumentSnapshot lastEvent, @required int limit}) async {
    return db.searchEventsByStartDateAndTime(
        lastEvent: lastEvent, limit: limit);
  } // _fetchEventsWithPagination

  List<SearchResultModel> _mapDocumentSnapshotsToSearchEventModels(
      {@required List<QueryDocumentSnapshot> docs}) {
    return docs.map((doc) {
      // Convert the firebase timestamp to a DateTime
      DateTime tempRawStartDateAndTimeToDateTime;
      Timestamp _startTimestamp = doc.data()[ATTRIBUTE_RAW_START_DATE_TIME];
      if (_startTimestamp != null) {
        tempRawStartDateAndTimeToDateTime = DateTime.fromMillisecondsSinceEpoch(
                _startTimestamp.millisecondsSinceEpoch)
            .toUtc()
            .toLocal();
      } // if
      else {
        tempRawStartDateAndTimeToDateTime = null;
      } // else

      return SearchResultModel(
        // Title converted to [STRING] from [STRING] in Firebase.
        newTitle: doc.data()[ATTRIBUTE_TITLE] ?? '',

        // Host converted to [STRING] from [STRING] in Firebase.
        newHost: doc.data()[ATTRIBUTE_HOST] ?? '',

        // Location Converted to [] from [] in Firebase.
        newLocation: doc.data()[ATTRIBUTE_LOCATION] ?? '',

        // RawStartDate converted to [DATETIME] from [TIMESTAMP] in Firebase.
        newRawStartDateAndTime: tempRawStartDateAndTimeToDateTime ?? null,

        // Category converted to [STRING] from [STRING] in Firebase.
        newCategory: doc.data()[ATTRIBUTE_CATEGORY] ?? '',

        // Implement Firebase Images.
        newImageFitCover: doc.data()[ATTRIBUTE_IMAGE_FIT_COVER] ?? true,

        // DocumentId converted to [STRING] from [STRING] in firebase.
        newEventId: doc.data()[ATTRIBUTE_EVENT_ID] ?? '',

        // AccountID converted to [STRING] from [STRING] in firebase.
        newAccountID: doc.data()[ATTRIBUTE_ACCOUNT_ID] ?? '',
      );
    }).toList();
  } // _mapDocumentSnapshotsToSearchEventModels

  @override
  void onChange(Change<SuggestedEventsState> change) {
    print('Suggested Events Bloc: $change');
    super.onChange(change);
  } // onChange

  @override
  Future<void> close() {
    print('Suggested Events Bloc Closed');
    return super.close();
  } // close
} // SuggestedEventsBloc
