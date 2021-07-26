import 'package:intl/intl.dart';

/// Models each "Searchable Event" document in the "Search Events" collection.
///
/// A variation of the [EventModel] instead, only including the
/// minimal details of the event in order to optimize searching for events.
class SearchResultModel {
  /// Event Title (required)
  String _title = '[Event Title]';

  /// Event Host (Required)
  String _host = '[Event Host]';

  /// Event Location (Required)
  ///
  /// Typically a building on campus, can include
  /// locations like "Beach", "River", "Campus Green".
  String _location = '[Event Location]';

  /// Event Start Date (Required)
  ///
  /// The start date is parsed from the [rawStartDateAndTime] stored in firebase.
  String _startDate = '[Event Start Date]';

  /// Event Start Time (Required)
  ///
  /// The start time is parsed from the [rawStartDateAndTime] stored in firebase.
  String _startTime = '[Event Start Time]';

  /// Event Category (Required)
  String _category = '[Event Category]';

  /// Used to decide the aspect ration of the image in the search results
  bool _imageFitCover = true;

  /// Document ID of event in the "Events Collection"
  /// That contains all of the details of the event.
  String _eventId = '[Event Id]';

  /// Account ID of of the Account that created this event
  String _accountID = '[Account ID]';

  /// Full Constructor
  SearchResultModel(
      {String newTitle,
      String newHost,
      String newLocation,
      DateTime newRawStartDateAndTime,
      String newCategory,
      bool newImageFitCover,
      String newEventId,
      String newAccountID}) {
    // Set the Event Title
    this._title = newTitle;

    // Set the Event Host
    this._host = newHost;

    // Set the Event Location
    this._location = newLocation;

    // Set the Event Category
    this._category = newCategory;

    // Parse the Start DATE from [rawStartDateAndTime]
    newRawStartDateAndTime == null
        ? this._startDate = ''
        : this._startDate =
            DateFormat('E, MMMM d, y').format(newRawStartDateAndTime);

    // Parse the  Start TIME from [rawStartDateAndTime]
    newRawStartDateAndTime == null
        ? this._startTime = ''
        : this._startTime = DateFormat.jm().format(newRawStartDateAndTime);

    // Decide if image should cover it's container
    this._imageFitCover = newImageFitCover;

    // Set the Event ID
    this._eventId = newEventId;

    // Set Account ID
    this._accountID = newAccountID;
  } // SearchResultModel

  String get getTitle => this._title;
  String get getHost => this._host;
  String get getLocation => this._location;
  String get myStartDate => this._startDate;
  String get myStartTime => this._startTime;
  String get myCategory => this._category;
  bool get getImageFitCover => this._imageFitCover;
  String get eventId => this._eventId;
  String get accountID => this._accountID;

  @override
  String toString() {
    return "{\n"
        "\tTitle: ${this._title}\n"
        "\tHost: ${this._host}\n"
        "\tLocation: ${this._location}\n"
        "\tStart Date: ${this._startDate}\n"
        "\tStart Time: ${this._startTime}\n"
        "\tCategory: ${this._category}\n"
        "\tImage Fit Cover: ${this._imageFitCover}\n"
        "\tEvent ID (Events Collection): ${this._eventId}\n"
        "\tAccount ID (Owner of Event): ${this._accountID}\n"
        "}\n";
  } // toString
} //class
