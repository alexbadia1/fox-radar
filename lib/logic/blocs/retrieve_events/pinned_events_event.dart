import 'package:equatable/equatable.dart';

abstract class PinnedEventsEvent extends Equatable {
  const PinnedEventsEvent();
}

class PinnedEventsEventFetch extends PinnedEventsEvent {
  @override
  List<Object?> get props => [];
}

class PinnedEventsEventReload extends PinnedEventsEvent {
  @override
  List<Object?> get props => [];
}

class PinnedEventsEventUnpin extends PinnedEventsEvent {
  final String? eventId;

  PinnedEventsEventUnpin(this.eventId);

  @override
  List<Object?> get props => [];
}

class PinnedEventsEventPin extends PinnedEventsEvent {
  final String? eventId;

  PinnedEventsEventPin(this.eventId);
  @override
  List<Object?> get props => [];
}

class PinnedEventsEventSort extends PinnedEventsEvent {
  final String sortKey;
  PinnedEventsEventSort(this.sortKey);

  @override
  List<Object?> get props => [this.sortKey];
}