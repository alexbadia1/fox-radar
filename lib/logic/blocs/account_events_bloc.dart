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
  /// Used to retrieve a firebase document containing
  /// all of the event document id's, belonging to this user.
  final String accountID;

  /// Database instance used to communicate with (in
  /// this case) Firebase Firestore and Firebase Storage.
  final DatabaseRepository db;

  /// Sets the limit on the max number of events retrieved in a query.
  final int _paginationLimit = PAGINATION_LIMIT;

  /// List containing all of the event document id's belonging to this user.
  PaginationEventsHandler _accountEventsHandler;

  AccountEventsBloc({@required this.db, @required this.accountID})
      : assert(db != null),
        assert(accountID != null),
        super(AccountEventsStateFetching());

  // Adds a debounce, to prevent the spamming of requesting events
  @override
  Stream<Transition<AccountEventsEvent, AccountEventsState>> transformEvents(Stream<AccountEventsEvent> events, transitionFn) {
    return super.transformEvents(events.debounceTime(const Duration(milliseconds: 0)), transitionFn);
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
      yield* _mapAccountEventsEventRemoveToState(accountEventsEventRemove: accountEventsEvent);
    } // else if

    // The event added to the bloc has not associated state
    // either create one, or check the [account_events_state.dart]
    else {
      yield AccountEventsStateFailed("[AccountEventsBloc] Invalid event received");
    } // else
  } // mapEventToState

  Stream<AccountEventsState> _mapAccountEventsEventFetchToState() async* {
    final _currentState = this.state;
    bool _maxEvents = false;

    try {
      /// No posts were fetched yet
      ///
      /// Initial state was fetching, user tried to fetch events from a failed state
      if (_currentState is AccountEventsStateFetching || _currentState is AccountEventsStateFailed) {

        /// Get user's created events document that lists
        /// all of the event id's that belong to this user.
        await this._getListOfAccountEvents();

        /// Fail, since no document id's are listed in the user's createEvent doc.
        if (this._accountEventsHandler.isEmpty()) {
          yield AccountEventsStateFailed("[Account Events State Failed] Account events doc has no events!");
          return;
        } // if

        /// Get the first [paginationLimit] number of event id's from the [AccountEventsHandler]
        final List<String> _eventIdsToFetch = this._accountEventsHandler.getEventIdsPaginated(this._paginationLimit);

        /// Fetch the first [paginationLimit] number of events
        final List<DocumentSnapshot> _docs = [];
        for (int i = 0; i < _eventIdsToFetch.length; ++i) {
          final DocumentSnapshot docSnap = await this.db.getSearchEventById(eventId: _eventIdsToFetch[i]);
          if (docSnap != null) {
            _docs.add(docSnap);
          }// if
        }// for
        
        /// No events were retrieved on the FIRST retrieval, fail.
        if (_docs.isEmpty) {
          yield AccountEventsStateFailed("[Account Events State Failed] Failed to fetch the first ${this._paginationLimit} based on the account events doc!");
          return;
        } // if

        /// Map the events to a list of "Search Result Models"
        final List<SearchResultModel> _eventModels = _mapDocumentSnapshotsToSearchEventModels(docs: _docs);

        /// The last remaining events where retrieved
        if (_eventModels.length != this._paginationLimit) {
          _maxEvents = true;
        } // if

        /// First fetch, all good!
        yield AccountEventsStateSuccess(
          eventModels: _eventModels,
          maxEvents: _maxEvents,
          lastEvent: _docs.last,
          isFetching: false,
        );
      } // if

      // Posts were fetched already, now fetch [paginationLimit] more events.
      else if (_currentState is AccountEventsStateSuccess) {
        /// Get the next [paginationLimit] number of event id's from the [AccountEventsHandler]
        final List<String> _eventIdsToFetch = this._accountEventsHandler.getEventIdsPaginated(this._paginationLimit);

        /// No event models were returned from the database
        ///
        /// Since events were already received, this means that all
        /// events were retrieved from the database (maxEvents = true).
        if (_eventIdsToFetch.isEmpty) {
          yield AccountEventsStateSuccess(
            eventModels: _currentState.eventModels,
            maxEvents: true,
            lastEvent: _currentState.lastEvent,
            isFetching: false,
          );
        } // if

        /// Fetch the next [paginationLimit] number of events
        final List<DocumentSnapshot> _docs = [];
        for (int i = 0; i < _eventIdsToFetch.length; ++i) {
          final DocumentSnapshot docSnap = await this.db.getSearchEventById(eventId: _eventIdsToFetch[i]);
          if (docSnap != null) {
            _docs.add(docSnap);
          }// if
        }// for

        /// No events were retrieved on the FIRST retrieval, fail.
        if (_docs.isEmpty) {
          yield AccountEventsStateSuccess(
            eventModels: _currentState.eventModels,
            maxEvents: true,
            lastEvent: _currentState.lastEvent,
            isFetching: false,
          );
          return;
        } // if

        /// At least 1 event was returned from the database, update
        /// the AccountEventBloc's State by adding the new events.
        /// Map the events to a list of "Search Result Models"
        final List<SearchResultModel> _eventModels = _mapDocumentSnapshotsToSearchEventModels(docs: _docs);

        /// The last remaining events where retrieved
        if (_eventModels.length != this._paginationLimit) {
          _maxEvents = true;
        } // if

        yield AccountEventsStateSuccess(
          eventModels: _currentState.eventModels + _eventModels,
          maxEvents: _maxEvents,
          lastEvent: _docs?.last ?? _currentState.lastEvent,
          isFetching: false,
        );
      } // else if
    } catch (e) {
      print(e);
      yield AccountEventsStateFailed(e.toString());
    } // catch
  } // _mapAccountEventsEventFetchToState

  Stream<AccountEventsState> _mapAccountEventsEventReloadToState() async* {
    final _currentState = this.state;
    bool _maxEvents = false;

    /// Change "isFetching" to true, to show a
    /// loading widget at the bottom of the list view.
    if (_currentState is AccountEventsStateSuccess) {
      yield AccountEventsStateSuccess(
        eventModels: _currentState.eventModels,
        maxEvents: _currentState.maxEvents,
        lastEvent: _currentState.lastEvent,
        isFetching: true,
      );
    } // if

    try {
      // User is fetching events from a failed state
      if (!(_currentState is AccountEventsStateFetching) && !(_currentState is AccountEventsStateSuccess)) {
        yield AccountEventsStateFetching();
        // Retry will fail to quickly,
        //
        // Give the user a good feeling that events are actually being searched for.
        await Future.delayed(Duration(milliseconds: 350));
      } // if

      /// Get user's created events document that lists
      /// all of the event id's that belong to this user.
      await this._getListOfAccountEvents();

      /// Fail, since no document id's are listed in the user's createEvent doc.
      if (this._accountEventsHandler.isEmpty()) {
        yield AccountEventsStateFailed("Account ID Doc doesn't list any events");
        return;
      } // if

      /// Get the first [paginationLimit] number of event id's from the [AccountEventsHandler]
      final List<String> _eventIdsToFetch = this._accountEventsHandler.getEventIdsPaginated(this._paginationLimit);

      /// Fetch the first [paginationLimit] number of events
      final List<DocumentSnapshot> _docs = [];
      for (int i = 0; i < _eventIdsToFetch.length; ++i) {
        final DocumentSnapshot docSnap = await this.db.getSearchEventById(eventId: _eventIdsToFetch[i]);
        if (docSnap != null) {
          _docs.add(docSnap);
        }// if
      }// for

      if (_currentState is AccountEventsStateFailed) {
        yield AccountEventsStateReloadFailed();
      } // if

      // No events were retrieved on the FIRST retrieval, fail.
      if (_docs.isEmpty) {
        yield AccountEventsStateFailed("No events retrieved");
        return;
      }// if

      // Map the events to a list of "Search Result Models"
      final List<SearchResultModel> _eventModels = _mapDocumentSnapshotsToSearchEventModels(docs: _docs);

      // The last remaining events where retrieved
      if (_eventModels.length != this._paginationLimit) {
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
      yield AccountEventsStateFailed(e.toString());
    } // catch
  } // _mapAccountEventsEventReloadToState

  Stream<AccountEventsState> _mapAccountEventsEventRemoveToState({@required AccountEventsEventRemove accountEventsEventRemove}) async* {
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
            isDeleting: true);

        // Remove event from "My Events" list view on the device
        if (currentState.eventModels.isNotEmpty) {
          currentState.eventModels.removeAt(accountEventsEventRemove.listIndex);
        } // if

        // Create a new reference, to force the list view to update
        List<SearchResultModel> newEventModelReference = [];
        if (currentState.eventModels.isNotEmpty) {
          newEventModelReference.addAll(currentState.eventModels);
        } // if

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
          yield AccountEventsStateFailed("Deleted the last event");
        } // if

        // Set [isDeleting] false, as there are still events
        else {
          yield AccountEventsStateSuccess(
              eventModels: newEventModelReference,
              lastEvent: currentState.lastEvent,
              maxEvents: currentState.maxEvents,
              isFetching: currentState.isFetching,
              isDeleting: false);
        } // else
      } // if
    } // if
  } // _mapAccountEventsEventRemoveToState

  Future<void> _getListOfAccountEvents () async {
    final DocumentSnapshot docSnap = await this.db.getAccountCreatedEvents(uid: this.accountID);

    final List<String> eventIds = [];
    try {
      final Map m = docSnap.data() as Map;
      m.forEach((attribute, boolVal) {
        if (attribute is String) {
            eventIds.add(attribute);
        } // if
      });
    } // try
    catch (e) {
      print(e);
    } //catch

    this._accountEventsHandler = PaginationEventsHandler(eventIds);
  }// getListOfPinnedEvents

  /// Name: _mapDocumentSnapshotsToSearchEventModels
  ///
  /// Description: maps the document snapshot from firebase to the event model
  List<SearchResultModel> _mapDocumentSnapshotsToSearchEventModels({@required List<DocumentSnapshot> docs}) {
    return docs.map((doc) {
      Map<String, dynamic> docAsMap = doc.data();

      // Convert the firebase timestamp to a DateTime
      DateTime tempRawStartDateAndTimeToDateTime;
      Timestamp _startTimestamp = docAsMap[ATTRIBUTE_RAW_START_DATE_TIME];
      if (_startTimestamp != null) {
        tempRawStartDateAndTimeToDateTime = DateTime.fromMillisecondsSinceEpoch(_startTimestamp.millisecondsSinceEpoch).toUtc().toLocal();
      } // if
      else {
        tempRawStartDateAndTimeToDateTime = null;
      } // else

      return SearchResultModel(
        // Title converted to [STRING] from [STRING] in Firebase.
        newTitle: docAsMap[ATTRIBUTE_TITLE] ?? '',

        // Host converted to [STRING] from [STRING] in Firebase.
        newHost: docAsMap[ATTRIBUTE_HOST] ?? '',

        // Location Converted to [] from [] in Firebase.
        newLocation: docAsMap[ATTRIBUTE_LOCATION] ?? '',

        // RawStartDate converted to [DATETIME] from [TIMESTAMP] in Firebase.
        newRawStartDateAndTime: tempRawStartDateAndTimeToDateTime ?? null,

        // Category converted to [STRING] from [STRING] in Firebase.
        newCategory: docAsMap[ATTRIBUTE_CATEGORY] ?? '',

        // Implement Firebase Images.
        newImageFitCover: docAsMap[ATTRIBUTE_IMAGE_FIT_COVER] ?? true,

        // Doc ID is the same as the event ID
        newEventId: doc.id ?? '',
      );
    }).toList();
  } // _mapDocumentSnapshotsToSearchEventModels
} // AccountEventsBloc
