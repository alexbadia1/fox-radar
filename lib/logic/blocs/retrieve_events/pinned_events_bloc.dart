import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:fox_radar/logic/logic.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:database_repository/database_repository.dart';

class PinnedEventsBloc extends Bloc<PinnedEventsEvent, PinnedEventsState> {
  /// Used to retrieve a firebase document containing
  /// all pinned event document id's, belonging to this user.
  late final String accountID;

  /// Database instance used to communicate with (in
  /// this case) Firebase Firestore and Firebase Storage.
  late final DatabaseRepository db;

  /// Sets the limit on the max number of events retrieved in a query.
  final int _paginationLimit = PAGINATION_LIMIT;

  /// List containing all of the event document id's belonging to this user.
  late PaginationEventsHandler _pinnedEventsHandler;

  PinnedEventsBloc({required this.db, required this.accountID})
      : super(PinnedEventsStateFetching()) {
    on<PinnedEventsEventFetch>(_mapPinnedEventsEventFetchToState);
    on<PinnedEventsEventReload>(_mapPinnedEventsEventReloadToState);
    on<PinnedEventsEventPin>(_mapPinnedEventsEventPinToState);
    on<PinnedEventsEventUnpin>(_mapPinnedEventsEventUnpinToState);
    on<PinnedEventsEventSort>(_mapPinnedEventsEventSortToState);
  }

  void _mapPinnedEventsEventFetchToState(
    PinnedEventsEventFetch event,
    Emitter<PinnedEventsState> emitter,
  ) async {
    final _currentState = this.state;
    bool _maxEvents = false;

    try {
      /// No posts were fetched yet
      ///
      /// Initial state was fetching, user tried to fetch events from a failed state
      if (_currentState is PinnedEventsStateFetching ||
          _currentState is PinnedEventsStateFailed) {
        await this._getListOfPinnedEvents();

        /// Fail, since no document id's are listed in the user's createEvent doc.
        if (this._pinnedEventsHandler.isEmpty()) {
          emitter(
            PinnedEventsStateFailed(
                "[Account Events State Failed] Account events doc has no events!"),
          );
          return;
        }

        /// Get the first [paginationLimit] number of event id's from the [AccountEventsHandler]
        final List<String> _ids = this
            ._pinnedEventsHandler
            .getEventIdsPaginated(this._paginationLimit);
        final List<DocumentSnapshot> _docs =
            await this._fetchPinnedEventsPaginated(eventIdsToFetch: _ids);

        /// No events were retrieved on the FIRST retrieval, fail.
        if (_docs.isEmpty) {
          emitter(
            PinnedEventsStateFailed(
                "[Account Events State Failed] Failed to fetch the first ${this._paginationLimit} based on the account events doc!"),
          );
          return;
        }

        /// Map the events to a list of "Search Result Models"
        final List<SearchResultModel> _eventModels =
            _mapDocumentSnapshotsToSearchEventModels(docs: _docs);

        /// The last remaining events where retrieved
        if (_eventModels.length != this._paginationLimit) {
          _maxEvents = true;
        }

        /// First fetch, all good!
        emitter(
          PinnedEventsStateSuccess(
            eventModels: _eventModels,
            maxEvents: _maxEvents,
            lastEvent: _docs.last,
            isFetching: false,
          ),
        );
      }

      // Posts were fetched already, now fetch [paginationLimit] more events.
      else if (_currentState is PinnedEventsStateSuccess) {
        /// Get the next [paginationLimit] number of event id's from the [AccountEventsHandler]
        final List<String> _ids = this
            ._pinnedEventsHandler
            .getEventIdsPaginated(this._paginationLimit);

        /// No event models were returned from the database
        ///
        /// Since events were already received, this means that all
        /// events were retrieved from the database (maxEvents = true).
        if (_ids.isEmpty) {
          emitter(
            PinnedEventsStateSuccess(
              eventModels: _currentState.eventModels,
              maxEvents: true,
              lastEvent: _currentState.lastEvent,
              isFetching: false,
            ),
          );
        } // if

        final List<DocumentSnapshot> _docs =
            await this._fetchPinnedEventsPaginated(eventIdsToFetch: _ids);

        /// No events were retrieved on the FIRST retrieval, fail.
        if (_docs.isEmpty) {
          emitter(
            PinnedEventsStateSuccess(
              eventModels: _currentState.eventModels,
              maxEvents: true,
              lastEvent: _currentState.lastEvent,
              isFetching: false,
            ),
          );
          return;
        }

        /// At least 1 event was returned from the database, update
        /// the AccountEventBloc's State by adding the new events.
        /// Map the events to a list of "Search Result Models"
        final List<SearchResultModel> _eventModels =
            _mapDocumentSnapshotsToSearchEventModels(docs: _docs);

        /// The last remaining events where retrieved
        if (_eventModels.length != this._paginationLimit) {
          _maxEvents = true;
        }

        emitter(
          PinnedEventsStateSuccess(
            eventModels: _currentState.eventModels + _eventModels,
            maxEvents: _maxEvents,
            lastEvent: _docs?.last ?? _currentState.lastEvent,
            isFetching: false,
          ),
        );
      }
    } catch (e) {
      emitter(
        PinnedEventsStateFailed(e.toString()),
      );
    }
  }

