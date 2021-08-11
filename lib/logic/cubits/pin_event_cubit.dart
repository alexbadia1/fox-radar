import 'package:flutter/material.dart';
import 'package:communitytabs/logic/logic.dart';
import 'package:database_repository/database_repository.dart';

class PinEventCubit extends Cubit<PinEventState> {
  final DatabaseRepository db;
  final List<String> pinnedEvents;
  final String eventId;
  final String uid;

  PinEventCubit._instancePinned(this.db, this.pinnedEvents, this.eventId, this.uid): super(PinEventStatePinned());
  PinEventCubit._instanceUnpinned(this.db, this.pinnedEvents, this.eventId, this.uid): super(PinEventStateUnpinned());

  static instance({
    @required DatabaseRepository db,
    @required List<String> pinnedEvents,
    @required String eventId,
    @required String uid
  }) {
    if (pinnedEvents.contains(eventId)) {
      // TODO: Just show both pin and unpin buttons, no need to differentiate?
      return PinEventCubit._instancePinned(db, pinnedEvents, eventId, uid);
    }// if

    else {
      return PinEventCubit._instanceUnpinned(db, pinnedEvents, eventId, uid);
    }// else
  }// instance

  void pinEvent(String eventId) async {
    if (pinnedEvents.contains(eventId)) { return; }// maybe, tell user event is already pinned
    final bool success = await this.db.pinEvent(eventId, this.uid);

    if (success) {
      // Somehow tell the user it was successful
      emit(PinEventStatePinned());
    }// if

    else {
      emit(PinEventStatePinned());
    }// else
  }// pinEvent

  void unpinEvent(String eventId) async {
    if (!pinnedEvents.contains(eventId)) { return; }// maybe, tell user event is already unpinned
    final bool success = await this.db.unpinEvent(eventId, this.uid);

    if (success) {
      // Somehow tell the user it was successful
      emit(PinEventStateUnpinned());
    }// if

    else {
      emit(PinEventStatePinned());
    }// else
  }// unpinEvent
}// PinEventCubit