import 'dart:async';
import 'package:rxdart/rxdart.dart';
import 'package:flutter/material.dart';
import 'package:communitytabs/logic/logic.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:database_repository/database_repository.dart';

class PinnedEventsBloc extends Bloc<PinnedEventsEvent, PinnedEventsState> {
  /// Used to retrieve a firebase document containing
  /// all pinned event document id's, belonging to this user.
  final String accountID;

  /// Database instance used to communicate with (in
  /// this case) Firebase Firestore and Firebase Storage.
  final DatabaseRepository db;

  /// Sets the limit on the max number of events retrieved in a query.
  final int _paginationLimit = PAGINATION_LIMIT;

  /// List containing all of the event document id's belonging to this user.
  PaginationEventsHandler _pinnedEventsHandler;

  PinnedEventsBloc({@required this.db, @required this.accountID})
      : assert(db != null),
        assert(accountID != null),
        super(PinnedEventsStateFetching());

  // Adds a debounce, to prevent the spamming of requesting events
  @override
  Stream<Transition<PinnedEventsEvent, PinnedEventsState>> transformEvents(Stream<PinnedEventsEvent> events, transitionFn) {
    return super.transformEvents(events.debounceTime(const Duration(milliseconds: 0)), transitionFn);
  } // transformEvents

  @override
  Stream<PinnedEventsState> mapEventToState(PinnedEventsEvent event) async* {
    // Fetch some events
    if (event is PinnedEventsEventFetch) {
      yield* _mapPinnedEventsEventFetchToState();
    } // if

    // Reload the events list
    else if (event is PinnedEventsEventReload) {
      yield* _mapPinnedEventsEventReloadToState();
    } // else if

    // The event added to the bloc has not associated state
    // either create one, or check the [account_events_state.dart]
    else {
      yield PinnedEventsStateFailed("[PinnedEventsBloc] Invalid event received");
    } // else
  } // mapEventToState

