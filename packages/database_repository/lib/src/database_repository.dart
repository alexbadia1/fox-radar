import 'dart:typed_data';
import 'models/models.dart';
import 'package:meta/meta.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:database_repository/database_repository.dart';

class DatabaseRepository {
  // Singleton
  static final DatabaseRepository _db = DatabaseRepository._internal();
  DatabaseRepository._internal();
  factory DatabaseRepository() {
    return _db;
  } // DatabaseRepository

  // Collection References
  final CollectionReference _eventsCollection = FirebaseFirestore.instance.collection(COLLECTION_EVENTS);
  final CollectionReference _searchEventsCollection = FirebaseFirestore.instance.collection(COLLECTION_SEARCH_EVENTS);
  final CollectionReference _userCreatedEventsCollection = FirebaseFirestore.instance.collection(COLLECTION_USER_CREATED_EVENTS);
  final CollectionReference _userSavedEventsCollection = FirebaseFirestore.instance.collection(COLLECTION_USER_SAVED_EVENTS);

  /// Retrieves events from the "Search Events Collection" based on
  /// [category] and returns a [QueryDocumentSnapshot] with the events.
  ///
  /// For pagination, continues query starting after the [lastEvent]
  /// and returns a number documents no bigger thant the [limit].
  Future<List<QueryDocumentSnapshot>> searchEventsByCategory(
      {@required String category, @required QueryDocumentSnapshot lastEvent, @required int limit}) async {
    QuerySnapshot querySnap;

    if (lastEvent != null) {
      querySnap = await _searchEventsCollection.where(ATTRIBUTE_CATEGORY, isEqualTo: category).startAfterDocument(lastEvent).limit(limit).get();
    } // if

    else {
      querySnap = await _searchEventsCollection.where(ATTRIBUTE_CATEGORY, isEqualTo: category).limit(limit).get();
    } // else

    return querySnap.docs;
  } // searchEventsByCategory

  /// Retrieves events from the "Search Events Collection"
  /// by [rawStartDateAndTime] and returns a [QueryDocumentSnapshot]
  /// with the events that start at or after the current [DateTime.now].
  ///
  /// For pagination, continues query starting after the [lastEvent]
  /// and returns a number documents no bigger thant the [limit].
  Future<List<QueryDocumentSnapshot>> searchEventsByStartDateAndTime({@required QueryDocumentSnapshot lastEvent, @required int limit}) async {
    QuerySnapshot querySnap;

    if (lastEvent != null) {
      querySnap = await _searchEventsCollection
          .where(ATTRIBUTE_RAW_START_DATE_TIME, isGreaterThanOrEqualTo: DateTime.now())
          .startAfterDocument(lastEvent)
          .limit(limit)
          .get();
    } // if

    else {
      querySnap = await _searchEventsCollection.where(ATTRIBUTE_RAW_START_DATE_TIME, isGreaterThanOrEqualTo: DateTime.now()).limit(limit).get();
    } // else

    return querySnap.docs;
  } // searchEventsByStartDateAndTime

  Future<List<String>> getAccountEvents({@required String uid}) async {
    final DocumentSnapshot docSnap = await _userCreatedEventsCollection.doc(uid).get();
    try {
      // TODO: Move this to account events bloc,
      // Maybe do this on another isolate>
      final Map m = docSnap.data() as Map;
      final List<String> docIds = [];
      m.forEach((attribute, boolVal) {
        if (attribute is String) {
          if (attribute != ATTRIBUTE_PIN_COUNT) {
            docIds.add(attribute);
          } // if
        } // if
      });

      return docIds;
    } // try
    catch (e) {
      print(e);
      return null;
    } //catch
  } // getAccountEvents

  Future<DocumentSnapshot> getSearchEventById({@required String eventId}) async {
    try {
      final DocumentSnapshot docSnap = await _searchEventsCollection.doc(eventId).get();
      return docSnap;
    }// try

    catch(e) {
      print("[getSearchEventById] ${e.toString()}");
      return null;
    }// catch
  }// getAccountEvent

  /// Retrieves events from the "User Created Events Collection > UserID > Created Events
  /// Collection" returns a [QueryDocumentSnapshot] of events belonging to the [accountID].
  ///
  /// For pagination, continues query starting after the [lastEvent]
  /// and returns a number documents no bigger thant the [limit].
  Future<List<QueryDocumentSnapshot>> getAccountEventsDeprecated(
      {@required String accountID, @required QueryDocumentSnapshot lastEvent, @required int limit}) async {
    QuerySnapshot querySnap;

    // Continue querying from where you left off
    if (lastEvent != null) {
      querySnap = await _userCreatedEventsCollection
          .doc(accountID)
          .collection(SUB_COLLECTION_CREATED_EVENTS)
          .startAfterDocument(lastEvent)
          .limit(limit)
          .get();
    } // if

    // First query
    else {
      querySnap = await _userCreatedEventsCollection.doc(accountID).collection(SUB_COLLECTION_CREATED_EVENTS).limit(limit).get();
    } // else

    return querySnap.docs;
  } // searchEventsByAccount

