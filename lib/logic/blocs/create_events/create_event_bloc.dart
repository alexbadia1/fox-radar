import 'dart:async';
import 'dart:typed_data';
import 'package:fox_radar/logic/logic.dart';
import 'package:database_repository/database_repository.dart';

class CreateEventBloc extends Bloc<CreateEventEvent, CreateEventState> {
  late EventModel _eventModel;
  final DatabaseRepository db;
  final CreateEventState initialCreateEventState;

  CreateEventBloc({required this.db, required this.initialCreateEventState})
      : super(initialCreateEventState) {
    on<CreateEventSetEvent>(_mapCreateEventSetEventToState);
    on<CreateEventSetTitle>(_mapCreateEventSetTitleToState);
    on<CreateEventSetHost>(_mapCreateEventSetHostToState);
    on<CreateEventSetLocation>(_mapCreateEventSetLocationToState);
    on<CreateEventSetRoom>(_mapCreateEventSetRoomToState);
    on<CreateEventSetDescription>(_mapCreateEventSetDescriptionToState);
    on<CreateEventSetRawStartDateTime>(
      _mapCreateEventSetRawStartDateTimeToState,
    );
    on<CreateEventSetRawEndDateTime>(_mapCreateEventSetRawEndDateTimeToState);
    on<CreateEventRemoveRawEndDateTime>(_mapCreateEventRemoveRawEndDateTime);
    on<CreateEventSetCategory>(_mapCreateEventSetCategoryToState);
    on<CreateEventAddHighlight>(_mapCreateEventAddHighlightToState);
    on<CreateEventRemoveHighlight>(_mapCreateEventRemoveHighlightToState);
    on<CreateEventSetHighlight>(_mapCreateEventSetHighlightToState);
    on<CreateEventSetImage>(_mapCreateEventSetImageToState);
    on<CreateEventSetImageFitCover>(_mapCreateEventSetImageFitCoverToState);
    on<CreateEventSetImagePath>(_mapCreateEventSetImagePathToState);

    this._eventModel = this.state.eventModel;
  }

  void _mapCreateEventSetEventToState(
    CreateEventSetEvent? createEventSetEvent,
    Emitter<CreateEventState> emitter,
  ) {
    if (createEventSetEvent != null) {
      this._eventModel = createEventSetEvent.eventModel;
    }
    emitter(isValid());
  }

  void _mapCreateEventSetTitleToState(
    CreateEventSetTitle createEventSetTitle,
    Emitter<CreateEventState> emitter,
  ) {
    if (createEventSetTitle.newTitle.trim().isEmpty) {
      this._eventModel = this._eventModel.copyWith(title: '');
    } else {
      this._eventModel =
          this._eventModel.copyWith(title: createEventSetTitle.newTitle.trim());
    }
    emitter(isValid());
  }

  void _mapCreateEventSetHostToState(
    CreateEventSetHost createEventSetHost,
    Emitter<CreateEventState> emitter,
  ) {
    if (createEventSetHost.newHost.trim().isEmpty) {
      this._eventModel = this._eventModel.copyWith(host: '');
    } else {
      this._eventModel =
          this._eventModel.copyWith(host: createEventSetHost.newHost.trim());
    }
    emitter(isValid());
  }

  void _mapCreateEventSetLocationToState(
    CreateEventSetLocation createEventSetLocation,
    Emitter<CreateEventState> emitter,
  ) {
    if (createEventSetLocation.newLocation.trim().isEmpty) {
      this._eventModel = this._eventModel.copyWith(location: '');
    } else {
      this._eventModel = this
          ._eventModel
          .copyWith(location: createEventSetLocation.newLocation.trim());
    }
    emitter(isValid());
  }

