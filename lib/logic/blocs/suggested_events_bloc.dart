import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:database_repository/database_repository.dart';
import 'suggested_events_event.dart';
import 'suggested_events_state.dart';
import 'package:flutter/material.dart';
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
        final _eventModels =
            await _fetchEventsWithPagination(
                lastEvent: null,
                limit: 1);
        yield SuggestedEventsStateSuccess(
            eventModels: _eventModels, maxEvents: false);
        return;
      } // if

      /// Some posts were fetched already, now fetch 20 more
      if (_currentState is SuggestedEventsStateSuccess) {
        final _eventModels = await _fetchEventsWithPagination(
            lastEvent: _currentState.eventModels.last.getTitle,
            limit: 1);

        /// No event models were returned from the database
        if (_eventModels.isEmpty) {
          yield SuggestedEventsStateSuccess(
            eventModels: _currentState.eventModels,
            maxEvents: true,
          );
        } // if

        /// At least 1 event was returned from the database
        else {
          yield SuggestedEventsStateSuccess(
            eventModels: _currentState.eventModels + _eventModels,
            maxEvents: false,
          );
        } // else
      } // if
    } catch (e) {
      yield SuggestedEventsStateFailed();
    } // catch
  } // _mapSuggestedEventsEventFetchToState

  Future<List<EventModel>> _fetchEventsWithPagination({@required String lastEvent, @required int limit}) async {
    return db.getEventsWithPagination(
        category: 'Suggested',
        lastEvent: lastEvent,
        limit: limit);
  }// _fetchEventsWithPagination
}// SuggestedEventsBloc
