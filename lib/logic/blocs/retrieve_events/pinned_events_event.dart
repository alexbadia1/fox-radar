import 'package:equatable/equatable.dart';

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

class PinnedEventsEventUnpin extends PinnedEventsEvent {
  final String eventId;

  PinnedEventsEventUnpin(this.eventId);

  @override
  List<Object> get props => [];
} // PinnedEventsEventUnpin

class PinnedEventsEventPin extends PinnedEventsEvent {
  final String eventId;

  PinnedEventsEventPin(this.eventId);
  @override
  List<Object> get props => [];
} // PinnedEventsEventPin

class PinnedEventsEventSort extends PinnedEventsEvent {
  final String sortKey;
  PinnedEventsEventSort(this.sortKey);

  @override
  List<Object> get props => [this.sortKey];
}// PinnedEventsEventSort