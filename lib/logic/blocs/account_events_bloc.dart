import 'dart:async';
import 'package:bloc/bloc.dart';
import 'account_events_event.dart';
import 'account_events_state.dart';
import 'package:rxdart/rxdart.dart';
import 'package:flutter/material.dart';
import 'package:communitytabs/logic/logic.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:database_repository/database_repository.dart';

class AccountEventsBloc extends Bloc<AccountEventsEvent, AccountEventsState> {
  final DatabaseRepository db;
  final int paginationLimit = PAGINATION_LIMIT;
  String _accountID;

  AccountEventsBloc({@required this.db, @required accountID})
      : assert(db != null),
        super(AccountEventsStateFetching()) {
    this._accountID = accountID;
  } // AccountEventsBloc

  // Adds a debounce, to prevent the spamming of requesting events
  @override
  Stream<Transition<AccountEventsEvent, AccountEventsState>> transformEvents(
      Stream<AccountEventsEvent> events, transitionFn) {
    return super.transformEvents(
        events.debounceTime(const Duration(milliseconds: 0)), transitionFn);
  } // transformEvents

  @override
  Stream<AccountEventsState> mapEventToState(
      AccountEventsEvent accountEventsEvent,
      ) async* {
    // Fetch some events
    if (accountEventsEvent is AccountEventsEventFetch) {
      yield* _mapAccountEventsEventFetchToState();
    } // if

    // Reload the events list
    else if (accountEventsEvent is AccountEventsEventReload) {
      yield* _mapAccountEventsEventReloadToState();
    } // else if

    // Remove an event
    else if (accountEventsEvent is AccountEventsEventRemove) {
      yield* _mapAccountEventsEventRemoveToState(
          accountEventsEventRemove: accountEventsEvent);
    } // else if

    // The event added to the bloc has not associated state
    // either create one, or check the [account_events_state.dart]
    else {
      yield AccountEventsStateFailed();
    } // else
  } // mapEventToState

  Stream<AccountEventsState> _mapAccountEventsEventFetchToState() async* {
    final _currentState = this.state;
    bool _maxEvents = false;

    try {
      // No posts were fetched yet
      if (_currentState is AccountEventsStateFetching ||
          _currentState is AccountEventsStateFailed) {
        // Fetch the first [paginationLimit] number of events
        final List<QueryDocumentSnapshot> _docs =
        await _fetchEventsWithPagination(
          lastEvent: null,
          limit: paginationLimit,
        );

        // No events were retrieved on the FIRST retrieval, fail.
        if (_docs.isEmpty) {
          yield AccountEventsStateFailed();
          return;
        } // if

        // Map the events to a list of "Search Result Models"
        final List<SearchResultModel> _eventModels =
        _mapDocumentSnapshotsToSearchEventModels(docs: _docs);

        // The last remaining events where retrieved
        if (_eventModels.length != this.paginationLimit) {
          _maxEvents = true;
        } // if

        //
        yield AccountEventsStateSuccess(
          eventModels: _eventModels,
          maxEvents: _maxEvents,
          lastEvent: _docs.last,
          isFetching: false,
        );
      } // if

      // Posts were fetched already, now fetch [paginationLimit] more events.
      else if (_currentState is AccountEventsStateSuccess) {
        // Fetch the first [paginationLimit] number of events
        final List<QueryDocumentSnapshot> _docs =
        await _fetchEventsWithPagination(
            lastEvent: _currentState.lastEvent, limit: paginationLimit);

        // No event models were returned from the database
        //
        // Since events were already received, this means that all
        // events were retrieved from the database (maxEvents = true).
        if (_docs.isEmpty) {
          yield AccountEventsStateSuccess(
            eventModels: _currentState.eventModels,
            maxEvents: true,
            lastEvent: _currentState.lastEvent,
            isFetching: false,
          );
        } // if

        // At least 1 event was returned from the database, update
        // the AccountEventBloc's State by adding the new events.
        else {
          // Map the events to a list of "Search Result Models"
          final List<SearchResultModel> _eventModels =
          _mapDocumentSnapshotsToSearchEventModels(docs: _docs);

          // The last remaining events where retrieved
          if (_eventModels.length != this.paginationLimit) {
            _maxEvents = true;
          } // if

          yield AccountEventsStateSuccess(
            eventModels: _currentState.eventModels + _eventModels,
            maxEvents: _maxEvents,
            lastEvent: _docs?.last ?? _currentState.lastEvent,
            isFetching: false,
          );
        } // else
      } // if
    } catch (e) {
      yield AccountEventsStateFailed();
    } // catch
  } // _mapAccountEventsEventFetchToState

