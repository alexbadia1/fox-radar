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
  final String accountID;
  EventModel _eventModel;

  CreateEventBloc({@required this.db, @required this.accountID})
      : assert(db != null),
        assert(accountID != null),
        super(CreateEventInvalid(EventModel.nullConstructor())) {
    this._eventModel = this.state.eventModel;
    this._eventModel.accountID = accountID;
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

    else if (event is CreateEventRemoveRawEndDateTime) {
      yield* _mapCreateEventRemoveRawEndDateTime();
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

    // SEE [create_event_event.dart] for all Bloc Events
    // Event received by CreateEventBloc is not defined
    else {
      // Re-yield the current instance of the BloC
      // and do not have any BloC listeners react to this.
      yield this.state;
    } // else
  } // mapEventToState

  /// Name: _mapCreateEventSetTitleToState
  ///
  /// Description: Sets the event title that should be
  ///              a valid in place on the Marist campus.
  ///
  /// Returns: a new valid or invalid BloC state
  Stream<CreateEventState> _mapCreateEventSetTitleToState(
      {@required CreateEventSetTitle createEventSetTitle}) async* {
    // Empty Title, set title to empty string
    if (createEventSetTitle.newTitle.trim().isEmpty) {
      this._eventModel = this._eventModel.copyWith(title: '');
    } // if

    // Not empty title, so update the _event
    else {
      this._eventModel =
          this._eventModel.copyWith(title: createEventSetTitle.newTitle.trim());
    } // else

    // Changing this attribute may affect the validity of the BloC
    yield isValid();
  } // _mapCreateEventSetTitleToState

  /// Name: _mapCreateEventSetHostToState
  ///
  /// Description: Sets the event host that
  ///              should be a valid in place on the Marist campus
  ///
  /// Returns: a new valid or invalid BloC state
  Stream<CreateEventState> _mapCreateEventSetHostToState(
      {@required CreateEventSetHost createEventSetHost}) async* {
    // Empty host, set host to empty string
    if (createEventSetHost.newHost.trim().isEmpty) {
      this._eventModel = this._eventModel.copyWith(host: '');
    } // if

    // Not empty host, so update the _eventModel
    else {
      this._eventModel =
          this._eventModel.copyWith(host: createEventSetHost.newHost.trim());
    } // else

    // Changing this attribute may affect the validity of the BloC
    yield isValid();
  } // _mapCreateEventSetHostToState

  /// Name: _mapCreateEventSetLocationToState
  ///
  /// Description: Sets the event location that
  ///              should be a valid in place on the Marist campus
  ///
  /// Returns: a new valid or invalid BloC state
  Stream<CreateEventState> _mapCreateEventSetLocationToState(
      {@required CreateEventSetLocation createEventSetLocation}) async* {
    // Empty location, set location to empty string
    if (createEventSetLocation.newLocation.trim().isEmpty) {
      this._eventModel = this._eventModel.copyWith(location: '');
    } // if

    // Not empty location, so update the _eventModel
    else {
      this._eventModel = this
          ._eventModel
          .copyWith(location: createEventSetLocation.newLocation.trim());
    } // else

    // Changing this attribute may affect the validity of the BloC
    yield isValid();
  } // _mapCreateEventSetLocationToState

  /// Name: _mapCreateEventSetRoomToState
  ///
  /// Description: Sets the event room location that
  ///              should be a valid in room on the Marist campus.
  ///
  /// Returns: the previous BloC's state
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

    // This attribute does not affect the validity of the event
    yield this._getNewInstanceOfCurrentState();
  } // _mapCreateEventSetRoomToState

  /// Name: _mapCreateEventSetDescriptionToState
  ///
  /// Description: Sets the event description that
  ///              summarizes what the event is about.
  ///
  /// Returns: the previous BloC's state
  Stream<CreateEventState> _mapCreateEventSetDescriptionToState(
      {@required CreateEventSetDescription createEventSetDescription}) async* {
    // Empty description, set description to empty string
    if (createEventSetDescription.newDescription.trim().isEmpty) {
      this._eventModel = this._eventModel.copyWith(description: '');
    } // if

    // Not empty description, so update the [_eventModel]
    else {
      this._eventModel = this._eventModel.copyWith(
          description: createEventSetDescription.newDescription.trim());
    } // else

    // This attribute does not affect the validity of the event
    yield this._getNewInstanceOfCurrentState();
  } // _mapCreateEventSetDescriptionToState

  /// Name: _mapCreateEventSetRawStartDateTimeToState
  ///
  /// Description: Sets the raw start datetime of the event
  ///
  /// Returns: a new valid or invalid BloC state
  ///
  /// Design Notes: The validity of the end datetime itself should
  ///               be checked in the UI using the BloC's [isValidEndDate]
  ///               whenever the start date time is changed too!
  ///
  /// TODO: Consider checking isValidEndDate in the BloC itself
  Stream<CreateEventState> _mapCreateEventSetRawStartDateTimeToState(
      {@required
          CreateEventSetRawStartDateTime
              createEventSetRawStartDateTime}) async* {
    // Not empty rawStartDateAndTime, so update the _event
    if (createEventSetRawStartDateTime.newRawStartDateTime != null) {
      this._eventModel = this._eventModel.copyWith(
          rawStartDateAndTime:
              createEventSetRawStartDateTime.newRawStartDateTime);
    } // if

    // Empty rawStartDateAndTime, default to current timestamp
    else {
      this._eventModel =
          this._eventModel.copyWith(rawStartDateAndTime: DateTime.now());
    } // else

    // Changing this attribute may affect the validity of the BloC
    yield isValid();
  } // _mapCreateEventSetRawStartDateTimeToState

  /// Name: _mapCreateEventSetRawEndDateTimeToState
  ///
  /// Description: Sets the raw end datetime of the event
  ///
  /// Returns: the previous BloC's state
  ///
  /// Design Notes: The validity of the end datetime itself is
  ///               checked in the UI using the BloC's [isValidEndDate].
  ///
  /// TODO: Consider checking isValidEndDate in the BloC itself
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

    // SEE DESIGN NOTE
    // This attribute does not affect the validity of the event
    yield this._getNewInstanceOfCurrentState();
  } // _mapCreateEventSetRawEndDateTimeToState

  /// Name: _mapCreateEventRemoveRawEndDateTime
  ///
  /// Description: Removes the current raw end datetime
  ///
  /// Returns: the previous BloC's state
  Stream<CreateEventState> _mapCreateEventRemoveRawEndDateTime() async* {
    // Make sure the event model has a null end date and time
    this._eventModel = this._eventModel.copyWith(endDate: '', endTime: '');

    // This attribute does not affect the validity of the event
    yield this._getNewInstanceOfCurrentState();
  } // _mapCreateEventRemoveRawEndDateTime

  /// Name: _mapCreateEventSetCategoryToState
  ///
  /// Description: Sets the events category
  ///
  /// Parameters:
  ///   CreateEventSetCategory: Bloc event containing the new category
  ///
  /// Returns: a new valid or invalid BloC state
  Stream<CreateEventState> _mapCreateEventSetCategoryToState(
      {@required CreateEventSetCategory createEventSetCategory}) async* {
    // Not empty category, so update the _event
    if (createEventSetCategory.category != null) {
      this._eventModel =
          this._eventModel.copyWith(category: createEventSetCategory.category);
    } // if

    // Empty category
    else {
      // Default the category to Academic
      this._eventModel = this._eventModel.copyWith(category: ACADEMIC);
    } // else

    // Changing this attribute may affect the validity of the BloC
    yield isValid();
  } // _mapCreateEventSetCategoryToState

  /// Name: _mapCreateEventAddHighlightToState
  ///
  /// Description: Adds a highlight to the highlights list in a LIFO order
  ///
  /// Parameters:
  ///   createEventAddHighlight: Bloc event containing the new highlight
  ///
  /// Returns: the previous BloC's state
  Stream<CreateEventState> _mapCreateEventAddHighlightToState(
      {@required CreateEventAddHighlight createEventAddHighlight}) async* {
    // Dart passes array's by reference, so "clone" the array into a new one
    // in order to ensure the new event model object is using a "new" reference
    List<String> _highlightList = [];
    _highlightList.addAll(this._eventModel.highlights);

    // Not empty highlight
    if (createEventAddHighlight.highlight != null) {
      // TODO: Create a  limits constant, preferably defined in the event model
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

    // This attribute does not affect the validity of the event
    yield this._getNewInstanceOfCurrentState();
  } // _mapCreateEventAddHighlightToState

  /// Name: _mapCreateEventRemoveHighlightToState
  ///
  /// Description: Removes a single highlight from the current state's
  ///              list of highlights storing them in a new highlights list.
  ///
  /// Parameters:
  ///   createEventRemoveHighlight: BloC event containing the index to remove at
  ///
  /// Returns: the previous BloC's state
  Stream<CreateEventState> _mapCreateEventRemoveHighlightToState(
      {@required
          CreateEventRemoveHighlight createEventRemoveHighlight}) async* {
    // Dart passes array's by reference, so "clone" the array into a new one
    // in order to ensure the new event model object is using a "new" reference
    List<String> _highlightList = [];
    _highlightList.addAll(this._eventModel.highlights);

    // Not empty highlight
    if (createEventRemoveHighlight.index != null) {
      // Obviously can't remove items from an empty list
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

    // This attribute does not affect the validity of the event
    yield this._getNewInstanceOfCurrentState();
  } // _mapCreateEventRemoveHighlightToState

  /// Name: _mapCreateEventSetHighlightToState
  ///
  /// Description: Replaces the current list of
  ///              highlights with a new list of highlights.
  ///
  /// Returns: the previous BloC's state
  Stream<CreateEventState> _mapCreateEventSetHighlightToState(
      {@required CreateEventSetHighlight createEventSetHighlight}) async* {
    final List<String> _highlightList = this._eventModel.highlights ?? [];

    // Not empty highlight
    if (createEventSetHighlight.index != null) {
      _highlightList[createEventSetHighlight.index] =
          createEventSetHighlight.highlight ?? '';
      this._eventModel = this._eventModel.copyWith(highlights: _highlightList);
    } // if

    // This attribute does not affect the validity of the event
    yield this._getNewInstanceOfCurrentState();
  } // _mapCreateEventSetHighlightToState

  /// Name: _mapCreateEventSetImageToState
  ///
  /// Description: stores the image bytes of the event
  ///              which is later used to upload to a firebase storage bucket
  ///
  /// Returns: the previous BloC's state
  ///
  /// TODO: Investigate separating this into its own BloC or Cubit
  Stream<CreateEventState> _mapCreateEventSetImageToState(
      {@required CreateEventSetImage createEventSetImage}) async* {
    final Uint8List _bytes = createEventSetImage.imageBytes;

    // Not empty highlight
    if (_bytes != null) {
      this._eventModel = this._eventModel.copyWith(imageBytes: _bytes);
    } // if

    // This attribute does not affect the validity of the event
    yield this._getNewInstanceOfCurrentState();
  } // _mapCreateEventSetImageToState

  /// Name: _mapCreateEventSetImageFitCoverToState
  ///
  /// Description: Changing if the image is scaled
  ///              to fit the aspect ratio of the card.
  ///
  /// Returns: the previous BloC's state
  Stream<CreateEventState> _mapCreateEventSetImageFitCoverToState(
      {@required
          CreateEventSetImageFitCover createEventSetImageFitCover}) async* {
    // The image fit is defaulted to "cover: true"
    if (createEventSetImageFitCover.fitCover != null) {
      this._eventModel = this
          ._eventModel
          .copyWith(imageFitCover: createEventSetImageFitCover.fitCover);
    } // if

    // This attribute does not affect the validity of the event
    yield this._getNewInstanceOfCurrentState();
  } // _mapCreateEventSetImageFitCoverToState

  /// Name: _mapCreateEventSetImagePathToState
  ///
  /// Description: Sets the events firebase storage image
  ///              path used to retrieve the image for the event.
  ///
  /// Returns: the previous BloC's state
  Stream<CreateEventState> _mapCreateEventSetImagePathToState(
      {@required CreateEventSetImagePath createEventSetImagePath}) async* {
    if (createEventSetImagePath.imagePath != null) {
      this._eventModel = this
          ._eventModel
          .copyWith(imagePath: createEventSetImagePath.imagePath);
    } // if

    // This attribute does not affect the validity of the event
    yield this._getNewInstanceOfCurrentState();
  } // _mapCreateEventSetImagePathToState

  /// Name: _getNewInstanceOfCurrentState
  ///
  /// Description: creates a new instance of the previous state,
  ///              in order to force BloC listeners to update.
  ///
  /// Returns: a new instance of the previous BloC's State
  ///
  /// TODO: Investigate splitting each attribute of the form into cubits
  CreateEventState _getNewInstanceOfCurrentState() {
    if (this.state is CreateEventValid) {
      return CreateEventValid(this._eventModel);
    } // if

    // See create_event_state.dart for more states if necessary
    return CreateEventInvalid(this._eventModel);
  } // _getNewInstanceOfCurrentState

  /// Name: isValid
  ///
  /// Description: Verifies that the new event contains the minimal attributes:
  ///                - title
  ///                - host
  ///                - location
  ///                - start time
  ///                - category
  ///
  /// Returns: a valid bloc state if the event has the
  ///          minimal attributes, otherwise an invalid bloc state.
  ///
  /// Design Notes:
  ///
  CreateEventState isValid() {
    // Valid
    if (this._eventModel.category.trim().isNotEmpty &&
        this._eventModel.title.trim().isNotEmpty &&
        this._eventModel.host.trim().isNotEmpty &&
        this._eventModel.location.trim().isNotEmpty &&
        (this._eventModel.rawStartDateAndTime != null)) {
      return CreateEventValid(this._eventModel); // Return Valid Bloc State
    } // if

    else {
      return CreateEventInvalid(this._eventModel); // Return Invalid Bloc State
    } // else
  } // isValid

  /// Name: isValidEndDate
  ///
  /// Description: Verifies is the END date chosen is a non-null
  ///              date time that occurs BEFORE the START date time.
  ///
  /// Returns: The "next" button will be inactive is this returns false
  ///
  /// Design Notes: Send an [CreateEventRemoveRawEndDateTime] in order to
  ///               set the raw end date time to "null", thereby removing it.
  ///
  /// TODO: Change name to "hasValidEndDate" to better reflect that the end date is an attribute of the CreateEventBloc
  bool isValidEndDate() {
    // See isValidEndDate design note for why "null" is valid
    if (this._eventModel.rawEndDateAndTime == null) {
      return true;
    } // if

    // Make sure non-null end date time occurs BEFORE the start date time
    if (this
        ._eventModel
        .rawStartDateAndTime
        .isBefore(this._eventModel.rawEndDateAndTime)) {
      return true;
    } // if
    return false;
  } // isValidEndDate

  // TODO: Remove print when Create Event Bloc changes
  @override
  void onChange(Change<CreateEventState> change) {
    print('Create Event Bloc $change');
    super.onChange(change);
  } // onChange

  // TODO: Remove print when Create Event Bloc is closed
  @override
  Future<void> close() {
    print('Create Event Bloc Closed!');
    return super.close();
  } // close
} // CreateEventBloc
