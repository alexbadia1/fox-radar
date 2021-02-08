import 'dart:async';
import 'package:bloc/bloc.dart';
import 'create_event_event.dart';
import 'create_event_state.dart';
import 'package:flutter/material.dart';
import 'package:database_repository/database_repository.dart';

class CreateEventBloc extends Bloc<CreateEventEvent, CreateEventState> {
  final DatabaseRepository db;
  EventModel _eventModel;

  CreateEventBloc({@required this.db})
      : super(CreateEventInvalid(EventModel.nullConstructor())) {
    this._eventModel = this.state.eventModel;
  } // CreateEventBloc

  @override
  Stream<CreateEventState> mapEventToState(CreateEventEvent event) async* {
    if (event is CreateEventSetTitle) {
      yield* _mapCreateEventSetTitleToState(createEventSetTitle: event);
    } // if

    else if (event is CreateEventSetHost) {
      yield* _mapCreateEventSetHostToState(createEventSetHost: event);
    } // else-if

    else if (event is CreateEventSetLocation) {
      yield* _mapCreateEventSetLocationToState(createEventSetLocation: event);
    } // else-if

    else if (event is CreateEventSetRoom) {
      yield* _mapCreateEventSetRoomToState(createEventSetRoom: event);
    } // else-if

    else if (event is CreateEventSetDescription) {
      yield* _mapCreateEventSetDescriptionToState(
          createEventSetDescription: event);
    } // else-if

    else if (event is CreateEventSetRawStartDateTime){
      yield* _mapCreateEventSetRawStartDateTimeToState(createEventSetRawStartDateTime: event);
    }

    else {
      yield CreateEventInvalid(this._eventModel);
    } // else
  } // mapEventToState

  /// Sets the event title
  Stream<CreateEventState> _mapCreateEventSetTitleToState(
      {@required CreateEventSetTitle createEventSetTitle}) async* {
    /// Empty Title, set title to empty
    if (createEventSetTitle.newTitle.trim().isEmpty) {
      this._eventModel = new EventModel.nullConstructor()..setTitle('');
    } // if

    /// Not empty title, so update the _event
    else {
      this._eventModel = new EventModel.nullConstructor()
        ..setTitle(createEventSetTitle.newTitle.trim());
    } // else

    yield isValid();
  } // _mapCreateEventSetTitleToState

  /// Sets the event host
  Stream<CreateEventState> _mapCreateEventSetHostToState(
      {@required CreateEventSetHost createEventSetHost}) async* {
    /// Empty Title, set title to empty
    if (createEventSetHost.newHost.trim().isEmpty) {
      this._eventModel = new EventModel.nullConstructor()..setHost('');
    } // if

    /// Not empty title, so update the _event
    else {
      this._eventModel = new EventModel.nullConstructor()
        ..setHost(createEventSetHost.newHost.trim());
    } // else

    yield isValid();
  } // _mapCreateEventSetHostToState

  /// Sets the event location
  Stream<CreateEventState> _mapCreateEventSetLocationToState(
      {@required CreateEventSetLocation createEventSetLocation}) async* {
    /// Empty Title, set title to empty
    if (createEventSetLocation.newLocation.trim().isEmpty) {
      this._eventModel = new EventModel.nullConstructor()..setLocation('');
    } // if

    /// Not empty title, so update the _event
    else {
      this._eventModel = new EventModel.nullConstructor()
        ..setLocation(createEventSetLocation.newLocation.trim());
    } // else

    yield isValid();
  } // _mapCreateEventSetLocationToState

  /// Sets the event room
  Stream<CreateEventState> _mapCreateEventSetRoomToState(
      {@required CreateEventSetRoom createEventSetRoom}) async* {
    /// Empty Title, set title to empty
    if (createEventSetRoom.newRoom.trim().isEmpty) {
      this._eventModel = new EventModel.nullConstructor()..setRoom('');
    } // if

    /// Not empty title, so update the _event
    else {
      this._eventModel = new EventModel.nullConstructor()
        ..setRoom(createEventSetRoom.newRoom.trim());
    } // else

    yield isValid();
  } // _mapCreateEventSetRoomToState

  /// Sets the event description
  Stream<CreateEventState> _mapCreateEventSetDescriptionToState(
      {@required CreateEventSetDescription createEventSetDescription}) async* {
    /// Empty Title, set title to empty
    if (createEventSetDescription.newDescription.trim().isEmpty) {
      this._eventModel = new EventModel.nullConstructor()..setSummary('');
    } // if

    /// Not empty title, so update the _event
    else {
      this._eventModel = new EventModel.nullConstructor()
        ..setSummary(createEventSetDescription.newDescription.trim());
    } // else

    yield isValid();
  } // _mapCreateEventSetDescriptionToState

  /// Sets the event description
  Stream<CreateEventState> _mapCreateEventSetRawStartDateTimeToState(
      {@required
          CreateEventSetRawStartDateTime
              createEventSetRawStartDateTime}) async* {
    /// Empty Title, set title to empty
    if (createEventSetRawStartDateTime.newRawStartDateTime != null) {
      this._eventModel = new EventModel.nullConstructor()
        ..setRawStartDateAndTime(
            DateTime.now());
    } // if

    /// Not empty title, so update the _event
    else {
      this._eventModel = new EventModel.nullConstructor()
        ..setRawStartDateAndTime(
            createEventSetRawStartDateTime.newRawStartDateTime);
    } // else

    yield isValid();
  } // _mapCreateEventSetRawStartDateTimeToState

  /// Checks if the created event meets the minimal requirements:
  ///   title,
  ///   host,
  ///   location,
  ///   start time.
  CreateEventState isValid() {
    /// Valid
    if (this._eventModel.getTitle.trim().isNotEmpty &&
        this._eventModel.getHost.trim().isNotEmpty &&
        this._eventModel.getLocation.trim().isNotEmpty &&
        (this._eventModel.getRawEndDateAndTime != null)) {
      return CreateEventValid(this._eventModel);
    } // if

    /// Invalid
    else {
      return CreateEventInvalid(this._eventModel);
    } // else
  } // isValid

  @override
  void onChange(Change<CreateEventState> change) {
    print('Create Event Bloc $change');
    super.onChange(change);
  } // onChange
} // CreateEventBloc
