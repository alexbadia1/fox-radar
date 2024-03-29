import 'dart:async';
import 'package:fox_radar/logic/logic.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:database_repository/database_repository.dart';

class AccountEventsBloc extends Bloc<AccountEventsEvent, AccountEventsState> {
  /// Used to retrieve a firebase document containing
  /// all of the event document id's, belonging to this user.
  final String? accountID;

  /// Database instance used to communicate with (in
  /// this case) Firebase Firestore and Firebase Storage.
  late final DatabaseRepository db;

  /// Sets the limit on the max number of events retrieved in a query.
  final int _paginationLimit = PAGINATION_LIMIT;

  /// List containing all of the event document id's belonging to this user.
  late PaginationEventsHandler _accountEventsHandler;

  AccountEventsBloc({required this.db, required this.accountID})
      : super(AccountEventsStateFetching()) {
    on<AccountEventsEvent>(_mapAccountEventsEventFetchToState);
    on<AccountEventsEventReload>(_mapAccountEventsEventReloadToState);
    on<AccountEventsEventRemove>(_mapAccountEventsEventRemoveToState);
  }

  void _mapAccountEventsEventFetchToState(
    AccountEventsEvent event,
    Emitter<AccountEventsState> emitter,
  ) async {
    final _currentState = this.state;
    bool _maxEvents = false;

    try {
      /// No posts were fetched yet
      ///
      /// Initial state was fetching, user tried to fetch events from a failed state
      if (_currentState is AccountEventsStateFetching ||
          _currentState is AccountEventsStateFailed) {
        /// Get user's created events document that lists
        /// all of the event id's that belong to this user.
        await this._getListOfAccountEvents();

        /// Fail, since no document id's are listed in the user's createEvent doc.
        if (this._accountEventsHandler.isEmpty()) {
          emitter(
            AccountEventsStateFailed(
                "[Account Events State Failed] Account events doc has no events!"),
          );
          return;
        }

        /// Get the first [paginationLimit] number of event id's from the [AccountEventsHandler]
        final List<String> _eventIdsToFetch = this
            ._accountEventsHandler
            .getEventIdsPaginated(this._paginationLimit);

        /// Fetch the first [paginationLimit] number of events
        final List<DocumentSnapshot> _docs = [];
        for (int i = 0; i < _eventIdsToFetch.length; ++i) {
          final DocumentSnapshot? docSnap =
              await this.db.getSearchEventById(eventId: _eventIdsToFetch[i]);
          if (docSnap != null) {
            _docs.add(docSnap);
          }
        }

        /// No events were retrieved on the FIRST retrieval, fail.
        if (_docs.isEmpty) {
          emitter(
            AccountEventsStateFailed(
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
          AccountEventsStateSuccess(
            eventModels: _eventModels,
            maxEvents: _maxEvents,
            lastEvent: _docs.last,
            isFetching: false,
          ),
        );
      }

      // Posts were fetched already, now fetch [paginationLimit] more events.
      else if (_currentState is AccountEventsStateSuccess) {
        /// Get the next [paginationLimit] number of event id's from the [AccountEventsHandler]
        final List<String> _eventIdsToFetch = this
            ._accountEventsHandler
            .getEventIdsPaginated(this._paginationLimit);

        /// No event models were returned from the database
        ///
        /// Since events were already received, this means that all
        /// events were retrieved from the database (maxEvents = true).
        if (_eventIdsToFetch.isEmpty) {
          emitter(
            AccountEventsStateSuccess(
              eventModels: _currentState.eventModels,
              maxEvents: true,
              lastEvent: _currentState.lastEvent,
              isFetching: false,
            ),
          );
        }

        /// Fetch the next [paginationLimit] number of events
        final List<DocumentSnapshot> _docs = [];
        for (int i = 0; i < _eventIdsToFetch.length; ++i) {
          final DocumentSnapshot? docSnap =
              await this.db.getSearchEventById(eventId: _eventIdsToFetch[i]);
          if (docSnap != null) {
            _docs.add(docSnap);
          } // if
        } // for

        /// No events were retrieved on the FIRST retrieval, fail.
        if (_docs.isEmpty) {
          emitter(
            AccountEventsStateSuccess(
              eventModels: _currentState.eventModels,
              maxEvents: true,
              lastEvent: _currentState.lastEvent,
              isFetching: false,
            ),
          );
          return;
        } // if

        /// At least 1 event was returned from the database, update
        /// the AccountEventBloc's State by adding the new events.
        /// Map the events to a list of "Search Result Models"
        final List<SearchResultModel> _eventModels =
            _mapDocumentSnapshotsToSearchEventModels(docs: _docs);

        /// The last remaining events where retrieved
        if (_eventModels.length != this._paginationLimit) {
          _maxEvents = true;
        } // if

        emitter(
          AccountEventsStateSuccess(
            eventModels: _currentState.eventModels + _eventModels,
            maxEvents: _maxEvents,
            lastEvent: _docs?.last ?? _currentState.lastEvent,
            isFetching: false,
          ),
        );
      }
    } catch (e) {
      emitter(
        AccountEventsStateFailed(e.toString()),
      );
    }
  }

  void _mapAccountEventsEventReloadToState(
    AccountEventsEventReload event,
    Emitter<AccountEventsState> emitter,
  ) async {
    final _currentState = this.state;
    bool _maxEvents = false;

    /// Change "isFetching" to true, to show a
    /// loading widget at the bottom of the list view.
    if (_currentState is AccountEventsStateSuccess) {
      emitter(
        AccountEventsStateSuccess(
          eventModels: _currentState.eventModels,
          maxEvents: _currentState.maxEvents,
          lastEvent: _currentState.lastEvent,
          isFetching: true,
        ),
      );
    }

    try {
      // User is fetching events from a failed state
      if (!(_currentState is AccountEventsStateFetching) &&
          !(_currentState is AccountEventsStateSuccess)) {
        emitter(AccountEventsStateFetching());
        // Retry will fail to quickly,
        //
        // Give the user a good feeling that events are actually being searched for.
        await Future.delayed(Duration(milliseconds: 350));
      }

      /// Get user's created events document that lists
      /// all of the event id's that belong to this user.
      await this._getListOfAccountEvents();

      /// Fail, since no document id's are listed in the user's createEvent doc.
      if (this._accountEventsHandler.isEmpty()) {
        emitter(
          AccountEventsStateFailed("Account ID Doc doesn't list any events"),
        );
        return;
      }

      /// Get the first [paginationLimit] number of event id's from the [AccountEventsHandler]
      final List<String> _eventIdsToFetch = this
          ._accountEventsHandler
          .getEventIdsPaginated(this._paginationLimit);

      /// Fetch the first [paginationLimit] number of events
      final List<DocumentSnapshot> _docs = [];
      for (int i = 0; i < _eventIdsToFetch.length; ++i) {
        final DocumentSnapshot? docSnap =
            await this.db.getSearchEventById(eventId: _eventIdsToFetch[i]);
        if (docSnap != null) {
          _docs.add(docSnap);
        }
      }

      if (_currentState is AccountEventsStateFailed) {
        emitter(AccountEventsStateReloadFailed());
      }

      // No events were retrieved on the FIRST retrieval, fail.
      if (_docs.isEmpty) {
        emitter(
          AccountEventsStateFailed("No events retrieved"),
        );
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
        AccountEventsStateSuccess(
          eventModels: _eventModels,
          maxEvents: _maxEvents,
          lastEvent: _docs.last,
          isFetching: false,
        ),
      );
    } catch (e) {
      emitter(
        AccountEventsStateFailed(e.toString()),
      );
    }
  }

  void _mapAccountEventsEventRemoveToState(
    AccountEventsEventRemove accountEventsEventRemove,
    Emitter<AccountEventsState> emitter,
  ) async {
    String? accountID = this.accountID;

    if (accountID == null) {
      return;
    }

    final currentState = this.state;

    if (currentState is AccountEventsStateSuccess) {
      if (!currentState.isFetching) {
        // Set [isDeleting] true, but still emit a
        // success state since the event has yet to be deleted.
        //
        // UI should show a loading widget in the UI
        // to indicate that the deletion is in process.
        // Still emit a success state, so list view remains unchanged
        emitter(
          AccountEventsStateSuccess(
            eventModels: currentState.eventModels,
            lastEvent: currentState.lastEvent,
            maxEvents: currentState.maxEvents,
            isFetching: currentState.isFetching,
            isDeleting: true,
          ),
        );

        // Remove event from "My Events" list view on the device
        if (currentState.eventModels.isNotEmpty) {
          currentState.eventModels.removeAt(accountEventsEventRemove.listIndex);
        } // if

        // Create a new reference, to force the list view to update
        List<SearchResultModel> newEventModelReference = [];
        if (currentState.eventModels.isNotEmpty) {
          newEventModelReference.addAll(currentState.eventModels);
        } // if

        // Delete event from firebase cloud
        await this.db.deleteEvent(
            accountEventsEventRemove.searchResultModel.eventId!,
            accountID);

        // Remove image from storage
        //
        // It's ok if this fails, since orphaned images will be deleted by cloud functions (hopefully)
        // await this.db.deleteImageFromStorage(eventID: accountEventsEventRemove.searchResultModel.eventId);

        // Deleted the last event (on the device)
        //
        // Show lonely panda image with a reload button,
        // just in case there's more events in the database
        if (newEventModelReference.isEmpty) {
          emitter(
            AccountEventsStateFailed("Deleted the last event"),
          );
        } // if

        // Set [isDeleting] false, as there are still events
        else {
          emitter(
            AccountEventsStateSuccess(
                eventModels: newEventModelReference,
                lastEvent: currentState.lastEvent,
                maxEvents: currentState.maxEvents,
                isFetching: currentState.isFetching,
                isDeleting: false),
          );
        }
      }
    }
  }

  Future<void> _getListOfAccountEvents() async {
    String? accountID = this.accountID;

    if (accountID == null) {
      return;
    }

    final DocumentSnapshot? docSnap =
        await this.db.getAccountCreatedEvents(uid: accountID);

    final List<String> eventIds = [];
    try {
      final Map m = docSnap!.data() as Map;
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
  } // getListOfPinnedEvents

  /// Name: _mapDocumentSnapshotsToSearchEventModels
  ///
  /// Description: maps the document snapshot from firebase to the event model
  List<SearchResultModel> _mapDocumentSnapshotsToSearchEventModels(
      {required List<DocumentSnapshot?> docs}) {
    return docs.map((doc) {
      Map<String, dynamic>? docAsMap = doc?.data() as Map<String, dynamic>?;

      // Convert the firebase timestamp to a DateTime
      DateTime? tempRawStartDateAndTimeToDateTime;
      Timestamp _startTimestamp = docAsMap?[ATTRIBUTE_RAW_START_DATE_TIME];
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
        newTitle: docAsMap?[ATTRIBUTE_TITLE] ?? '',

        // Host converted to [STRING] from [STRING] in Firebase.
        newHost: docAsMap?[ATTRIBUTE_HOST] ?? '',

        // Location Converted to [] from [] in Firebase.
        newLocation: docAsMap?[ATTRIBUTE_LOCATION] ?? '',

        // RawStartDate converted to [DATETIME] from [TIMESTAMP] in Firebase.
        newRawStartDateAndTime: tempRawStartDateAndTimeToDateTime ?? null,

        // Category converted to [STRING] from [STRING] in Firebase.
        newCategory: docAsMap?[ATTRIBUTE_CATEGORY] ?? '',

        // Implement Firebase Images.
        newImageFitCover: docAsMap?[ATTRIBUTE_IMAGE_FIT_COVER] ?? true,

        // Doc ID is the same as the event ID
        newEventId: doc?.id ?? '',
      );
    }).toList();
  }
}
