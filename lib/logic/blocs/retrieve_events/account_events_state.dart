import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:database_repository/database_repository.dart';

abstract class AccountEventsState {
  const AccountEventsState();
}

class AccountEventsStateFetching extends AccountEventsState {}

class AccountEventsStateFailed extends AccountEventsState {
  final String msg;

  AccountEventsStateFailed(this.msg);
}

class AccountEventsStateReloadFailed extends AccountEventsState {}

class AccountEventsStateSuccess extends AccountEventsState {
  final List<SearchResultModel> eventModels;
  final DocumentSnapshot lastEvent;
  final bool maxEvents;
  final bool isFetching;
  bool isDeleting = false;

  AccountEventsStateSuccess(
      {required this.eventModels,
      required this.lastEvent,
      required this.maxEvents,
      required this.isFetching,
      isDeleting});

  set deleting(bool newIsDeleting) {
    this.isDeleting = newIsDeleting;
    if (isFetching) {
      this.isDeleting = false;
    }
  }
}
