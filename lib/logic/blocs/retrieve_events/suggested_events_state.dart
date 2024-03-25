import 'package:equatable/equatable.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:database_repository/database_repository.dart';

abstract class SuggestedEventsState extends Equatable {
  const SuggestedEventsState();
}

class SuggestedEventsStateFetching extends SuggestedEventsState {
  @override
  List<Object?> get props => [];
}

class SuggestedEventsStateFailed extends SuggestedEventsState {
  @override
  List<Object?> get props => [];
}

class SuggestedEventsStateReloadFailed extends SuggestedEventsState {
  @override
  List<Object?> get props => [];
}

class SuggestedEventsStateSuccess extends SuggestedEventsState {
  final List<SearchResultModel> eventModels;
  final QueryDocumentSnapshot lastEvent;
  final bool maxEvents;
  final bool isFetching;

  SuggestedEventsStateSuccess(
      {required this.eventModels,
      required this.lastEvent,
      required this.maxEvents,
      required this.isFetching});
  @override
  List<Object?> get props => [eventModels, maxEvents, lastEvent, isFetching];
}