  Stream<AccountEventsState> _mapAccountEventsEventReloadToState() async* {
    final _currentState = this.state;
    bool _maxEvents = false;

    // Change "isFetching" to true, to show a
    // loading widget at the bottom of the list view.
    if (_currentState is AccountEventsStateSuccess) {
      yield AccountEventsStateSuccess(
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
        lastEvent: null,
        limit: paginationLimit,
      );

      // Failed Reload from a failed state
      if (_currentState is AccountEventsStateFailed && _docs.isEmpty) {
        yield AccountEventsStateReloadFailed();
        yield AccountEventsStateFailed();
        return;
      } // if

      // Map the events to a list of "Search Result Models"
      final List<SearchResultModel> _eventModels =
      _mapDocumentSnapshotsToSearchEventModels(docs: _docs);

      // The last remaining events where retrieved
      if (_eventModels.length != this.paginationLimit) {
        _maxEvents = true;
      } // if

      yield AccountEventsStateSuccess(
        eventModels: _eventModels,
        maxEvents: _maxEvents,
        lastEvent: _docs.last,
        isFetching: false,
      );
    } // try
    catch (e) {
      yield AccountEventsStateFailed();
    } // catch
  } // _mapAccountEventsEventReloadToState

  Stream<AccountEventsState> _mapAccountEventsEventRemoveToState(
      {@required AccountEventsEventRemove accountEventsEventRemove}) async* {
    final currentState = this.state;

    if (currentState is AccountEventsStateSuccess) {
      if (!currentState.isFetching) {
        // Set [isDeleting] true, but still emit a
        // success state since the event has yet to be deleted.
        //
        // UI should show a loading widget in the UI
        // to indicate that the deletion is in process.
        // Still emit a success state, so list view remains unchanged
        yield AccountEventsStateSuccess(
            eventModels: currentState.eventModels,
            lastEvent: currentState.lastEvent,
            maxEvents: currentState.maxEvents,
            isFetching: currentState.isFetching,
            isDeleting: true
        );

        // Remove event from "My Events" list view on the device
        if (currentState.eventModels.isNotEmpty) {
          currentState.eventModels.removeAt(accountEventsEventRemove.listIndex);
        }// if

        // Create a new reference, to force the list view to update
        List<SearchResultModel> newEventModelReference = [];
        if (currentState.eventModels.isNotEmpty) {
          newEventModelReference.addAll(currentState.eventModels);
        }// if

        // TODO: Enable this code to actually delete and event
        // // Remove image from storage
        // this.db.deleteImageFromStorage(
        //     eventID: accountEventsEventRemove.searchResultModel.eventId);
        //
        // // Remove from "search" collection
        // this.db.deleteNewEventFromSearchableCollection(
        //     documentReferenceID:
        //     accountEventsEventRemove.searchResultModel.searchID);
        //
        // // Remove from the "events" collection
        // this.db.deleteNewEventFromEventsCollection(
        //     documentReferenceID:
        //     accountEventsEventRemove.searchResultModel.eventId);

        // Deleted the last event (on the device)
        //
        // Show lonely panda image with a reload button,
        // just in case there's more events in the database
        if (newEventModelReference.isEmpty) {
          yield AccountEventsStateFailed();
        }// if

        // Set [isDeleting] false, as there are still events
        else {
          yield AccountEventsStateSuccess(
              eventModels: newEventModelReference,
              lastEvent: currentState.lastEvent,
              maxEvents: currentState.maxEvents,
              isFetching: currentState.isFetching,
              isDeleting: false
          );
        }// else
      }// if
    } // if
  } // _mapAccountEventsEventRemoveToState

  Future<List<QueryDocumentSnapshot>> _fetchEventsWithPagination(
      {@required QueryDocumentSnapshot lastEvent, @required int limit}) async {
    return db.searchEventsByAccount(
        accountID: this._accountID, lastEvent: lastEvent, limit: limit);
  } // _fetchEventsWithPagination

  /// Name: _mapDocumentSnapshotsToSearchEventModels
  ///
  /// Description: maps the document snapshot from firebase to the event model
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

        // DocumentId converted to [STRING] from [STRING] in firebase.
        newSearchID: doc.id ?? '',

        // AccountID converted to [STRING] from [STRING] in firebase.
        newAccountID: doc.data()[ATTRIBUTE_ACCOUNT_ID] ?? '',
      );
    }).toList();
  } // _mapDocumentSnapshotsToSearchEventModels

  @override
  void onChange(Change<AccountEventsState> change) {
    print('Account Events Bloc: $change');
    super.onChange(change);
  } // onChange

  @override
  Future<void> close() {
    print('Account Events Bloc Closed');
    return super.close();
  } // close
} // AccountEventsBloc
