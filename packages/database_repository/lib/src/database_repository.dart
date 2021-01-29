import 'dart:typed_data';
import 'models/models.dart';
import 'package:meta/meta.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class DatabaseRepository {

  // Collection References
  final CollectionReference _eventsCollection = FirebaseFirestore.instance.collection('events');
  final CollectionReference _searchEventsCollection = FirebaseFirestore.instance.collection('searchEvents');

  Future<List<QueryDocumentSnapshot>> getEventsWithPaginationFromSearchEventsCollection(
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
    }// if

    else {
      print('Called: getSuggestedEventsWithPagination');
      querySnap = await _searchEventsCollection
          .where('category', isEqualTo: category)
          .limit(limit)
          .get();
    }// else

    return querySnap.docs;
  }// getEventsWithPagination

  Future<DocumentSnapshot> getEventFromEventsCollection({@required String documentId}) async {
    return await _eventsCollection.doc('$documentId').get();
  }// getEventsFromEventsCollection

  Future<Uint8List> getImageFromStorage({@required String path}) async {
    return await FirebaseStorage.instance
        .ref()
        .child(path)
        .getData(4194304);
  }// getImageFromStorage
} //class
