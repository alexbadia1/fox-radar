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

  /// Retrieves events from the "User Created Events Collection > UserID > Created Events
  /// Collection" returns a [QueryDocumentSnapshot] of events belonging to the [accountID].
  ///
  /// For pagination, continues query starting after the [lastEvent]
  /// and returns a number documents no bigger thant the [limit].
  Future<List<QueryDocumentSnapshot>> getAccountEvents(
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

  Future<Uint8List> getImageFromStorage({@required String eventID}) async {
    try {
      return await FirebaseStorage.instance.ref().child(this.imagePath(eventID: eventID)).getData(4194304);
    } // try
    catch (e) {
      return null;
    } // catch
  } // getEventFromEventsCollection

  /// Creates a new "Event" in firebase
  ///
  /// Batched is used to ensure atomicity, due
  /// to the denormalized structure of the database.
  Future<String> createEvent(EventModel newEvent, String userId) async {
    final WriteBatch _batch = FirebaseFirestore.instance.batch();

    // Create new documents in the "Events Collection" and "SearchEvents Collection"
    final DocumentReference _eventsDocRef = _eventsCollection.doc();
    final DocumentReference _searchEventsDocRef = _searchEventsCollection.doc();
    final DocumentReference _userCreatedEventsSubCollectionDocRef =
        _userCreatedEventsCollection.doc(userId).collection(SUB_COLLECTION_CREATED_EVENTS).doc();

    /// Add the event to the "Events" Collection:
    ///
    /// events : {
    ///   eventId: {
    ///     title: <String>,
    ///     host: <String>,
    ///     location: <String>,
    ///     room: <String>,
    ///     category: <String>
    ///     rawStartDateAndTime: <firebase_timestamp>,
    ///     rawEndDateAndTime: <firebase_timestamp>,
    ///     highlights: List<String>,
    ///     description: <String>,
    ///     imageFitCover: <bool>
    ///   },
    ///   eventId: {...},
    ///   ...
    /// }
    final String _eventsDocumentId = _eventsDocRef.id;
    final attributeMap = Map<String, dynamic>();

    /// Required fields
    attributeMap[ATTRIBUTE_TITLE] = newEvent.title ?? '';
    attributeMap[ATTRIBUTE_HOST] = newEvent.host ?? '';
    attributeMap[ATTRIBUTE_LOCATION] = newEvent.location ?? '';
    attributeMap[ATTRIBUTE_RAW_START_DATE_TIME] = newEvent.rawStartDateAndTime ?? '';
    attributeMap[ATTRIBUTE_CATEGORY] = newEvent.category ?? '';
    attributeMap[ATTRIBUTE_IMAGE_FIT_COVER] = newEvent.imageFitCover ?? false;

    /// Optional fields
    if (newEvent.room != null) {
      attributeMap[ATTRIBUTE_ROOM] = newEvent.room;
    } // if

    if (newEvent.rawEndDateAndTime != null) {
      attributeMap[ATTRIBUTE_RAW_END_DATE_TIME] = newEvent.rawEndDateAndTime;
    } // if

    if (newEvent.highlights != null) {
      attributeMap[ATTRIBUTE_HIGHLIGHTS] = newEvent.highlights;
    } // if

    if (newEvent.description != null) {
      attributeMap[ATTRIBUTE_DESCRIPTION] = newEvent.description;
    } // if

    if (newEvent.imageFitCover != null) {
      attributeMap[ATTRIBUTE_IMAGE_FIT_COVER] = newEvent.imageFitCover;
    } // if

    /// No longer necessary to include empty fields, if they're null assume default values on front end when parsing
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
    _batch.set(_searchEventsDocRef, {
      ATTRIBUTE_TITLE: newEvent.title.toUpperCase() ?? '',
      ATTRIBUTE_HOST: newEvent.host.toLowerCase() ?? '',
      ATTRIBUTE_LOCATION: newEvent.location.toLowerCase() ?? '',
      ATTRIBUTE_CATEGORY: newEvent.category ?? '',
      ATTRIBUTE_RAW_START_DATE_TIME: newEvent.rawStartDateAndTime ?? null,
      ATTRIBUTE_EVENT_ID: _eventsDocumentId ?? '',
    });

    /// Add the event to the "userCreatedEvents" Collection:
    ///
    /// userCreatedEvents : {
    ///   uid: {
    ///     createdEvents: {
    ///       title: <String>,
    ///       host: <String>,
    ///       location: <String>,
    ///       category: <String>
    ///       rawStartDateAndTime: <firebase_timestamp>,
    ///       eventId: <String>
    ///     },
    ///     id: {...},
    ///     ...
    ///   },
    ///   uid: {
    ///     event_id: true,
    ///   },
    ///   uid: {},
    ///   ...
    /// }
    _batch.set(_userCreatedEventsSubCollectionDocRef, {
      ATTRIBUTE_TITLE: newEvent.title.toUpperCase() ?? '',
      ATTRIBUTE_HOST: newEvent.host.toLowerCase() ?? '',
      ATTRIBUTE_LOCATION: newEvent.location.toLowerCase() ?? '',
      ATTRIBUTE_CATEGORY: newEvent.category ?? '',
      ATTRIBUTE_RAW_START_DATE_TIME: newEvent.rawStartDateAndTime ?? null,
      ATTRIBUTE_EVENT_ID: _eventsDocumentId,
      ATTRIBUTE_SEARCH_ID: _searchEventsDocRef.id
    });
    await _batch.commit();
    return _eventsDocumentId;
  } // createEvent

  /// Updates an existing "Event" in firebase
  ///
  /// Batched is used to ensure atomicity, due
  /// to the denormalized structure of the database.
  Future<void> updateEvent(EventModel newEvent, String userId) async {
    final WriteBatch _batch = FirebaseFirestore.instance.batch();
    // Can't update any of them
    if (newEvent.accountID == null || newEvent.searchID == null || newEvent.accountID == null) {
      return;
    } // if

    // Can't update any of them
    if (newEvent.accountID.replaceAll(" ", "") == "" || newEvent.searchID.replaceAll(" ", "") == "" || newEvent.accountID.replaceAll(" ", "") == "") {
      return;
    } // if

    // Get document references based on id
    final DocumentReference _eventsDocRef = _eventsCollection.doc(newEvent.eventID);
    final DocumentReference _searchEventsDocRef = _searchEventsCollection.doc(newEvent.searchID);
    final DocumentReference _userCreatedEventsSubCollectionDocRef =
        _userCreatedEventsCollection.doc(userId).collection(SUB_COLLECTION_CREATED_EVENTS).doc(newEvent.accountID);

    final attributeMap = Map<String, dynamic>();

    /// Required fields
    attributeMap[ATTRIBUTE_TITLE] = newEvent.title ?? '';
    attributeMap[ATTRIBUTE_HOST] = newEvent.host ?? '';
    attributeMap[ATTRIBUTE_LOCATION] = newEvent.location ?? '';
    attributeMap[ATTRIBUTE_RAW_START_DATE_TIME] = newEvent.rawStartDateAndTime ?? '';
    attributeMap[ATTRIBUTE_CATEGORY] = newEvent.category ?? '';
    attributeMap[ATTRIBUTE_IMAGE_FIT_COVER] = newEvent.imageFitCover ?? false;

    /// Optional fields
    if (newEvent.room != null) {
      attributeMap[ATTRIBUTE_ROOM] = newEvent.room;
    } // if

    if (newEvent.rawEndDateAndTime != null) {
      attributeMap[ATTRIBUTE_RAW_END_DATE_TIME] = newEvent.rawEndDateAndTime;
    } // if

    if (newEvent.highlights != null) {
      attributeMap[ATTRIBUTE_HIGHLIGHTS] = newEvent.highlights;
    } // if

    if (newEvent.description != null) {
      attributeMap[ATTRIBUTE_DESCRIPTION] = newEvent.description;
    } // if

    if (newEvent.imageFitCover != null) {
      attributeMap[ATTRIBUTE_IMAGE_FIT_COVER] = newEvent.imageFitCover;
    } // if

    /// No longer necessary to include empty fields, if they're null assume default values on front end when parsing
    _batch.update(_eventsDocRef, attributeMap);

    _batch.update(_searchEventsDocRef, {
      ATTRIBUTE_TITLE: newEvent.title.toUpperCase() ?? '',
      ATTRIBUTE_HOST: newEvent.host.toLowerCase() ?? '',
      ATTRIBUTE_LOCATION: newEvent.location.toLowerCase() ?? '',
      ATTRIBUTE_CATEGORY: newEvent.category ?? '',
      ATTRIBUTE_RAW_START_DATE_TIME: newEvent.rawStartDateAndTime ?? null,
    });

    _batch.update(_userCreatedEventsSubCollectionDocRef, {
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
  Future<void> pinEvent(EventModel newEvent, String userId) async {
    final WriteBatch _batch = FirebaseFirestore.instance.batch();

    // Create new documents in the "User Saved Events Collection" and "SavedEvents SubCollection"
    final DocumentReference _userSavedEventsSubCollectionDocRef =
        _userSavedEventsCollection.doc(userId);

    /// Add the event to the "userCreatedEvents" Collection:
    ///
    /// userSavedEvents : {
    ///   uid: {
    ///     eventID: true,
    ///     eventID: true,
    ///     eventID: true,
    ///     eventID: true,
    ///     ...
    ///   },
    ///   ...
    /// }
    ///
    /// This should be ok, since the limit is 20,000 fields
    /// events, it shouldn't be a lot to pull from firebase.
    ///
    /// As events get purged from the database, the user
    /// shouldn't be able to pin 20,000 events in time.
    _batch.set(_userSavedEventsSubCollectionDocRef, {
      newEvent.searchID: true,
    });
  } // updateEvent

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

  /// Deletes an document in Events Collection
  Future<void> deleteNewEventFromEventsCollection({@required String documentReferenceID}) async {
    try {
      // Update the empty document with the new data
      return await _eventsCollection.doc(documentReferenceID).delete();
    } // try
    catch (e) {
      print(e);
      return null;
    } // catch
  } // deleteNewEventFromEventsCollection

  /// Deletes an document in Search Events Collection
  Future<void> deleteNewEventFromSearchableCollection({@required String documentReferenceID}) async {
    try {
      // Update the empty document with the new data
      return await _searchEventsCollection.doc(documentReferenceID).delete();
    } // try
    catch (e) {
      print(e);
      return null;
    } // catch
  } // deleteNewEventFromSearchableCollection

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

  String imagePath({@required String eventID}) {
    return 'events/$eventID.jpg';
  } // _getGenerateImagePath
} //class

// Deprecated version of creating a new event, replaced by "batch" for atomicity!
//
// /// Creates an empty document in the Firestore cloud storage
// /// Retrieves the id of the new empty document for later use
// /// Uses the retrieve key to update the empty doc with the new data.
// Future<String> insertNewEventToEventsCollection({@required EventModel newEvent}) async {
//   try {
//     // Calling ".doc" on a collection without a provided path
//     // will auto-generate a new document with a new "primary" key.
//     final DocumentReference _document = _eventsCollection.doc();
//
//     // Get the document id
//     final String _documentReferenceId = _document.id;
//
//     // Don't forget to update the local copy with the new id
//     newEvent.eventID = _documentReferenceId;
//
//     // Update the empty document with the new data
//     await _eventsCollection.doc('$_documentReferenceId').set({
//       ATTRIBUTE_TITLE: newEvent.title ?? '',
//       ATTRIBUTE_HOST: newEvent.host ?? '',
//       ATTRIBUTE_LOCATION: newEvent.location ?? '',
//       ATTRIBUTE_ROOM: newEvent.room ?? '',
//       ATTRIBUTE_RAW_START_DATE_TIME: newEvent.rawStartDateAndTime ?? null,
//       ATTRIBUTE_RAW_END_DATE_TIME: newEvent.rawEndDateAndTime ?? null,
//       ATTRIBUTE_CATEGORY: newEvent.category ?? '',
//       ATTRIBUTE_HIGHLIGHTS: newEvent.highlights ?? [],
//       ATTRIBUTE_DESCRIPTION: newEvent.description ?? '',
//       ATTRIBUTE_IMAGE_FIT_COVER: newEvent.imageFitCover ?? false,
//       ATTRIBUTE_EVENT_ID: newEvent.eventID ?? '',
//       ATTRIBUTE_ACCOUNT_ID: newEvent.accountID ?? '',
//     });
//
//     return _documentReferenceId;
//   } // try
//   catch (e) {
//     // print(e);
//     return null;
//   } // catch
// } // insertNewEventToEventsCollection
//
// /// Insert new event into the "Searchable" collection
// /// only including the minimal attributes of an event.
// ///
// /// Returns the document ID of the document in the "Searchable" Collection.
// Future<String> insertNewEventToSearchableCollection({@required EventModel newEvent}) async {
//   try {
//     // Calling ".doc" on a collection without a provided path
//     // will auto-generate a new document with a new "primary" key.
//     final DocumentReference _document = _searchEventsCollection.doc();
//
//     // Get the document id
//     final String _documentReferenceId = _document.id;
//
//     await _searchEventsCollection.doc(_documentReferenceId).set({
//       ATTRIBUTE_TITLE: newEvent.title.toLowerCase() ?? '',
//       ATTRIBUTE_HOST: newEvent.host.toLowerCase() ?? '',
//       ATTRIBUTE_LOCATION: newEvent.location.toLowerCase() ?? '',
//       ATTRIBUTE_RAW_START_DATE_TIME: newEvent.rawStartDateAndTime ?? null,
//       ATTRIBUTE_CATEGORY: newEvent.category ?? '',
//       ATTRIBUTE_EVENT_ID: newEvent.eventID ?? '',
//       ATTRIBUTE_ACCOUNT_ID: newEvent.accountID ?? '',
//     });
//
//     return _documentReferenceId;
//   } // try
//   catch (e) {
//     // print(e);
//     return null;
//   } // catch
// } // insertNewEventToSearchableCollection

// Deprecated version of updating an event, replaced by "batch" for atomicity!
//
// /// Updates an existing document in the "Search Events"
// /// Collection, Fails if the document does not exist.
// Future<void> updateEventInSearchEventsCollection({@required EventModel newEvent}) async {
//   try {
//     return await _searchEventsCollection.doc(newEvent.searchID).update({
//       ATTRIBUTE_TITLE: newEvent.title.toLowerCase() ?? '',
//       ATTRIBUTE_HOST: newEvent.host.toLowerCase() ?? '',
//       ATTRIBUTE_LOCATION: newEvent.location.toLowerCase() ?? '',
//       ATTRIBUTE_RAW_START_DATE_TIME: newEvent.rawStartDateAndTime ?? null,
//       ATTRIBUTE_CATEGORY: newEvent.category ?? '',
//       ATTRIBUTE_EVENT_ID: newEvent.eventID ?? '',
//       ATTRIBUTE_ACCOUNT_ID: newEvent.accountID ?? '',
//     });
//   } // try
//   catch (e) {
//     // print(e);
//     return null;
//   } // catch
// } // updateEventInSearchEventsCollection
//
// /// Updates an existing document in the "Events"
// /// Collection, Fails if the document does not exist.
// Future<void> updateEventInEventsCollection({@required EventModel newEvent}) async {
//   try {
//     return await _eventsCollection.doc(newEvent.eventID).update({
//       ATTRIBUTE_TITLE: newEvent.title,
//       ATTRIBUTE_HOST: newEvent.host,
//       ATTRIBUTE_LOCATION: newEvent.location,
//       ATTRIBUTE_ROOM: newEvent.room,
//       ATTRIBUTE_RAW_START_DATE_TIME: newEvent.rawStartDateAndTime,
//       ATTRIBUTE_RAW_END_DATE_TIME: newEvent.rawEndDateAndTime,
//       ATTRIBUTE_CATEGORY: newEvent.category,
//       ATTRIBUTE_HIGHLIGHTS: newEvent.highlights,
//       ATTRIBUTE_DESCRIPTION: newEvent.description,
//       ATTRIBUTE_IMAGE_FIT_COVER: newEvent.imageFitCover,
//       ATTRIBUTE_EVENT_ID: newEvent.eventID,
//       ATTRIBUTE_ACCOUNT_ID: newEvent.accountID,
//     });
//   } // try
//   catch (e) {
//     // print(e);
//     return null;
//   } // catch
// } // updateEventInEventsCollection
