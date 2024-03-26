import 'package:equatable/equatable.dart';

abstract class SuggestedEventsEvent extends Equatable {
  const SuggestedEventsEvent();
}

class SuggestedEventsEventFetch extends SuggestedEventsEvent {
  @override
  List<Object?> get props => [];
}

class SuggestedEventsEventReload extends SuggestedEventsEvent {
  @override
  List<Object?> get props => [];
}
