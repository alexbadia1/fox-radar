import 'package:equatable/equatable.dart';
import 'package:database_repository/database_repository.dart';

abstract class AccountEventsEvent extends Equatable {
  const AccountEventsEvent();
}

class AccountEventsEventFetch extends AccountEventsEvent {
  @override
  List<Object?> get props => [];
}

class AccountEventsEventReload extends AccountEventsEvent {
  @override
  List<Object?> get props => [];
}

class AccountEventsEventRemove extends AccountEventsEvent {
  final int listIndex;
  final SearchResultModel searchResultModel;

  AccountEventsEventRemove(
      {required this.listIndex, required this.searchResultModel});

  @override
  List<Object?> get props => [this.listIndex, this.searchResultModel];
}