  void _mapCreateEventSetRoomToState(
    CreateEventSetRoom createEventSetRoom,
    Emitter<CreateEventState> emitter,
  ) {
    if (createEventSetRoom.newRoom.trim().isEmpty) {
      this._eventModel = this._eventModel.copyWith(room: '');
    } else {
      this._eventModel =
          this._eventModel.copyWith(room: createEventSetRoom.newRoom.trim());
    }
    emitter(this._getNewInstanceOfCurrentState());
  }

  void _mapCreateEventSetDescriptionToState(
    CreateEventSetDescription createEventSetDescription,
    Emitter<CreateEventState> emitter,
  ) {
    if (createEventSetDescription.newDescription.trim().isEmpty) {
      this._eventModel = this._eventModel.copyWith(description: '');
    } else {
      this._eventModel = this._eventModel.copyWith(
          description: createEventSetDescription.newDescription.trim());
    }
    emitter(this._getNewInstanceOfCurrentState());
  }

  // TODO: Consider checking isValidEndDate in the BloC itself
  void _mapCreateEventSetRawStartDateTimeToState(
    CreateEventSetRawStartDateTime createEventSetRawStartDateTime,
    Emitter<CreateEventState> emitter,
  ) {
    if (createEventSetRawStartDateTime.newRawStartDateTime != null) {
      this._eventModel = this._eventModel.copyWith(
          rawStartDateAndTime:
              createEventSetRawStartDateTime.newRawStartDateTime);
    } else {
      this._eventModel =
          this._eventModel.copyWith(rawStartDateAndTime: DateTime.now());
    }
    emitter(isValid());
  }

  // TODO: Consider checking isValidEndDate in the BloC itself
  void _mapCreateEventSetRawEndDateTimeToState(
    CreateEventSetRawEndDateTime createEventSetRawEndDateTime,
    Emitter<CreateEventState> emitter,
  ) {
    if (createEventSetRawEndDateTime.newRawEndDateTime != null) {
      this._eventModel = this._eventModel.copyWith(
          rawEndDateAndTime: createEventSetRawEndDateTime.newRawEndDateTime);
    } else {
      this._eventModel =
          this._eventModel.copyWith(rawEndDateAndTime: DateTime.now());
    }
    emitter(this._getNewInstanceOfCurrentState());
  }

  void _mapCreateEventRemoveRawEndDateTime(
    CreateEventRemoveRawEndDateTime e,
    Emitter<CreateEventState> emitter,
  ) {
    this._eventModel = this._eventModel.copyWith(endDate: '', endTime: '');
    emitter(this._getNewInstanceOfCurrentState());
  }

  void _mapCreateEventSetCategoryToState(
    CreateEventSetCategory createEventSetCategory,
    Emitter<CreateEventState> emitter,
  ) {
    if (createEventSetCategory.category != null) {
      this._eventModel =
          this._eventModel.copyWith(category: createEventSetCategory.category);
    } else {
      this._eventModel = this._eventModel.copyWith(category: ACADEMIC);
    }
    emitter(isValid());
  }

  void _mapCreateEventAddHighlightToState(
    CreateEventAddHighlight createEventAddHighlight,
    Emitter<CreateEventState> emitter,
  ) {
    // Dart passes array's by reference, so "clone" the array into a new one
    // in order to ensure the new event model object is using a "new" reference
    List<String> _highlightList = [];
    _highlightList.addAll(this._eventModel.highlights!);

    if (createEventAddHighlight.highlight != null) {
      // TODO: Create a  limits constant, preferably defined in the event model
      if (_highlightList.length < 6) {
        _highlightList.add(createEventAddHighlight.highlight);
        this._eventModel =
            this._eventModel.copyWith(highlights: _highlightList);
      }
    } else {
      this._eventModel = this._eventModel.copyWith(highlights: _highlightList);
    }
    emitter(this._getNewInstanceOfCurrentState());
  }

