import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:database_repository/database_repository.dart';

abstract class PinnedEventsState {
  const PinnedEventsState();
}

class PinnedEventsStateFetching
    extends PinnedEventsState {} // PinnedEventsStateFetching

class PinnedEventsStateFailed extends PinnedEventsState {
  final String msg;

  PinnedEventsStateFailed(this.msg) {
    print(this.msg);
  }
}

class PinnedEventsStateReloadFailed
    extends PinnedEventsState {} // PinnedEventsStateReloadFailed

class PinnedEventsStateSuccess extends PinnedEventsState {
  final List<SearchResultModel> eventModels;
  final DocumentSnapshot lastEvent;
  final bool maxEvents;
  final bool isFetching;

  PinnedEventsStateSuccess({
    required this.eventModels,
    required this.lastEvent,
    required this.maxEvents,
    required this.isFetching,
  });
}
