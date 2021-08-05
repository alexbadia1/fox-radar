import 'package:equatable/equatable.dart';

abstract class SavedEventsEvent extends Equatable {
  const SavedEventsEvent();
}// SavedEventsEvent

class SavedEventsEventFetch extends SavedEventsEvent {
  @override
  List<Object> get props => [];
}// SavedEventsEventFetch

class SavedEventsEventReload extends SavedEventsEvent {
  @override
  List<Object> get props => [];
}// SavedEventsEventReload