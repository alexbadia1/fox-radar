import 'package:flutter/material.dart';
import 'package:equatable/equatable.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:database_repository/database_repository.dart';

abstract class SavedEventsState extends Equatable {
  const SavedEventsState();
} // SavedEventsState

class SavedEventsStateFetching extends SavedEventsState {
  @override
  List<Object> get props => [];
} // SavedEventsFetching

class SavedEventsStateFailed extends SavedEventsState {
  @override
  List<Object> get props => [];
} // SavedEventsStateFailed

class SavedEventsStateReloadFailed extends SavedEventsState {
  @override
  List<Object> get props => [];
} // SavedEventsStateReloadFailed

class SavedEventsStateSuccess extends SavedEventsState {
  final List<SearchResultModel> eventModels;
  final QueryDocumentSnapshot lastEvent;
  final bool maxEvents;
  final bool isFetching;

  SavedEventsStateSuccess(
      {@required this.eventModels,
        @required this.lastEvent,
        @required this.maxEvents,
        @required this.isFetching});
  @override
  List<Object> get props => [eventModels, maxEvents, lastEvent, isFetching];
} // SavedEventsStateSuccess

