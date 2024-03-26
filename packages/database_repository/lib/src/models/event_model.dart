import 'dart:typed_data';
import 'package:intl/intl.dart';

class EventModel {
  /// Event Title (required)
  late String? _title;

  /// Event Host (Required)
  late String? _host;

  /// Event Location (Required)
  ///
  /// Typically a building on campus, can include
  /// locations like "Beach", "River", "Campus Green".
  late String? _location;

  /// Event Room (Optional)
  ///
  /// Typically a room number of some sort.
  late String? _room;

  /// Raw Event Start Date (Required)
  DateTime? _rawStartDateAndTime;

  /// Event Start Date (Required)
  ///
  /// The start date is parsed from the [rawStartDateAndTime] stored in firebase.
  late String? _startDate;

  /// Event Start Time (Required)
  ///
  /// The start time is parsed from the [rawStartDateAndTime] stored in firebase.
  late String? _startTime;

  /// Raw Event End Date (Optional)
  DateTime? _rawEndDateAndTime;

  /// Event End Date (Optional)
  ///
  /// The end date is parsed from the [rawEndDateAndTime] stored in firebase.
  late String? _endDate;

  /// Event End Time (Optional)
  ///
  /// The end time is parsed from the [rawEndDateAndTime] stored in firebase.
  late String? _endTime;

  /// Event Category (Required)
  late String? _category;

  /// A list of highlights of the event, cannot exceed [5] (Optional)
  ///
  /// For example:
  ///   - Food
  ///   - Prioirity Points
  ///   - Ping Pong
  ///   - Music
  ///   - etc.
  late List<String>? _highlights;

  /// An in depth description of the event, and what it's about
  late String? _description;

  /// Image stored in firebase storage buckets (Optional)
  late Uint8List? _imageBytes;

  /// Whether the image should be scaled to fit the aspect
  /// ratio of the card that is displayed in search results.
  ///
  /// Automatically set when a user chooses an image.
  late bool? _imageFitCover;

  /// The path to the firebase storage bucket where the image is stored
  late String? _imagePath;

  /// Document ID of event in the "Events Collection"
  /// That contains all of the details of the event.
  late String? _eventID;

  /// Account ID of of the Account that created this event
  late String? _accountID;

  final bool defaultImageFitCover = false;

  /// Full Constructor
  EventModel(
      {String? newHost,
        String? newTitle,
        String? newLocation,
        String?  newRoom,
        DateTime? newRawStartDateAndTime,
        DateTime? newRawEndDateAndTime,
        String? newCategory,
        List<String>? newHighlights,
        String? newDescription,
        Uint8List? newImageBytes,
        bool? newImageFitCover,
        String? newImagePath,
        String? newEventID,
        String? newSearchID,
        String? newAccountID,
        String? newPinnedID}) {

    this._title = newTitle;
    this._host = newHost;
    this._location = newLocation;
    this._room = newRoom;

    // Parse the Start DATE from [rawStartDateAndTime]
    this._rawStartDateAndTime = newRawStartDateAndTime;
    newRawStartDateAndTime == null
        ? this._startDate = ''
        : this._startDate =
            DateFormat('E, MMMM d, y').format(newRawStartDateAndTime);

    // Parse the  Start TIME from [rawStartDateAndTime]
    newRawStartDateAndTime == null
        ? this._startTime = ''
        : this._startTime = DateFormat.jm().format(newRawStartDateAndTime);

    // Parse the End DATE from [rawEndDateAndTime]
    this._rawEndDateAndTime = newRawEndDateAndTime;
    newRawEndDateAndTime == null
        ? this._endDate = ''
        : this._endDate =
            DateFormat('E, MMMM d, y').format(newRawEndDateAndTime);

    // Parse the  End TIME from [newRawEndDateAndTime]
    newRawEndDateAndTime == null
        ? this._endTime = ''
        : this._endTime = DateFormat.jm().format(newRawEndDateAndTime);

    this._category = newCategory;
    this._highlights = newHighlights;
    this._description = newDescription;
    this._imageBytes = newImageBytes;
    this._imageFitCover = newImageFitCover;
    this._imagePath = newImagePath;
    this._eventID = newEventID;
    this._accountID = newAccountID;
  }