  void _mapPinnedEventsEventReloadToState(
    PinnedEventsEventReload event,
    Emitter<PinnedEventsState> emitter,
  ) async {
    final _currentState = this.state;
    bool _maxEvents = false;

    /// Change "isFetching" to true, to show a
    /// loading widget at the bottom of the list view.
    if (_currentState is PinnedEventsStateSuccess) {
      emitter(
        PinnedEventsStateSuccess(
          eventModels: _currentState.eventModels,
          maxEvents: _currentState.maxEvents,
          lastEvent: _currentState.lastEvent,
          isFetching: true,
        ),
      );
    }

    try {
      // User is fetching events from a failed state
      if (!(_currentState is PinnedEventsStateFetching) &&
          !(_currentState is PinnedEventsStateSuccess)) {
        emitter(PinnedEventsStateFetching());
        // Retry will fail to quickly,
        //
        // Give the user a good feeling that events are actually being searched for.
        await Future.delayed(Duration(milliseconds: 350));
      }

      /// Get user's created events document that lists
      /// all of the event id's that belong to this user.
      await this._getListOfPinnedEvents();

      /// Fail, since no document id's are listed in the user's createEvent doc.
      if (this._pinnedEventsHandler.isEmpty()) {
        emitter(
          PinnedEventsStateFailed(
              "[Pinned Events State Failed] Pinned events doc has no events!"),
        );
        return;
      }

      /// Get the first [paginationLimit] number of event id's from the [AccountEventsHandler]
      final List<String> _ids =
          this._pinnedEventsHandler.getEventIdsPaginated(this._paginationLimit);
      final List<DocumentSnapshot> _docs =
          await this._fetchPinnedEventsPaginated(eventIdsToFetch: _ids);

      if (_currentState is PinnedEventsStateFailed) {
        emitter(PinnedEventsStateReloadFailed());
      }

      /// No events were retrieved on the FIRST retrieval, fail.
      if (_docs.isEmpty) {
        emitter(PinnedEventsStateFailed("No events retrieved"));
        return;
      }

      // Map the events to a list of "Search Result Models"
      final List<SearchResultModel> _eventModels =
          _mapDocumentSnapshotsToSearchEventModels(docs: _docs);

      // The last remaining events where retrieved
      if (_eventModels.length != this._paginationLimit) {
        _maxEvents = true;
      }
      emitter(
        PinnedEventsStateSuccess(
          eventModels: _eventModels,
          maxEvents: _maxEvents,
          lastEvent: _docs.last,
          isFetching: false,
        ),
      );
    } catch (e) {
      emitter(PinnedEventsStateFailed(e.toString()));
    }
  }

  /// Get user's created events document that lists
  /// all of the event id's that belong to this user.
  Future<void> _getListOfPinnedEvents() async {
    final DocumentSnapshot? docSnap =
        await this.db.getAccountPinnedEvents(uid: this.accountID);

    final List<String> eventIds = [];
    try {
      final Map m = docSnap?.data() as Map;
      m.forEach((attribute, boolVal) {
        if (attribute is String) {
          eventIds.add(attribute);
        } // if
      });
    } // try
    catch (e) {} //catch

    this._pinnedEventsHandler = PaginationEventsHandler(eventIds);
  } // getListOfPinnedEvents

  Future<List<DocumentSnapshot>> _fetchPinnedEventsPaginated(
      {@required eventIdsToFetch}) async {
    /// Fetch the first [paginationLimit] number of events
    final List<DocumentSnapshot> _docs = await Future.microtask(() async {
      try {
        final List<DocumentSnapshot> _tempDocs = [];
        for (int i = 0; i < eventIdsToFetch.length; ++i) {
          final DocumentSnapshot? docSnap =
              await this.db.getSearchEventById(eventId: eventIdsToFetch[i]);
          if (docSnap != null) {
            _tempDocs.add(docSnap);
          } // if

          else {
            // TODO: Tell user the event was deleted somehow

            // Delete event, but don't wait for it to complete
            // this.db.unpinEvent(eventIdsToFetch[i], this.accountID);
          } // else
        } // for
        return _tempDocs;
      } // try
      catch (error) {
        return [];
      } // catch
    });

    return _docs;
  } // _fetchPinnedEventsPaginated

