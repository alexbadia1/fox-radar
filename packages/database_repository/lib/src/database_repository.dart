import 'dart:typed_data';
import 'package:database_repository/database_repository.dart';

import 'models/models.dart';
import 'package:meta/meta.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class DatabaseRepository {
  // Collection References
  final CollectionReference _eventsCollection =
      FirebaseFirestore.instance.collection(COLLECTION_EVENTS);
  final CollectionReference _searchEventsCollection =
      FirebaseFirestore.instance.collection(COLLECTION_SEARCH_EVENTS);

  /// Retrieves events from the "Search Events Collection" based on
  /// [category] and returns a [QueryDocumentSnapshot] with the events.
  ///
  /// For pagination, continues query starting after the [lastEvent]
  /// and returns a number documents no bigger thant the [limit].
  Future<List<QueryDocumentSnapshot>> searchEventsByCategory(
      {@required String category,
      @required QueryDocumentSnapshot lastEvent,
      @required int limit}) async {
    QuerySnapshot querySnap;

    if (lastEvent != null) {
      querySnap = await _searchEventsCollection
          .where(ATTRIBUTE_CATEGORY, isEqualTo: category)
          .startAfterDocument(lastEvent)
          .limit(limit)
          .get();
    } // if

    else {
      querySnap = await _searchEventsCollection
          .where(ATTRIBUTE_CATEGORY, isEqualTo: category)
          .limit(limit)
          .get();
    } // else

    return querySnap.docs;
  } // searchEventsByCategory

  /// Retrieves events from the "Search Events Collection"
  /// by [rawStartDateAndTime] and returns a [QueryDocumentSnapshot]
  /// with the events that start at or after the current [DateTime.now].
  ///
  /// For pagination, continues query starting after the [lastEvent]
  /// and returns a number documents no bigger thant the [limit].
  Future<List<QueryDocumentSnapshot>> searchEventsByStartDateAndTime(
      {@required QueryDocumentSnapshot lastEvent, @required int limit}) async {
    QuerySnapshot querySnap;

    if (lastEvent != null) {
      querySnap = await _searchEventsCollection
          .where(ATTRIBUTE_RAW_START_DATE_TIME,
              isGreaterThanOrEqualTo: DateTime.now())
          .startAfterDocument(lastEvent)
          .limit(limit)
          .get();
    } // if

    else {
      querySnap = await _searchEventsCollection
          .where(ATTRIBUTE_RAW_START_DATE_TIME,
              isGreaterThanOrEqualTo: DateTime.now())
          .limit(limit)
          .get();
    } // else

    return querySnap.docs;
  } // searchEventsByStartDateAndTime

  /// Retrieves events from the "Search Events Collection" by [accountID] and
  /// returns a [QueryDocumentSnapshot] of events belonging to the [accountID].
  ///
  /// For pagination, continues query starting after the [lastEvent]
  /// and returns a number documents no bigger thant the [limit].
  Future<List<QueryDocumentSnapshot>> searchEventsByAccount(
      {@required String accountID,
      @required QueryDocumentSnapshot lastEvent,
      @required int limit}) async {
    QuerySnapshot querySnap;

    // Continue querying from where you left off
    if (lastEvent != null) {
      querySnap = await _searchEventsCollection
          .where(ATTRIBUTE_ACCOUNT_ID, isEqualTo: accountID)
          .startAfterDocument(lastEvent)
          .limit(limit)
          .get();
    } // if

    // First query
    else {
      querySnap = await _searchEventsCollection
          .where(ATTRIBUTE_ACCOUNT_ID, isEqualTo: accountID)
          .limit(limit)
          .get();
    } // else

    return querySnap.docs;
  } // searchEventsByAccount

  Future<DocumentSnapshot> getEventFromEventsCollection(
      {@required String documentId}) async {
    return await _eventsCollection.doc(documentId).get();
  } // getEventsFromEventsCollection

  Future<Uint8List> getImageFromStorage({@required String path}) async {
    try {
      return await FirebaseStorage.instance.ref().child(path).getData(4194304);
    } // try
    catch (e) {
      return null;
    } // catch
  } // getImageFromStorage

  /// Creates an empty document in the Firestore cloud storage
  /// Retrieves the id of the new empty document for later use
  /// Uses the retrieve key to update the empty doc with the new data.
  Future<String> insertNewEventToEventsCollection(
      {@required EventModel newEvent}) async {
    try {
      // Calling ".doc" on a collection without a provided path
      // will auto-generate a new document with a new "primary" key.
      final DocumentReference _document = _eventsCollection.doc();

      // Get the document id
      final String _documentReferenceId = _document.id;

      // Don't forget to update the local copy with the new id
      newEvent.eventID = _documentReferenceId;

      // Update the empty document with the new data
      await _eventsCollection.doc('$_documentReferenceId').set({
        ATTRIBUTE_TITLE: newEvent.title ?? '',
        ATTRIBUTE_HOST: newEvent.host ?? '',
        ATTRIBUTE_LOCATION: newEvent.location ?? '',
        ATTRIBUTE_ROOM: newEvent.room ?? '',
        ATTRIBUTE_RAW_START_DATE_TIME: newEvent.rawStartDateAndTime ?? null,
        ATTRIBUTE_RAW_END_DATE_TIME: newEvent.rawEndDateAndTime ?? null,
        ATTRIBUTE_CATEGORY: newEvent.category ?? '',
        ATTRIBUTE_HIGHLIGHTS: newEvent.highlights ?? [],
        ATTRIBUTE_DESCRIPTION: newEvent.description ?? '',
        ATTRIBUTE_IMAGE_FIT_COVER: newEvent.imageFitCover ?? false,
        ATTRIBUTE_EVENT_ID: newEvent.eventID ?? '',
        ATTRIBUTE_ACCOUNT_ID: newEvent.accountID ?? '',
      });

      return _documentReferenceId;
    } // try
    catch (e) {
      // print(e);
      return null;
    } // catch
  } // insertNewEventToEventsCollection

  /// Insert new event into the "Searchable" collection
  /// only including the minimal attributes of an event.
  ///
  /// Returns the document ID of the document in the "Searchable" Collection.
  Future<String> insertNewEventToSearchableCollection(
      {@required EventModel newEvent}) async {
    try {
      // Calling ".doc" on a collection without a provided path
      // will auto-generate a new document with a new "primary" key.
      final DocumentReference _document = _searchEventsCollection.doc();

      // Get the document id
      final String _documentReferenceId = _document.id;

      await _searchEventsCollection.doc(_documentReferenceId).set({
        ATTRIBUTE_TITLE: newEvent.title.toLowerCase() ?? '',
        ATTRIBUTE_HOST: newEvent.host.toLowerCase() ?? '',
        ATTRIBUTE_LOCATION: newEvent.location.toLowerCase() ?? '',
        ATTRIBUTE_RAW_START_DATE_TIME: newEvent.rawStartDateAndTime ?? null,
        ATTRIBUTE_CATEGORY: newEvent.category ?? '',
        ATTRIBUTE_EVENT_ID: newEvent.eventID ?? '',
        ATTRIBUTE_ACCOUNT_ID: newEvent.accountID ?? '',
      });

      return _documentReferenceId;
    } // try
    catch (e) {
      // print(e);
      return null;
    } // catch
  } // insertNewEventToSearchableCollection

  /// Attempts to upload an image to firebase storage
  /// using the document id of the event as the image name.
  ///
  /// Returns a listenable upload task, to show upload progress.
  UploadTask uploadImageToStorage(
      {@required String path, @required Uint8List imageBytes}) {
    try {
      return FirebaseStorage.instance.ref().child(path).putData(imageBytes);
    } // try
    catch (e) {
      return null;
    } // catch
  } // uploadImageToStorage

  /// Deletes an document in Events Collection
  Future<void> deleteNewEventFromEventsCollection(
      {@required String documentReferenceID}) async {
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
  Future<void> deleteNewEventFromSearchableCollection(
      {@required String documentReferenceID}) async {
    try {
      // Update the empty document with the new data
      return await _searchEventsCollection.doc(documentReferenceID).delete();
    } // try
    catch (e) {
      print(e);
      return null;
    } // catch
  } // deleteNewEventFromSearchableCollection
} //class