  Future<DocumentSnapshot> getEventFromEventsCollection({@required String documentId}) async {
    return await _eventsCollection.doc(documentId).get();
  } // getEventsFromEventsCollection

  /// Creates a new "Event" in firebase
  ///
  /// Batched is used to ensure atomicity, due to the denormalized structure of the database.
  Future<String> createEvent(EventModel newEvent, String userId) async {
    try {
      final WriteBatch _batch = FirebaseFirestore.instance.batch();

      // Generate a new ID, without necessarily creating a document
      final DocumentReference _eventsDocRef = _eventsCollection.doc();

      /// Add the event to the "Events" Collection:
      ///
      /// events : {
      ///   eventId: {
      ///     title: <String>,
      ///     host: <String>,
      ///     location: <String>,
      ///     room: [<String>],
      ///     category: <String>
      ///     rawStartDateAndTime: <firebase_timestamp>,
      ///     rawEndDateAndTime: [<firebase_timestamp>],
      ///     highlights: [List<String>],
      ///     description: [<String>],
      ///     imageFitCover: <bool>
      ///   },
      ///   eventId: {...},
      ///   ...
      /// }
      final String _eventsId = _eventsDocRef.id;

      /// No longer necessary to include empty fields, if they're
      /// null, assume default values on front end when parsing.
      final attributeMap = this.eventModelToMap(newEvent);
      _batch.set(_eventsDocRef, attributeMap);

      /// Add the event to the "Search" Collection:
      ///
      /// searchEvents : {
      ///   searchEventId: {
      ///     title: <String>,
      ///     host: <String>,
      ///     location: <String>,
      ///     category: <String>
      ///     rawStartDateAndTime: <firebase_timestamp>,
      ///     eventId: <String>
      ///   },
      ///   searchEventId: {...},
      ///   ...
      /// }
      final DocumentReference searchEventsDocRef = _searchEventsCollection.doc(_eventsId);
      _batch.set(searchEventsDocRef, {
        ATTRIBUTE_TITLE: newEvent.title.toUpperCase() ?? '',
        ATTRIBUTE_HOST: newEvent.host.toLowerCase() ?? '',
        ATTRIBUTE_LOCATION: newEvent.location.toLowerCase() ?? '',
        ATTRIBUTE_CATEGORY: newEvent.category ?? '',
        ATTRIBUTE_RAW_START_DATE_TIME: newEvent.rawStartDateAndTime ?? null
      });

      /// userCreatedEvents : {
      ///   uid: {
      ///     event_id: true,
      ///     event_id: true,
      ///     event_id: true,
      ///     ...
      ///   },
      ///   uid: {
      ///     event_id: true,
      ///   },
      ///   uid: {...},
      ///   ...
      /// }
      final DocumentReference _accountEventsDocRef = _userCreatedEventsCollection.doc(userId);
      _batch.update(_accountEventsDocRef, {
        // TODO: Verify update can be used here!
        _eventsId: true,
      });
      await _batch.commit();
      return _eventsId;
    } // try
    catch (e) {
      print(e);
      return null;
    } // catch
  } // createEvent

  /// Updates an existing "Event" in firebase
  ///
  /// Batched is used to ensure atomicity, due
  /// to the denormalized structure of the database.
  Future<void> updateEvent(EventModel newEvent) async {
    final WriteBatch _batch = FirebaseFirestore.instance.batch();
    // Can't update any of them
    if (newEvent.eventID == null) {
      return;
    } // if

    // Can't update any of them
    if (newEvent.eventID.replaceAll(" ", "") == "") {
      return;
    } // if

    // Get document references based on id
    final DocumentReference _eventsDocRef = _eventsCollection.doc(newEvent.eventID);
    final DocumentReference _searchEventsDocRef = _searchEventsCollection.doc(newEvent.eventID);

    /// No longer necessary to include empty fields, if they're
    /// null assume default values on front end when parsing.
    final attributeMap = this.eventModelToMap(newEvent);
    _batch.update(_eventsDocRef, attributeMap);

    _batch.update(_searchEventsDocRef, {
      ATTRIBUTE_TITLE: newEvent.title.toUpperCase() ?? '',
      ATTRIBUTE_HOST: newEvent.host.toLowerCase() ?? '',
      ATTRIBUTE_LOCATION: newEvent.location.toLowerCase() ?? '',
      ATTRIBUTE_CATEGORY: newEvent.category ?? '',
      ATTRIBUTE_RAW_START_DATE_TIME: newEvent.rawStartDateAndTime ?? null,
    });
    await _batch.commit();
  } // updateEvent