  Stream<PinnedEventsState> _mapPinnedEventsEventFetchToState() async* {
    final _currentState = this.state;
    bool _maxEvents = false;

    try {
      /// No posts were fetched yet
      ///
      /// Initial state was fetching, user tried to fetch events from a failed state
      if (_currentState is PinnedEventsStateFetching || _currentState is PinnedEventsStateFailed) {
        await this._getListOfPinnedEvents();

        /// Fail, since no document id's are listed in the user's createEvent doc.
        if (this._pinnedEventsHandler.isEmpty()) {
          yield PinnedEventsStateFailed("[Account Events State Failed] Account events doc has no events!");
          return;
        } // if

        /// Get the first [paginationLimit] number of event id's from the [AccountEventsHandler]
        final List<String> _ids = this._pinnedEventsHandler.getEventIdsPaginated(this._paginationLimit);
        final List<DocumentSnapshot> _docs = await this._fetchPinnedEventsPaginated(eventIdsToFetch: _ids);

        /// No events were retrieved on the FIRST retrieval, fail.
        if (_docs.isEmpty) {
          yield PinnedEventsStateFailed("[Account Events State Failed] Failed to fetch the first ${this._paginationLimit} based on the account events doc!");
          return;
        } // if

        /// Map the events to a list of "Search Result Models"
        final List<SearchResultModel> _eventModels = _mapDocumentSnapshotsToSearchEventModels(docs: _docs);

        /// The last remaining events where retrieved
        if (_eventModels.length != this._paginationLimit) {
          _maxEvents = true;
        } // if

        /// First fetch, all good!
        yield PinnedEventsStateSuccess(
          eventModels: _eventModels,
          maxEvents: _maxEvents,
          lastEvent: _docs.last,
          isFetching: false,
        );
      } // if

      // Posts were fetched already, now fetch [paginationLimit] more events.
      else if (_currentState is PinnedEventsStateSuccess) {
        /// Get the next [paginationLimit] number of event id's from the [AccountEventsHandler]
        final List<String> _ids = this._pinnedEventsHandler.getEventIdsPaginated(this._paginationLimit);

        /// No event models were returned from the database
        ///
        /// Since events were already received, this means that all
        /// events were retrieved from the database (maxEvents = true).
        if (_ids.isEmpty) {
          yield PinnedEventsStateSuccess(
            eventModels: _currentState.eventModels,
            maxEvents: true,
            lastEvent: _currentState.lastEvent,
            isFetching: false,
          );
        } // if

        final List<DocumentSnapshot> _docs = await this._fetchPinnedEventsPaginated(eventIdsToFetch: _ids);

        /// No events were retrieved on the FIRST retrieval, fail.
        if (_docs.isEmpty) {
          yield PinnedEventsStateSuccess(
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

        yield PinnedEventsStateSuccess(
          eventModels: _currentState.eventModels + _eventModels,
          maxEvents: _maxEvents,
          lastEvent: _docs?.last ?? _currentState.lastEvent,
          isFetching: false,
        );
      } // else if
    } catch (e) {
      yield PinnedEventsStateFailed(e.toString());
    } // catch
  } // _mapPinnedEventsEventFetchToState

  Stream<PinnedEventsState> _mapPinnedEventsEventReloadToState() async* {
    final _currentState = this.state;
    bool _maxEvents = false;

    /// Change "isFetching" to true, to show a
    /// loading widget at the bottom of the list view.
    if (_currentState is PinnedEventsStateSuccess) {
      yield PinnedEventsStateSuccess(
        eventModels: _currentState.eventModels,
        maxEvents: _currentState.maxEvents,
        lastEvent: _currentState.lastEvent,
        isFetching: true,
      );
    } // if

    try {
      // User is fetching events from a failed state
      if (!(_currentState is PinnedEventsStateFetching) && !(_currentState is PinnedEventsStateSuccess)) {
        yield PinnedEventsStateFetching();
        // Retry will fail to quickly,
        //
        // Give the user a good feeling that events are actually being searched for.
        await Future.delayed(Duration(milliseconds: 350));
      } // if

      /// Get user's created events document that lists
      /// all of the event id's that belong to this user.
      this._getListOfPinnedEvents();

      /// Fail, since no document id's are listed in the user's createEvent doc.
      if (this._pinnedEventsHandler.isEmpty()) {
        yield PinnedEventsStateFailed("[Account Events State Failed] Account events doc has no events!");
        return;
      } // if

      /// Get the first [paginationLimit] number of event id's from the [AccountEventsHandler]
      final List<String> _ids = this._pinnedEventsHandler.getEventIdsPaginated(this._paginationLimit);
      final List<DocumentSnapshot> _docs = await this._fetchPinnedEventsPaginated(eventIdsToFetch: _ids);

      if (_currentState is PinnedEventsStateFailed) {
        yield PinnedEventsStateReloadFailed();
      } // if

      /// No events were retrieved on the FIRST retrieval, fail.
      if (_docs.isEmpty) {
        yield PinnedEventsStateFailed("No events retrieved");
        return;
      }// if

      // Map the events to a list of "Search Result Models"
      final List<SearchResultModel> _eventModels = _mapDocumentSnapshotsToSearchEventModels(docs: _docs);

      // The last remaining events where retrieved
      if (_eventModels.length != this._paginationLimit) {
        _maxEvents = true;
      } // if

      yield PinnedEventsStateSuccess(
        eventModels: _eventModels,
        maxEvents: _maxEvents,
        lastEvent: _docs.last,
        isFetching: false,
      );
    } // try
    catch (e) {
      yield PinnedEventsStateFailed(e.toString());
    } // catch
  } // _mapPinnedEventsEventReloadToState

  /// Get user's created events document that lists
  /// all of the event id's that belong to this user.
  Future<void> _getListOfPinnedEvents () async {
    final DocumentSnapshot docSnap = await this.db.getAccountPinnedEvents(uid: this.accountID);

    final List<String> eventIds = [];
    try {
      final Map m = docSnap.data() as Map;
      m.forEach((attribute, boolVal) {
        if (attribute is String) {
          if (attribute != ATTRIBUTE_PIN_COUNT) {
            eventIds.add(attribute);
          } // if
        } // if
      });
    } // try
    catch (e) {} //catch

    this._pinnedEventsHandler = PaginationEventsHandler(eventIds);
  }// getListOfPinnedEvents

  Future<List<DocumentSnapshot>> _fetchPinnedEventsPaginated ({@required eventIdsToFetch}) async {
    /// Fetch the first [paginationLimit] number of events
    final List<DocumentSnapshot> _docs = await Future.microtask(() async {
      try {
        final List<DocumentSnapshot> _tempDocs = [];
        for (int i = 0; i < eventIdsToFetch.length; ++i) {
          final DocumentSnapshot docSnap = await this.db.getSearchEventById(eventId: eventIdsToFetch[i]);
          if (docSnap != null) {
            _tempDocs.add(docSnap);
          } // if
        } // for
        return _tempDocs;
      }// try
      catch(error) {
        return [];
      }// catch
    });

    return _docs;
  }// _fetchPinnedEventsPaginated

  /// Name: _mapDocumentSnapshotsToSearchEventModels
  ///
  /// Description: maps the document snapshot from firebase to the event model
  List<SearchResultModel> _mapDocumentSnapshotsToSearchEventModels({@required List<DocumentSnapshot> docs}) {
    return docs.map((doc) {
      Map<String, dynamic> docAsMap = doc.data() as Map;

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

  get pinnedEvents => this._pinnedEventsHandler != null ? this._pinnedEventsHandler.eventIds : null;
}// PinnedEventsBloc
