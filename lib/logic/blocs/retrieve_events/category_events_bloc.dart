import 'dart:async';
import 'package:rxdart/rxdart.dart';
import 'package:fox_radar/logic/logic.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:database_repository/database_repository.dart';

class CategoryEventsBloc extends Bloc<CategoryEventsEvent, CategoryEventsState> {
  final String category;
  final DatabaseRepository db;
  final int paginationLimit = PAGINATION_LIMIT;

  CategoryEventsBloc({required this.db, required this.category})
      : super(CategoryEventsStateFetching());

  @override
  Stream<CategoryEventsState> mapEventToState(CategoryEventsEvent categoryEventsEvent) async* {
    if (categoryEventsEvent is CategoryEventsEventFetch) {
      /// Fetch some events
      yield* _mapCategoryEventsEventFetchToState();
    } else if (categoryEventsEvent is CategoryEventsEventReload) {
      /// Reload the events list
      yield* _mapCategoryEventsEventReloadToState();
    } else {
      /// The event added to the bloc has not associated state
      /// either create one, or check all the available CategoryEvents
      yield CategoryEventsStateFailed();
    }
  }

  Stream<CategoryEventsState> _mapCategoryEventsEventReloadToState() async* {
    /// Get the current state for later use...
    final _currentState = this.state;
    bool _maxEvents = false;

    if (_currentState is CategoryEventsStateSuccess) {
      yield CategoryEventsStateSuccess(
        eventModels: _currentState.eventModels,
        maxEvents: _currentState.maxEvents,
        lastEvent: _currentState.lastEvent,
        isFetching: true,
      );
    }

    try {
      // User is fetching events from a failed state
      if (!(_currentState is CategoryEventsStateFetching) && !(_currentState is CategoryEventsStateSuccess)) {
        yield CategoryEventsStateFetching();
        // Retry will fail to quickly,
        //
        // Give the user a good feeling that events are actually being searched for.
        await Future.delayed(Duration(milliseconds: 100));
      }

      // No posts were fetched yet
      final List<QueryDocumentSnapshot> _docs = await _fetchEventsWithPagination(lastEvent: null, limit: paginationLimit);
      final List<SearchResultModel> _eventModels = _mapDocumentSnapshotsToSearchEventModels(docs: _docs);

      // Failed Reload from a failed state
      if (_currentState is CategoryEventsStateFailed && _docs.isEmpty) {
        yield CategoryEventsStateReloadFailed();
        yield CategoryEventsStateFailed();
        return;
      }

      if (_eventModels.length != this.paginationLimit) {
        _maxEvents = true;
      }

      yield CategoryEventsStateSuccess(
        eventModels: _eventModels,
        maxEvents: _maxEvents,
        lastEvent: _docs.last,
        isFetching: false,
      );
    } catch (e) {
      yield CategoryEventsStateFailed();
    }
  }

  Stream<CategoryEventsState> _mapCategoryEventsEventFetchToState() async* {
    /// Get the current state for later use...
    final _currentState = this.state;
    bool _maxEvents = false;

    try {
      /// No posts were fetched yet
      if (_currentState is CategoryEventsStateFetching) {
        final List<QueryDocumentSnapshot> _docs = await _fetchEventsWithPagination(lastEvent: null, limit: paginationLimit);
        final List<SearchResultModel> _eventModels = _mapDocumentSnapshotsToSearchEventModels(docs: _docs);

        if (_eventModels.length != this.paginationLimit) {
          _maxEvents = true;
        }

        yield CategoryEventsStateSuccess(
          eventModels: _eventModels,
          maxEvents: _maxEvents,
          lastEvent: _docs.last,
          isFetching: false,
        );
      }

      /// Some posts were fetched already, now fetch 20 more
      else if (_currentState is CategoryEventsStateSuccess) {
        final List<QueryDocumentSnapshot> _docs = await _fetchEventsWithPagination(lastEvent: _currentState.lastEvent, limit: paginationLimit);

        /// No event models were returned from the database
        if (_docs.isEmpty) {
          yield CategoryEventsStateSuccess(
            eventModels: _currentState.eventModels,
            maxEvents: true,
            lastEvent: _currentState.lastEvent,
            isFetching: false,
          );
        }

        /// At least 1 event was returned from the database
        else {
          final List<SearchResultModel> _eventModels = _mapDocumentSnapshotsToSearchEventModels(docs: _docs);

          if (_eventModels.length != this.paginationLimit) {
            _maxEvents = true;
          }

          yield CategoryEventsStateSuccess(
            eventModels: _currentState.eventModels + _eventModels,
            maxEvents: _maxEvents,
            lastEvent: _docs?.last ?? _currentState.lastEvent,
            isFetching: false,
          );
        }
      }
    } catch (e) {
      yield CategoryEventsStateFailed();
    }
  }

  Future<List<QueryDocumentSnapshot>> _fetchEventsWithPagination({required QueryDocumentSnapshot? lastEvent, required int limit}) async {
    return db.searchEventsByCategory(category: this.category, lastEvent: lastEvent, limit: limit);
  }

  List<SearchResultModel> _mapDocumentSnapshotsToSearchEventModels({required List<QueryDocumentSnapshot> docs}) {
    return docs.map((doc) {
      Map<String, dynamic> docAsMap = doc.data() as Map<String, dynamic>;

      // Convert the firebase timestamp to a DateTime
      DateTime? tempRawStartDateAndTimeToDateTime;
      Timestamp? _startTimestamp = docAsMap[ATTRIBUTE_RAW_START_DATE_TIME];
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

        // DocumentId converted to [STRING] from [STRING] in firebase.
        newEventId: doc.id,
      );
    }).toList();
  }

  @override
  Stream<Transition<CategoryEventsEvent, CategoryEventsState>> transform(Stream<CategoryEventsEvent> events, transitionFn) {
    return events.debounceTime(const Duration(milliseconds: 0)).switchMap(transitionFn);
  }

  @override
  void onChange(Change<CategoryEventsState> change) {
    super.onChange(change);
  }

  @override
  Future<void> close() {
    return super.close();
  }
}