  /// Saves an existing "Event" in firebase
  ///
  /// Batched is used to ensure atomicity, due
  /// to the denormalized structure of the database.
  Future<void> pinEvent(String eventId, String userId) async {
    // User's doc containing all saved events and a count
    final DocumentReference docRef = this._userSavedEventsCollection.doc(userId);

    FirebaseFirestore.instance.runTransaction((transaction) async {
      final DocumentSnapshot docSnap = await transaction.get(docRef);

      if (!docSnap.exists) {
        return; // Tell user they are pinning a non-existent event
      } // if

      final int count = docSnap.get(ATTRIBUTE_PIN_COUNT);
      if (count > 1000) {
        return; // Tell user they've hit the max events
      } // if

      // All good!
      //
      // Pin event and increase number of pinned events
      transaction.update(docRef, {
        eventId: true,
        ATTRIBUTE_PIN_COUNT: (count + 1),
      });
    });
  } // updateEvent

  /// Deletes an existing "Event" in firebase
  ///
  /// Batched is used to ensure atomicity, due to the denormalized structure of the database.
  Future<void> deleteEvent(String eventId, String userId) async {
    try {
      // User's doc containing all saved events and a count
      final WriteBatch _batch = FirebaseFirestore.instance.batch();

      // Get document references
      final DocumentReference eventDocRef = _eventsCollection.doc(eventId);
      final DocumentReference searchEventDocRef = _searchEventsCollection.doc(eventId);
      final DocumentReference createdEventDocRef = _userCreatedEventsCollection.doc(userId);
      final DocumentReference pinnedEventDocRef = _userSavedEventsCollection.doc(userId);

      // Delete
      _batch.delete(eventDocRef);
      _batch.delete(searchEventDocRef);
      _batch.update(pinnedEventDocRef, {eventId: FieldValue.delete(), ATTRIBUTE_PIN_COUNT: FieldValue.increment(-1)});
      _batch.update(pinnedEventDocRef, {eventId: FieldValue.delete(), ATTRIBUTE_PIN_COUNT: FieldValue.increment(-1)});

      _batch.commit();
    } // try
    catch (e) {
      print(e);
    } // catch
  } // deleteEvent

  /// Attempts to upload an image to firebase storage
  /// using the document id of the event as the image name.
  ///
  /// Overwrites existing files (useful for updating an image).
  ///
  /// Returns a listenable upload task, to show upload progress.
  UploadTask uploadImageToStorage({@required String eventID, @required Uint8List imageBytes}) {
    try {
      return FirebaseStorage.instance.ref().child(this.imagePath(eventID: eventID)).putData(imageBytes);
    } // try
    catch (e) {
      return null;
    } // catch
  } // uploadImageToStorage

  /// Attempts to delete an image uploaded to firebase
  /// using the document id of the event as the image name.
  ///
  /// Returns a listenable upload task, to show upload progress.
  Future<void> deleteImageFromStorage({@required String eventID}) {
    try {
      return FirebaseStorage.instance.ref().child(this.imagePath(eventID: eventID)).delete();
    } // try
    catch (e) {
      return null;
    } // catch
  } // uploadImageToStorage

  Future<Uint8List> getImageFromStorage({@required String eventID}) async {
    try {
      return await FirebaseStorage.instance.ref().child(this.imagePath(eventID: eventID)).getData(4194304);
    } // try
    catch (e) {
      return null;
    } // catch
  } // getEventFromEventsCollection

  String imagePath({@required String eventID}) {
    return 'events/$eventID.jpg';
  } // _getGenerateImagePath

  Map<String, dynamic> eventModelToMap(EventModel eventModel) {
    final _map = Map<String, dynamic>();

    /// Required fields
    _map[ATTRIBUTE_TITLE] = eventModel.title ?? '';
    _map[ATTRIBUTE_HOST] = eventModel.host ?? '';
    _map[ATTRIBUTE_LOCATION] = eventModel.location ?? '';
    _map[ATTRIBUTE_RAW_START_DATE_TIME] = eventModel.rawStartDateAndTime ?? '';
    _map[ATTRIBUTE_CATEGORY] = eventModel.category ?? '';
    _map[ATTRIBUTE_IMAGE_FIT_COVER] = eventModel.imageFitCover ?? false;

    /// Optional fields
    if (eventModel.room != null) {
      if (eventModel.room.replaceAll(" ", '') != "") {
        _map[ATTRIBUTE_ROOM] = eventModel.room;
      } // if
    } // if

    if (eventModel.rawEndDateAndTime != null) {
      _map[ATTRIBUTE_RAW_END_DATE_TIME] = eventModel.rawEndDateAndTime;
    } // if

    if (eventModel.highlights != null) {
      _map[ATTRIBUTE_HIGHLIGHTS] = eventModel.highlights;
    } // if

    if (eventModel.description != null) {
      if (eventModel.description.replaceAll(" ", '') != "") {
        _map[ATTRIBUTE_DESCRIPTION] = eventModel.description;
      } // if
    } // if

    if (eventModel.imageFitCover != null) {
      _map[ATTRIBUTE_IMAGE_FIT_COVER] = eventModel.imageFitCover;
    } // if

    return _map;
  } // eventModelToMap
} //class
