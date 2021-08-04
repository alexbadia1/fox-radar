import 'package:flutter/material.dart';
import 'package:equatable/equatable.dart';
import 'package:database_repository/database_repository.dart';

abstract class AccountEventsEvent extends Equatable {
  const AccountEventsEvent();
} // AccountEventsEvent

class AccountEventsEventFetch extends AccountEventsEvent {
  @override
  List<Object> get props => [];
} // AccountEventsEventFetch

class AccountEventsEventReload extends AccountEventsEvent {
  @override
  List<Object> get props => [];
} // AccountEventsEventReload

class AccountEventsEventRemove extends AccountEventsEvent {
  final int listIndex;
  final SearchResultModel searchResultModel;

  AccountEventsEventRemove(
      {@required this.listIndex, @required this.searchResultModel})
      : assert(listIndex != null && listIndex > -1),
        assert(searchResultModel != null);

  @override
  List<Object> get props => [this.listIndex, this.searchResultModel];
} // AccountEventsEventRemove