  /// Null Constructor
  EventModel.nullConstructor() {
    this._title = '';
    this._host = '';
    this._location = '';
    this._room = '';
    this._category = '';
    this._highlights = [];
    this._description = '';
    this._imageBytes = null;
    this._imageFitCover = false;
    this._imagePath = '';
    this._eventID = '';
    this._accountID = '';

    this._rawStartDateAndTime = DateTime.now();
    this._startDate =
        DateFormat('E, MMMM d, y').format(this._rawStartDateAndTime!);
    this._startTime = DateFormat.jm().format(this._rawStartDateAndTime!);

    this._rawEndDateAndTime = null;
    this._endDate = '';
    this._endTime = '';
  }

  /// Copies all of the objects attributes into a new instance of the
  /// object, allowing specified attributes to be changed while copying.
  ///
  /// Null values are used to indicate to copy
  /// previous attributes to the new object instance.
  ///
  /// Pass in empty strings to end date and
  /// end time, to set rawEndDateAndTime to null.
  copyWith({
    String? title,
    String? host,
    String? location,
    String? room,
    DateTime? rawStartDateAndTime,
    String? startDate,
    String? startTime,
    DateTime? rawEndDateAndTime,
    String? endDate,
    String? endTime,
    String? category,
    List<String>? highlights,
    String? description,
    Uint8List? imageBytes,
    bool? imageFitCover,
    String? imagePath,
    String? eventID,
    String? searchID,
    String? accountID,
    String? pinnedID,
  }) {
    // Use previous rawEndDateAndTime
    if (rawEndDateAndTime == null) {
      rawEndDateAndTime = this._rawEndDateAndTime;
    }

    // If the endDate and endTime are set to empty string
    // Override the rawEndDateAndTime to 'null'
    if (endDate == '' && endTime == '') {
      rawEndDateAndTime = null;
    }

    return EventModel(
      newTitle: title ?? this._title,
      newHost: host ?? this._host,
      newLocation: location ?? this._location,
      newRoom: room ?? this._room,
      newRawStartDateAndTime: rawStartDateAndTime ?? this._rawStartDateAndTime,
      newRawEndDateAndTime: rawEndDateAndTime,
      newCategory: category ?? this._category,
      newHighlights: highlights ?? this._highlights,
      newDescription: description ?? this._description,
      newImageBytes: imageBytes ?? this._imageBytes,
      newImageFitCover: imageFitCover ?? this._imageFitCover,
      newImagePath: imagePath ?? this._imagePath,
      newEventID: eventID ?? this._eventID,
      newAccountID: accountID ?? this._accountID,
    );
  }

  String? get title => this._title;
  String? get host => this._host;
  String? get location => this._location;
  String? get room => this._room;
  DateTime? get rawStartDateAndTime => this._rawStartDateAndTime;
  String? get startDate => this._startDate;
  String? get startTime => this._startTime;
  DateTime? get rawEndDateAndTime => this._rawEndDateAndTime;
  String? get endDate => this._endDate;
  String? get endTime => this._endTime;
  String? get category => this._category;
  List<String>? get highlights => this._highlights;
  String? get description => this._description;
  Uint8List? get imageBytes => this._imageBytes;
  bool? get imageFitCover => this._imageFitCover;
  String? get imagePath => this._imagePath;
  String? get eventID => this._eventID;
  String? get accountID => this._accountID;

  set imagePath(String? value) {
    this._imagePath = value;
  }

  set imageBytes(Uint8List? newImageBytes) {
    this._imageBytes = newImageBytes;
  }

  set eventID(String? value) {
    this._eventID = value;
  }

  set accountID(String? value) {
    this._accountID = value;
  }

  @override
  String toString() {
    return "{\n"
        "\tTitle: ${this._title}\n"
        "\tHost: ${this._host}\n"
        "\tLocation: ${this._location}\n"
        "\tRoom: ${this._room}\n"
        "\tStart: ${this._rawStartDateAndTime}\n"
        "\tEnd: ${this._rawEndDateAndTime}\n"
        "\tCategory: ${this._category}\n"
        "\tHighlights: ${this._highlights}\n"
        "\tDescription: ${this._description}\n"
        "\tImage Bytes ${this._imageBytes}\n"
        "\tImage Fit Cover:  ${this.imageFitCover}\n"
        "\tImage Path: ${this._imagePath}\n"
        "\tEvent ID (Events Collection): ${this._eventID}\n"
        "\tAccount ID (Owner of Event): ${this._accountID}\n"
        "}\n";
  }
}
