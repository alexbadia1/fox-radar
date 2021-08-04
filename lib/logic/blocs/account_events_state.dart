import 'package:flutter/material.dart';
import 'package:equatable/equatable.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:database_repository/database_repository.dart';

abstract class AccountEventsState {
  const AccountEventsState();
} // AccountEventsState

class AccountEventsStateFetching extends AccountEventsState {} // AccountEventsStateFetching

class AccountEventsStateFailed extends AccountEventsState {} // AccountEventsStateFailed

class AccountEventsStateReloadFailed extends AccountEventsState {} // AccountEventsStateReloadFailed

class AccountEventsStateSuccess extends AccountEventsState {
  final List<SearchResultModel> eventModels;
  final QueryDocumentSnapshot lastEvent;
  final bool maxEvents;
  final bool isFetching;
  bool isDeleting = false;

  AccountEventsStateSuccess(
      {@required this.eventModels,
      @required this.lastEvent,
      @required this.maxEvents,
      @required this.isFetching,
      isDeleting});

  set deleting(bool newIsDeleting) {
    this.isDeleting = newIsDeleting;
    if (isFetching) {
      this.isDeleting = false;
    } // if
  } // isDeleting
} // AccountEventsStateSuccess
