import 'dart:async';
import 'package:fox_radar/logic/logic.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:database_repository/database_repository.dart';

class SuggestedEventsBloc
    extends Bloc<SuggestedEventsEvent, SuggestedEventsState> {
  late final DatabaseRepository db;
  final int paginationLimit = PAGINATION_LIMIT;

  SuggestedEventsBloc({required this.db})
      : super(SuggestedEventsStateFetching()) {
    on<SuggestedEventsEventReload>(_mapSuggestedEventsEventReloadToState);
    on<SuggestedEventsEventFetch>(_mapSuggestedEventsEventFetchToState);
  }

  void _mapSuggestedEventsEventReloadToState(
    SuggestedEventsEventReload event,
    Emitter<SuggestedEventsState> emitter,
  ) async {
    // Get the current state for later use...
    final _currentState = this.state;
    bool _maxEvents = false;

    // Change "isFetching" to true, to show a
    // loading widget at the bottom of the list view.
    if (_currentState is SuggestedEventsStateSuccess) {
      emitter(
        SuggestedEventsStateSuccess(
          eventModels: _currentState.eventModels,
          maxEvents: _currentState.maxEvents,
          lastEvent: _currentState.lastEvent,
          isFetching: true,
        ),
      );
    }

    try {
      // User is fetching events from a failed state
      if (!(_currentState is SuggestedEventsStateFetching) &&
          !(_currentState is SuggestedEventsStateSuccess)) {
        emitter(SuggestedEventsStateFetching());
        // Retry will fail to quickly,
        //
        // Give the user a good feeling that events are actually being searched for.
        await Future.delayed(Duration(milliseconds: 350));
      }

      // No posts were fetched yet
      final List<QueryDocumentSnapshot> _docs =
          await _fetchEventsWithPagination(
              lastEvent: null, limit: paginationLimit);
      final List<SearchResultModel> _eventModels =
          _mapDocumentSnapshotsToSearchEventModels(docs: _docs);

      // Failed Reload from a failed state
      if (_currentState is SuggestedEventsStateFailed && _docs.isEmpty) {
        emitter(SuggestedEventsStateReloadFailed());
        emitter(SuggestedEventsStateFailed());
        return;
      }

      if (_eventModels.length != this.paginationLimit) {
        _maxEvents = true;
      }

      emitter(
        SuggestedEventsStateSuccess(
          eventModels: _eventModels,
          maxEvents: _maxEvents,
          lastEvent: _docs.last,
          isFetching: false,
        ),
      );
    } catch (e) {
      emitter(SuggestedEventsStateFailed());
    }
  }

  void _mapSuggestedEventsEventFetchToState(
    SuggestedEventsEventFetch event,
    Emitter<SuggestedEventsState> emitter,
  ) async {
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
        }

        emitter(
          SuggestedEventsStateSuccess(
            eventModels: _eventModels,
            maxEvents: _maxEvents,
            lastEvent: _docs.last,
            isFetching: false,
          ),
        );
      }

      // Some posts were fetched already, now fetch 20 more
      else if (_currentState is SuggestedEventsStateSuccess) {
        final List<QueryDocumentSnapshot> _docs =
            await _fetchEventsWithPagination(
                lastEvent: _currentState.lastEvent, limit: paginationLimit);

        // No event models were returned from the database
        if (_docs.isEmpty) {
          emitter(
            SuggestedEventsStateSuccess(
              eventModels: _currentState.eventModels,
              maxEvents: true,
              lastEvent: _currentState.lastEvent,
              isFetching: false,
            ),
          );
        }

        // At least 1 event was returned from the database
        else {
          final List<SearchResultModel> _eventModels =
              _mapDocumentSnapshotsToSearchEventModels(docs: _docs);

          if (_eventModels.length != this.paginationLimit) {
            _maxEvents = true;
          }

          emitter(
            SuggestedEventsStateSuccess(
              eventModels: _currentState.eventModels + _eventModels,
              maxEvents: _maxEvents,
              lastEvent: _docs?.last ?? _currentState.lastEvent,
              isFetching: false,
            ),
          );
        }
      }
    } catch (e) {
      emitter(SuggestedEventsStateFailed());
    }
  }

  Future<List<QueryDocumentSnapshot>> _fetchEventsWithPagination(
      {required QueryDocumentSnapshot? lastEvent, required int limit}) async {
    return db.searchEventsByStartDateAndTime(
        lastEvent: lastEvent, limit: limit);
  }

  List<SearchResultModel> _mapDocumentSnapshotsToSearchEventModels(
      {required List<QueryDocumentSnapshot> docs}) {
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
      } else {
        tempRawStartDateAndTimeToDateTime = null;
      }

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

        // DocumentId converted to [STRING] from [STRING] in firebase.
        newEventId: doc.id,
      );
    }).toList();
  }

  @override
  void onChange(Change<SuggestedEventsState> change) {
    print('Suggested Events Bloc: $change');
    super.onChange(change);
  }

  @override
  Future<void> close() {
    print('Suggested Events Bloc Closed');
    return super.close();
  }
}
