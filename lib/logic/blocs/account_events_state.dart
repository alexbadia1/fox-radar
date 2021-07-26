import 'package:flutter/material.dart';
import 'package:equatable/equatable.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:database_repository/database_repository.dart';


abstract class AccountEventsState extends Equatable {
  const AccountEventsState();
}// AccountEventsState

class AccountEventsStateFetching extends AccountEventsState {
  @override
  List<Object> get props => [];
} // AccountEventsStateFetching

class AccountEventsStateFailed extends AccountEventsState {
  @override
  List<Object> get props => [];
} // AccountEventsStateFailed

class AccountEventsStateReloadFailed extends AccountEventsState {
  @override
  List<Object> get props => [];
} // AccountEventsStateReloadFailed

class AccountEventsStateSuccess extends AccountEventsState {
  final List<SearchResultModel> eventModels;
  final QueryDocumentSnapshot lastEvent;
  final bool maxEvents;
  final bool isFetching;

  AccountEventsStateSuccess(
      {@required this.eventModels,
        @required this.lastEvent,
        @required this.maxEvents,
        @required this.isFetching});
  @override
  List<Object> get props => [eventModels, maxEvents, lastEvent, isFetching];
} // AccountEventsStateSuccess