import 'dart:async';
import 'dart:typed_data';
import 'package:bloc/bloc.dart';
import 'package:communitytabs/logic/constants/constants.dart';
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

    else if (event is CreateEventSetRawStartDateTime) {
      yield* _mapCreateEventSetRawStartDateTimeToState(
          createEventSetRawStartDateTime: event);
    } // else-if

    else if (event is CreateEventSetRawEndDateTime) {
      yield* _mapCreateEventSetRawEndDateTimeToState(
          createEventSetRawEndDateTime: event);
    } // else-if

    else if (event is CreateEventSetCategory) {
      yield* _mapCreateEventSetCategoryToState(createEventSetCategory: event);
    } // else-if

    else if (event is CreateEventAddHighlight) {
      yield* _mapCreateEventAddHighlightToState(createEventAddHighlight: event);
    } // else if

    else if (event is CreateEventRemoveHighlight) {
      yield* _mapCreateEventRemoveHighlightToState(
          createEventRemoveHighlight: event);
    } // else if

    else if (event is CreateEventSetHighlight) {
      yield* _mapCreateEventSetHighlightToState(createEventSetHighlight: event);
    } // if

    else if (event is CreateEventSetImage) {
      yield* _mapCreateEventSetImageToState(createEventSetImage: event);
    } // else-if

    else if (event is CreateEventSetImageFitCover) {
      yield* _mapCreateEventSetImageFitCoverToState(
          createEventSetImageFitCover: event);
    } // else-if

    else if (event is CreateEventSetImagePath) {
      yield* _mapCreateEventSetImagePathToState(createEventSetImagePath: event);
    } // else-if

    else {
      yield CreateEventInvalid(this._eventModel);
    } // else
  } // mapEventToState

  /// Sets the event title
  Stream<CreateEventState> _mapCreateEventSetTitleToState(
      {@required CreateEventSetTitle createEventSetTitle}) async* {
    /// Empty Title, set title to empty
    if (createEventSetTitle.newTitle.trim().isEmpty) {
      this._eventModel = this._eventModel.copyWith(title: '');
    } // if

    /// Not empty title, so update the _event
    else {
      this._eventModel =
          this._eventModel.copyWith(title: createEventSetTitle.newTitle.trim());
    } // else

    yield isValid();
  } // _mapCreateEventSetTitleToState

  /// Sets the event host
  Stream<CreateEventState> _mapCreateEventSetHostToState(
      {@required CreateEventSetHost createEventSetHost}) async* {
    /// Empty host, set title to empty
    if (createEventSetHost.newHost.trim().isEmpty) {
      this._eventModel = this._eventModel.copyWith(host: '');
    } // if

    /// Not empty host, so update the _event
    else {
      this._eventModel =
          this._eventModel.copyWith(host: createEventSetHost.newHost.trim());
    } // else

    yield isValid();
  } // _mapCreateEventSetHostToState

  /// Sets the event location
  Stream<CreateEventState> _mapCreateEventSetLocationToState(
      {@required CreateEventSetLocation createEventSetLocation}) async* {
    /// Empty location, set title to empty
    if (createEventSetLocation.newLocation.trim().isEmpty) {
      this._eventModel = this._eventModel.copyWith(location: '');
    } // if

    /// Not empty location, so update the _event
    else {
      this._eventModel = this
          ._eventModel
          .copyWith(location: createEventSetLocation.newLocation.trim());
    } // else

    yield isValid();
  } // _mapCreateEventSetLocationToState

  /// Sets the event room
  Stream<CreateEventState> _mapCreateEventSetRoomToState(
      {@required CreateEventSetRoom createEventSetRoom}) async* {
    /// Empty room, set title to empty
    if (createEventSetRoom.newRoom.trim().isEmpty) {
      this._eventModel = this._eventModel.copyWith(room: '');
    } // if

    /// Not empty room, so update the _event
    else {
      this._eventModel =
          this._eventModel.copyWith(room: createEventSetRoom.newRoom.trim());
    } // else

    yield isValid();
  } // _mapCreateEventSetRoomToState

  /// Sets the event description
  Stream<CreateEventState> _mapCreateEventSetDescriptionToState(
      {@required CreateEventSetDescription createEventSetDescription}) async* {
    /// Empty description, set title to empty
    if (createEventSetDescription.newDescription.trim().isEmpty) {
      this._eventModel = this._eventModel.copyWith(summary: '');
    } // if

    /// Not empty description, so update the _event
    else {
      this._eventModel = this
          ._eventModel
          .copyWith(summary: createEventSetDescription.newDescription.trim());
    } // else

    yield isValid();
  } // _mapCreateEventSetDescriptionToState

  /// Sets the event start DateTime
  Stream<CreateEventState> _mapCreateEventSetRawStartDateTimeToState(
      {@required
          CreateEventSetRawStartDateTime
              createEventSetRawStartDateTime}) async* {
    /// Not empty rawStartDateAndTime, so update the _event
    if (createEventSetRawStartDateTime.newRawStartDateTime != null) {
      this._eventModel = this._eventModel.copyWith(
          rawStartDateAndTime:
              createEventSetRawStartDateTime.newRawStartDateTime);
    } // if

    /// Empty rawStartDateAndTime
    else {
      this._eventModel =
          this._eventModel.copyWith(rawStartDateAndTime: DateTime.now());
    } // else

    yield isValid();
  } // _mapCreateEventSetRawStartDateTimeToState

  /// Sets the event end DateTime
  Stream<CreateEventState> _mapCreateEventSetRawEndDateTimeToState(
      {@required
          CreateEventSetRawEndDateTime createEventSetRawEndDateTime}) async* {
    // Not empty newRawEndDateTime, so update the _event
    if (createEventSetRawEndDateTime.newRawEndDateTime != null) {
      this._eventModel = this._eventModel.copyWith(
          rawEndDateAndTime: createEventSetRawEndDateTime.newRawEndDateTime);
    } // if

    // Empty rawEndDateAndTime
    else {
      this._eventModel =
          this._eventModel.copyWith(rawEndDateAndTime: DateTime.now());
    } // else

    yield isValid();
  } // _mapCreateEventSetRawEndDateTimeToState

  /// Sets the event category
  Stream<CreateEventState> _mapCreateEventSetCategoryToState(
      {@required CreateEventSetCategory createEventSetCategory}) async* {
    // Not empty category, so update the _event
    if (createEventSetCategory.category != null) {
      this._eventModel =
          this._eventModel.copyWith(category: createEventSetCategory.category);
    } // if

    // Empty category
    else {
      this._eventModel = this._eventModel.copyWith(category: ACADEMIC);
    } // else

    yield isValid();
  } // _mapCreateEventSetCategoryToState

  /// Add Highlight
  Stream<CreateEventState> _mapCreateEventAddHighlightToState(
      {@required CreateEventAddHighlight createEventAddHighlight}) async* {
    // Dart passes array's like objects, thus you need to "clone" the array
    // in order to ensure the array being used to create the new event model object is "new"
    List<String> _highlightList = [];
    _highlightList.addAll(this._eventModel.getHighlights);

    // Not empty highlight
    if (createEventAddHighlight.highlight != null) {
      // TODO: Use a constant for the number of highlights limit, preferably defined in the event model
      if (_highlightList.length < 6) {
        _highlightList.add(createEventAddHighlight.highlight);
        this._eventModel =
            this._eventModel.copyWith(highlights: _highlightList);
      } // if
    } // if

    // Empty highlight
    else {
      this._eventModel = this._eventModel.copyWith(highlights: _highlightList);
    } // else

    yield isValid();
  } // _mapCreateEventAddHighlightToState

  /// Remove Highlight
  Stream<CreateEventState> _mapCreateEventRemoveHighlightToState(
      {@required
          CreateEventRemoveHighlight createEventRemoveHighlight}) async* {
    // Dart passes array's like objects, thus you need to "clone" the array
    // in order to ensure the array being used to create the new event model object is "new"
    List<String> _highlightList = [];
    _highlightList.addAll(this._eventModel.getHighlights);

    // Not empty highlight
    if (createEventRemoveHighlight.index != null) {
      // TODO: Use a constant for the number of highlights limit, preferably defined in the event model
      if (_highlightList.length > 0) {
        _highlightList.removeAt(createEventRemoveHighlight.index);
        this._eventModel =
            this._eventModel.copyWith(highlights: _highlightList);
      } // if
    } // if

    // Empty highlight
    else {
      this._eventModel = this._eventModel.copyWith(highlights: _highlightList);
    } // else

    yield isValid();
  } // _mapCreateEventRemoveHighlightToState

  /// Set Highlight
  Stream<CreateEventState> _mapCreateEventSetHighlightToState(
      {@required CreateEventSetHighlight createEventSetHighlight}) async* {
    final List<String> _highlightList = this._eventModel.getHighlights ?? [];

    // Not empty highlight
    if (createEventSetHighlight.index != null) {
      _highlightList[createEventSetHighlight.index] =
          createEventSetHighlight.highlight ?? '';
      this._eventModel = this._eventModel.copyWith(highlights: _highlightList);
    } // if

    yield isValid();
  } // _mapCreateEventSetHighlightToState

  /// Set Image
  Stream<CreateEventState> _mapCreateEventSetImageToState(
      {@required CreateEventSetImage createEventSetImage}) async* {
    final Uint8List _bytes = createEventSetImage.imageBytes;

    // Not empty highlight
    if (_bytes != null) {
      this._eventModel = this._eventModel.copyWith(imageBytes: _bytes);
    } // if

    yield isValid();
  } // _mapCreateEventSetImageToState

  /// Set Image Fit Cover
  Stream<CreateEventState> _mapCreateEventSetImageFitCoverToState(
      {@required
          CreateEventSetImageFitCover createEventSetImageFitCover}) async* {
    this._eventModel = this
        ._eventModel
        .copyWith(imageFitCover: createEventSetImageFitCover.fitCover);

    yield isValid();
  } // _mapCreateEventSetImageFitCoverToState

  Stream<CreateEventState> _mapCreateEventSetImagePathToState(
      {@required CreateEventSetImagePath createEventSetImagePath}) async* {
    if (createEventSetImagePath.imagePath != null) {
      this._eventModel = this
          ._eventModel
          .copyWith(imagePath: createEventSetImagePath.imagePath);
    } // if

    yield isValid();
  } // _mapCreateEventSetImagePathToState

  /// Checks if the created event meets the minimal requirements:
  ///   title,
  ///   host,
  ///   location,
  ///   start time.
  ///   category
  CreateEventState isValid() {
    /// Valid
    if (this._eventModel.myCategory.trim().isNotEmpty &&
        this._eventModel.getTitle.trim().isNotEmpty &&
        this._eventModel.getHost.trim().isNotEmpty &&
        this._eventModel.getLocation.trim().isNotEmpty &&
        (this._eventModel.getRawStartDateAndTime != null)) {
      return CreateEventValid(this._eventModel);
    } // if

    /// Invalid
    else {
      return CreateEventInvalid(this._eventModel);
    } // else
  } // isValid

  bool isValidEndDate() {
    if (this._eventModel.getRawEndDateAndTime == null) {
      return true;
    }
    if (this._eventModel.getRawEndDateAndTime != null) {
      if (this
          ._eventModel
          .getRawStartDateAndTime
          .isBefore(this._eventModel.getRawEndDateAndTime)) {
        return true;
      } // if
    } // if
    return false;
  } // isValidEndDate

  @override
  void onChange(Change<CreateEventState> change) {
    print('Create Event Bloc $change');
    super.onChange(change);
  } // onChange

  @override
  Future<void> close() {
    print('Create Event Bloc Closed!');
    return super.close();
  }
} // CreateEventBloc
