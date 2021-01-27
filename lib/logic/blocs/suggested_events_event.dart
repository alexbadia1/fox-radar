import 'package:equatable/equatable.dart';

abstract class SuggestedEventsEvent extends Equatable {
  const SuggestedEventsEvent();
}// SuggestedEventsEvent

class SuggestedEventsEventFetch extends SuggestedEventsEvent {
  @override
  List<Object> get props => [];
}// SuggestedEventsFetch