  /// Name: _mapDocumentSnapshotsToSearchEventModels
  ///
  /// Description: maps the document snapshot from firebase to the event model
  List<SearchResultModel> _mapDocumentSnapshotsToSearchEventModels(
      {required List<DocumentSnapshot> docs}) {
    return docs.map((doc) {
      Map<String, dynamic> docAsMap = doc.data() as Map<String, dynamic>;

      // Convert the firebase timestamp to a DateTime
      DateTime? tempRawStartDateAndTimeToDateTime;
      Timestamp? _startTimestamp = docAsMap[ATTRIBUTE_RAW_START_DATE_TIME];
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
  }

  List<String>? get pinnedEvents => this._pinnedEventsHandler != null
      ? this._pinnedEventsHandler.eventIds
      : null;

  void _mapPinnedEventsEventPinToState(
    PinnedEventsEventPin event,
    Emitter<PinnedEventsState> emitter,
  ) async {
    String? newEventID = event.eventId;

    if (this.pinnedEvents == null) {
      return;
    }
    if (newEventID == null) {
      return;
    }
    if (newEventID.isNotEmpty) {
      this.pinnedEvents?.add(newEventID);
      await this.db.pinEvent(newEventID, this.accountID);
      this.add(PinnedEventsEventReload());
    }
  }

  void _mapPinnedEventsEventUnpinToState(
    PinnedEventsEventUnpin event,
    Emitter<PinnedEventsState> emitter,
  ) async {
    String? newEventID = event.eventId;

    final currState = this.state;

    if (this.pinnedEvents == null) {
      return;
    }

    if (newEventID == null) {
      return;
    }

    if (newEventID.isNotEmpty) {
      this.pinnedEvents?.remove(newEventID);
      await this.db.unpinEvent(newEventID, this.accountID);
      // Not last event
      if (this.pinnedEvents!.isNotEmpty &&
          currState is PinnedEventsStateSuccess) {
        currState.eventModels
            .removeWhere((element) => element.eventId == newEventID);
        emitter(
          PinnedEventsStateSuccess(
            eventModels: currState.eventModels,
            lastEvent: currState.lastEvent,
            maxEvents: currState.maxEvents,
            isFetching: currState.isFetching,
          ),
        );
      } else {
        emitter(PinnedEventsStateFailed("Unpinned last event"));
      }
    }
  }

  void _mapPinnedEventsEventSortToState(
    PinnedEventsEventSort event,
    Emitter<PinnedEventsState> emitter,
  ) async {
    String sortKey = event.sortKey;

    final currState = this.state;

    // Only sort if there are actually events to sort
    if (currState is PinnedEventsStateSuccess) {
      // Used to pass multiple arguments to a function on another isolate
      Map argsForCompute = {
        "SearchResultModels": currState.eventModels,
        "SortKey": sortKey,
      };

      // A new list reference should for listeners to update
      List<SearchResultModel> sortedSearchResults = [];

      // Too many events to sort on the main thread
      if (currState.eventModels.length >= 50) {
        sortedSearchResults =
            await compute(sortSearchEventModels, argsForCompute);
      } else {
        sortedSearchResults = await sortSearchEventModels(argsForCompute);
      }

      // Send sorted list to the UI
      emitter(
        PinnedEventsStateSuccess(
          eventModels: sortedSearchResults,
          lastEvent: currState.lastEvent,
          maxEvents: currState.maxEvents,
          isFetching: currState.isFetching,
        ),
      );
    }
  }

  static Future<List<SearchResultModel>> sortSearchEventModels(Map args) async {
    // Parse arguments, just in case this is run on another isolate
    final String sortKey = args['SortKey'];
    final List<SearchResultModel> searchResultModels =
        args['SearchResultModels'];

    try {
      switch (sortKey) {
        case SORT_KEY_ALPHABETICAL:
          searchResultModels.sort((a, b) => a.title!.compareTo(b.title!));
          break;
        default: // Default to sort by time
          searchResultModels.sort((a, b) =>
              a.rawStartDateAndTime!.compareTo(b.rawStartDateAndTime!));
          break;
      }
    } catch (error) {}

    // Returns the sorted search results, if the
    // sort failed it should be the original list.
    return searchResultModels;
  }
}
