import 'dart:typed_data';
import 'models/models.dart';
import 'package:meta/meta.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class DatabaseRepository {
  // Collection References
  final CollectionReference _eventsCollection =
      FirebaseFirestore.instance.collection('events');
  final CollectionReference _searchEventsCollection =
      FirebaseFirestore.instance.collection('searchEvents');

  Future<List<QueryDocumentSnapshot>>
      getEventsWithPaginationFromSearchEventsCollection(
          {@required String category,
          @required QueryDocumentSnapshot lastEvent,
          @required int limit}) async {
    QuerySnapshot querySnap;

    if (lastEvent != null) {
      querySnap = await _searchEventsCollection
          .where('category', isEqualTo: category)
          .startAfterDocument(lastEvent)
          .limit(limit)
          .get();
    } // if

    else {
      print('Called: getSuggestedEventsWithPagination');
      querySnap = await _searchEventsCollection
          .where('category', isEqualTo: category)
          .limit(limit)
          .get();
    } // else

    return querySnap.docs;
  } // getEventsWithPagination

  Future<DocumentSnapshot> getEventFromEventsCollection(
      {@required String documentId}) async {
    return await _eventsCollection.doc('$documentId').get();
  } // getEventsFromEventsCollection

  Future<Uint8List> getImageFromStorage({@required String path}) async {
    try {
      return await FirebaseStorage.instance.ref().child(path).getData(4194304);
    }// try
    catch (e) {
      return null;
    }// catch
  } // getImageFromStorage

  // Creates an empty document in the firestore cloud storage
  // Retrieves the id of the new empty document for later use
  // Uses the retrieve key to update the empty doc with the new data
  Future<String> insertNewEventToEventsCollection(
      {@required EventModel newEvent}) async {
    try {
      // Calling ".doc" on a collection without a provided path
      // will auto-generate a new document with a new "primary" key.
      final DocumentReference _document = _eventsCollection.doc();

      // Get the document id
      final String _documentReferenceId = _document.id;

      // Don't forget to update the local copy with the new id
      newEvent.setId(_documentReferenceId);

      // Update the empty document with the new data
      await _eventsCollection.doc('$_documentReferenceId').set({
        'id': newEvent.id ?? '',
        'title': newEvent.getTitle ?? '',
        'host': newEvent.getHost ?? '',
        'location': newEvent.getLocation ?? '',
        'room': newEvent.getRoom ?? '',
        'category': newEvent.myCategory ?? '',
        'highlights': newEvent.getHighlights ?? [],
        'summary': newEvent.getSummary ?? '',
        'rawStartDateAndTime': newEvent.getRawStartDateAndTime ?? null,
        'rawEndDateAndTime': newEvent.getRawEndDateAndTime ?? null,
        'imageFitCover': newEvent.getImageFitCover ?? true,
      });

      return _documentReferenceId;
    } // try
    catch (e) {
      // print(e);
      return null;
    } // catch
  } // insertNewEvent

  // Insert new event into the searchable collection
  Future<String> insertNewEventToSearchableCollection(
      {@required EventModel newEvent}) async {
    try {
      // Calling ".doc" on a collection without a provided path
      // will auto-generate a new document with a new "primary" key.
      final DocumentReference _document = _eventsCollection.doc();

      // Get the document id
      final String _documentReferenceId = _document.id;

      await _searchEventsCollection.doc('$_documentReferenceId').set({
        'id': newEvent.id,
        'title': newEvent.getTitle.toLowerCase() ?? '',
        'category': newEvent.myCategory ?? '',
        'location': newEvent.getLocation.toLowerCase() ?? '',
        'host': newEvent.getHost.toLowerCase() ?? '',
      });

      return _documentReferenceId;
    } // try
    catch (e) {
      // print(e);
      return null;
    } // catch
  } // insertNewEventToSearchableCollection
} //class
