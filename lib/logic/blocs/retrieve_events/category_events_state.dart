import 'package:flutter/material.dart';
import 'package:equatable/equatable.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:database_repository/database_repository.dart';

@immutable
abstract class CategoryEventsState extends Equatable {}

class CategoryEventsStateFetching extends CategoryEventsState {
  @override
  List<Object?> get props => [];
}

class CategoryEventsStateFailed extends CategoryEventsState {
  @override
  List<Object?> get props => [];
}

class CategoryEventsStateReloadFailed extends CategoryEventsState {
  @override
  List<Object?> get props => [];
}

class CategoryEventsStateSuccess extends CategoryEventsState {
  final List<SearchResultModel> eventModels;
  final QueryDocumentSnapshot lastEvent;
  final bool maxEvents;
  final bool isFetching;

  CategoryEventsStateSuccess(
      {required this.eventModels,
        required this.lastEvent,
        required this.maxEvents,
        required this.isFetching});
  @override
  List<Object?> get props => [eventModels, maxEvents, lastEvent, isFetching];
}
