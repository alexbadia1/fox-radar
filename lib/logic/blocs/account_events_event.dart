import 'package:equatable/equatable.dart';

abstract class AccountEventsEvent extends Equatable {
  const AccountEventsEvent();
}// AccountEventsEvent

class AccountEventsEventFetch extends AccountEventsEvent {
  @override
  List<Object> get props => [];
}// AccountEventsEventFetch

class AccountEventsEventReload extends AccountEventsEvent {
  @override
  List<Object> get props => [];
}// AccountEventsEventReload