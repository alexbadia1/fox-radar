import 'dart:async';
import 'package:communitytabs/logic/logic.dart';


class SavedEventsBloc extends Bloc<SavedEventsEvent, SavedEventsState> {
  SavedEventsBloc() : super(SavedEventsStateFailed());

  @override
  Stream<SavedEventsState> mapEventToState(
    SavedEventsEvent event,
  ) async* {
    yield SavedEventsStateReloadFailed();
    yield SavedEventsStateFailed();
  }// mapEventToState
}// SavedEventsBloc