  void _mapCreateEventRemoveHighlightToState(
    CreateEventRemoveHighlight createEventRemoveHighlight,
    Emitter<CreateEventState> emitter,
  ) {
    // Dart passes array's by reference, so "clone" the array into a new one
    // in order to ensure the new event model object is using a "new" reference
    List<String> _highlightList = [];
    _highlightList.addAll(this._eventModel.highlights!);

    if (createEventRemoveHighlight.index != null) {
      // Obviously can't remove items from an empty list
      if (_highlightList.length > 0) {
        _highlightList.removeAt(createEventRemoveHighlight.index);
        this._eventModel =
            this._eventModel.copyWith(highlights: _highlightList);
      }
    } else {
      this._eventModel = this._eventModel.copyWith(highlights: _highlightList);
    }
    emitter(this._getNewInstanceOfCurrentState());
  }

  void _mapCreateEventSetHighlightToState(
    CreateEventSetHighlight createEventSetHighlight,
    Emitter<CreateEventState> emitter,
  ) {
    final List<String> _highlightList = this._eventModel.highlights ?? [];

    // Not empty highlight
    if (createEventSetHighlight.index != null) {
      _highlightList[createEventSetHighlight.index] =
          createEventSetHighlight.highlight ?? '';
      this._eventModel = this._eventModel.copyWith(highlights: _highlightList);
    }
    emitter(this._getNewInstanceOfCurrentState());
  }

  void _mapCreateEventSetImageToState(
    CreateEventSetImage createEventSetImage,
    Emitter<CreateEventState> emitter,
  ) {
    final Uint8List _bytes = createEventSetImage.imageBytes;

    // Not empty highlight
    if (_bytes != null) {
      this._eventModel = this._eventModel.copyWith(imageBytes: _bytes);
    }
    emitter(this._getNewInstanceOfCurrentState());
  }

  void _mapCreateEventSetImageFitCoverToState(
    CreateEventSetImageFitCover createEventSetImageFitCover,
    Emitter<CreateEventState> emitter,
  ) {
    // The image fit is defaulted to "cover: true"
    if (createEventSetImageFitCover.fitCover != null) {
      this._eventModel = this
          ._eventModel
          .copyWith(imageFitCover: createEventSetImageFitCover.fitCover);
    }

    emitter(this._getNewInstanceOfCurrentState());
  }

  void _mapCreateEventSetImagePathToState(
    CreateEventSetImagePath createEventSetImagePath,
    Emitter<CreateEventState> emitter,
  ) {
    if (createEventSetImagePath.imagePath != null) {
      print("Setting image path ${createEventSetImagePath.imagePath}");
      this._eventModel = this
          ._eventModel
          .copyWith(imagePath: createEventSetImagePath.imagePath);
    }

    emitter(this._getNewInstanceOfCurrentState());
  }

  // TODO: Investigate splitting each attribute of the form into cubits
  CreateEventState _getNewInstanceOfCurrentState() {
    if (this.state is CreateEventValid) {
      return CreateEventValid(this._eventModel);
    }

    return CreateEventInvalid(this._eventModel);
  }

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
  CreateEventState isValid() {
    // Valid
    if (this._eventModel.category!.trim().isNotEmpty &&
        this._eventModel.title!.trim().isNotEmpty &&
        this._eventModel.host!.trim().isNotEmpty &&
        this._eventModel.location!.trim().isNotEmpty &&
        (this._eventModel.rawStartDateAndTime != null)) {
      return CreateEventValid(this._eventModel); // Return Valid Bloc State
    } else {
      return CreateEventInvalid(this._eventModel); // Return Invalid Bloc State
    }
  }

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
    }

    // Make sure non-null end date time occurs BEFORE the start date time
    if (this
        ._eventModel
        .rawStartDateAndTime!
        .isBefore(this._eventModel.rawEndDateAndTime!)) {
      return true;
    }
    return false;
  }

  @override
  void onChange(Change<CreateEventState> change) {
    print('Create Event Bloc $change');
    super.onChange(change);
  }

  @override
  Future<void> close() {
    return super.close();
  }
}
