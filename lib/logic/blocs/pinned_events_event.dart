import 'package:flutter/material.dart';
import 'package:equatable/equatable.dart';
import 'package:database_repository/database_repository.dart';

abstract class PinnedEventsEvent extends Equatable {
  const PinnedEventsEvent();
}// PinnedEventsEvent

class PinnedEventsEventFetch extends PinnedEventsEvent {
  @override
  List<Object> get props => [];
} // PinnedEventsEventFetch

class PinnedEventsEventReload extends PinnedEventsEvent {
  @override
  List<Object> get props => [];
} // PinnedEventsEventReload

class PinnedEventsEventRemove extends PinnedEventsEvent {
  final int listIndex;
  final SearchResultModel searchResultModel;

  PinnedEventsEventRemove(
      {@required this.listIndex, @required this.searchResultModel})
      : assert(listIndex != null && listIndex > -1),
        assert(searchResultModel != null);

  @override
  List<Object> get props => [this.listIndex, this.searchResultModel];
} // PinnedEventsEventRemove