import 'dart:async';
import 'package:bloc/bloc.dart';
import 'create_event_event.dart';
import 'create_event_state.dart';

class CreateEventBloc extends Bloc<CreateEventEvent, CreateEventState> {
  CreateEventBloc() : super(CreateEventInitial());

  @override
  Stream<CreateEventState> mapEventToState(
    CreateEventEvent event,
  ) async* {
    // TODO: implement mapEventToState
  }
}
