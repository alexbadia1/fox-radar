import 'dart:async';
import 'package:fox_radar/logic/logic.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:database_repository/database_repository.dart';

class CategoryEventsBloc
    extends Bloc<CategoryEventsEvent, CategoryEventsState> {
  final String category;
  final DatabaseRepository db;
  final int paginationLimit = PAGINATION_LIMIT;

  CategoryEventsBloc({required this.db, required this.category})
      : super(CategoryEventsStateFetching()) {
    on<CategoryEventsEventReload>(_mapCategoryEventsEventReloadToState);
    on<CategoryEventsEventFetch>(_mapCategoryEventsEventFetchToState);
  }

  void _mapCategoryEventsEventReloadToState(
    CategoryEventsEventReload event,
    Emitter<CategoryEventsState> emitter,
  ) async {
    /// Get the current state for later use...
    final _currentState = this.state;
    bool _maxEvents = false;

    if (_currentState is CategoryEventsStateSuccess) {
      emitter(
        CategoryEventsStateSuccess(
          eventModels: _currentState.eventModels,
          maxEvents: _currentState.maxEvents,
          lastEvent: _currentState.lastEvent,
          isFetching: true,
        ),
      );
    }

    try {
      // User is fetching events from a failed state
      if (!(_currentState is CategoryEventsStateFetching) &&
          !(_currentState is CategoryEventsStateSuccess)) {
        emitter(CategoryEventsStateFetching());
        // Retry will fail to quickly,
        //
        // Give the user a good feeling that events are actually being searched for.
        await Future.delayed(Duration(milliseconds: 100));
      }

      // No posts were fetched yet
      final List<QueryDocumentSnapshot> _docs =
          await _fetchEventsWithPagination(
              lastEvent: null, limit: paginationLimit);
      final List<SearchResultModel> _eventModels =
          _mapDocumentSnapshotsToSearchEventModels(docs: _docs);

      // Failed Reload from a failed state
      if (_currentState is CategoryEventsStateFailed && _docs.isEmpty) {
        emitter(CategoryEventsStateReloadFailed());
        emitter(CategoryEventsStateFailed());
        return;
      }

      if (_eventModels.length != this.paginationLimit) {
        _maxEvents = true;
      }

      emitter(
        CategoryEventsStateSuccess(
          eventModels: _eventModels,
          maxEvents: _maxEvents,
          lastEvent: _docs.last,
          isFetching: false,
        ),
      );
    } catch (e) {
      emitter(CategoryEventsStateFailed());
    }
  }

  void _mapCategoryEventsEventFetchToState(
    CategoryEventsEventFetch event,
    Emitter<CategoryEventsState> emitter,
  ) async {
    /// Get the current state for later use...
    final _currentState = this.state;
    bool _maxEvents = false;

    try {
      /// No posts were fetched yet
      if (_currentState is CategoryEventsStateFetching) {
        final List<QueryDocumentSnapshot> _docs =
            await _fetchEventsWithPagination(
                lastEvent: null, limit: paginationLimit);
        final List<SearchResultModel> _eventModels =
            _mapDocumentSnapshotsToSearchEventModels(docs: _docs);

        if (_eventModels.length != this.paginationLimit) {
          _maxEvents = true;
        }

        emitter(
          CategoryEventsStateSuccess(
            eventModels: _eventModels,
            maxEvents: _maxEvents,
            lastEvent: _docs.last,
            isFetching: false,
          ),
        );
      }

      /// Some posts were fetched already, now fetch 20 more
      else if (_currentState is CategoryEventsStateSuccess) {
        final List<QueryDocumentSnapshot> _docs =
            await _fetchEventsWithPagination(
                lastEvent: _currentState.lastEvent, limit: paginationLimit);

        /// No event models were returned from the database
        if (_docs.isEmpty) {
          emitter(
            CategoryEventsStateSuccess(
              eventModels: _currentState.eventModels,
              maxEvents: true,
              lastEvent: _currentState.lastEvent,
              isFetching: false,
            ),
          );
        }

        /// At least 1 event was returned from the database
        else {
          final List<SearchResultModel> _eventModels =
              _mapDocumentSnapshotsToSearchEventModels(docs: _docs);

          if (_eventModels.length != this.paginationLimit) {
            _maxEvents = true;
          }

          emitter(
            CategoryEventsStateSuccess(
              eventModels: _currentState.eventModels + _eventModels,
              maxEvents: _maxEvents,
              lastEvent: _docs?.last ?? _currentState.lastEvent,
              isFetching: false,
            ),
          );
        }
      }
    } catch (e) {
      emitter(CategoryEventsStateFailed());
    }
  }

  Future<List<QueryDocumentSnapshot>> _fetchEventsWithPagination(
      {required QueryDocumentSnapshot? lastEvent, required int limit}) async {
    return db.searchEventsByCategory(
        category: this.category, lastEvent: lastEvent, limit: limit);
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
  void onChange(Change<CategoryEventsState> change) {
    super.onChange(change);
  }

  @override
  Future<void> close() {
    return super.close();
  }
}
