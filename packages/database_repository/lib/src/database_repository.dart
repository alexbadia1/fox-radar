import 'dart:typed_data';
import 'models/models.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:database_repository/database_repository.dart';

class DatabaseRepository {
  // Singleton
  static final DatabaseRepository _db = DatabaseRepository._internal();
  DatabaseRepository._internal();
  factory DatabaseRepository() {
    return _db;
  }

  // Collection References
  final CollectionReference _eventsCollection = FirebaseFirestore.instance.collection(COLLECTION_EVENTS);
  final CollectionReference _searchEventsCollection = FirebaseFirestore.instance.collection(COLLECTION_SEARCH_EVENTS);
  final CollectionReference _userCreatedEventsCollection = FirebaseFirestore.instance.collection(COLLECTION_USER_CREATED_EVENTS);
  final CollectionReference _userSavedEventsCollection = FirebaseFirestore.instance.collection(COLLECTION_USER_SAVED_EVENTS);

  final FirebaseStorage _firebaseStorage = FirebaseStorage.instanceFor(bucket: "gs://fox-radar-f8810.appspot.com");

  /// Retrieves events from the "Search Events Collection" based on
  /// [category] and returns a [QueryDocumentSnapshot] with the events.
  ///
  /// For pagination, continues query starting after the [lastEvent]
  /// and returns a number documents no bigger thant the [limit].
  Future<List<QueryDocumentSnapshot>> searchEventsByCategory({
    required String category, required QueryDocumentSnapshot? lastEvent, required int limit
  }) async {
    QuerySnapshot? querySnap;

    if (lastEvent != null) {
      querySnap = await _searchEventsCollection
          .where(ATTRIBUTE_CATEGORY, isEqualTo: category)
          .startAfterDocument(lastEvent)
          .limit(limit)
          .get();
    } else {
      querySnap = await _searchEventsCollection.where(ATTRIBUTE_CATEGORY, isEqualTo: category).limit(limit).get();
    }

    return querySnap.docs;
  }

  /// Retrieves events from the "Search Events Collection"
  /// by [rawStartDateAndTime] and returns a [QueryDocumentSnapshot]
  /// with the events that start at or after the current [DateTime.now].
  ///
  /// For pagination, continues query starting after the [lastEvent]
  /// and returns a number documents no bigger thant the [limit].
  Future<List<QueryDocumentSnapshot>> searchEventsByStartDateAndTime({
    required QueryDocumentSnapshot? lastEvent, required int limit
  }) async {
    QuerySnapshot? querySnap;

    if (lastEvent != null) {
      querySnap = await _searchEventsCollection
          .where(ATTRIBUTE_RAW_START_DATE_TIME, isGreaterThanOrEqualTo: DateTime.now())
          .orderBy(ATTRIBUTE_RAW_START_DATE_TIME)
          .startAfterDocument(lastEvent)
          .limit(limit)
          .get();
    } else {
      querySnap = await _searchEventsCollection
          .where(ATTRIBUTE_RAW_START_DATE_TIME, isGreaterThanOrEqualTo: DateTime.now())
          .orderBy(ATTRIBUTE_RAW_START_DATE_TIME)
          .limit(limit)
          .get();
    }

    return querySnap.docs;
  }

  Future<DocumentSnapshot?> getAccountPinnedEvents({required String uid}) async {
    try {
      final DocumentSnapshot docSnap = await _userSavedEventsCollection.doc(uid).get();
      return docSnap;
    } catch (error) {
      print(error);
      return null;
    }
  }

  Future<DocumentSnapshot?> getAccountCreatedEvents({required String uid}) async {
    try {
      final DocumentSnapshot docSnap = await _userCreatedEventsCollection.doc(uid).get();
      return docSnap;
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<DocumentSnapshot?> getSearchEventById({required String eventId}) async {
    try {
      final DocumentSnapshot docSnap = await _searchEventsCollection.doc(eventId).get();
      return docSnap;
    } catch (e) {
      print("[getSearchEventById] ${e.toString()}");
      return null;
    }
  }

  /// Retrieves events from the "User Created Events Collection > UserID > Created Events
  /// Collection" returns a [QueryDocumentSnapshot] of events belonging to the [accountID].
  ///
  /// For pagination, continues query starting after the [lastEvent]
  /// and returns a number documents no bigger thant the [limit].
  Future<List<QueryDocumentSnapshot>> getAccountEventsDeprecated({
    required String accountID, required QueryDocumentSnapshot? lastEvent, required int limit
  }) async {
    QuerySnapshot querySnap;

    if (lastEvent != null) {
      // Continue querying from where you left off
      querySnap = await _userCreatedEventsCollection
          .doc(accountID)
          .collection(SUB_COLLECTION_CREATED_EVENTS)
          .startAfterDocument(lastEvent)
          .limit(limit)
          .get();
    } else {
      // First query
      querySnap = await _userCreatedEventsCollection.doc(accountID).collection(SUB_COLLECTION_CREATED_EVENTS).limit(limit).get();
    }

    return querySnap.docs;
  }

  Future<DocumentSnapshot?> getEventFromEventsCollection({required String documentId}) async {
    return await _eventsCollection.doc(documentId).get();
  }

  /// Creates a new "Event" in firebase
  ///
  /// Batched is used to ensure atomicity, due to the denormalized structure of the database.
  Future<String?> createEvent(EventModel newEvent, String userId) async {
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
        ATTRIBUTE_TITLE: newEvent.title!.toUpperCase() ?? '',
        ATTRIBUTE_HOST: newEvent.host!.toLowerCase() ?? '',
        ATTRIBUTE_LOCATION: newEvent.location!.toLowerCase() ?? '',
        ATTRIBUTE_CATEGORY: newEvent.category ?? '',
        ATTRIBUTE_RAW_START_DATE_TIME: newEvent.rawStartDateAndTime ?? null,
        ATTRIBUTE_IMAGE_FIT_COVER: newEvent.imageFitCover ?? false
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
      await _accountEventsDocRef.get().then((doc) {
        if (doc.exists) {
          _batch.update(_accountEventsDocRef, {_eventsId: true});
        } else {
          _batch.set(_accountEventsDocRef, {_eventsId: true});
        }
      });

      await _batch.commit();
      return _eventsId;
    } catch (e) {
      print(e);
      return null;
    }
  }

  /// Updates an existing "Event" in firebase
  ///
  /// Batched is used to ensure atomicity, due
  /// to the denormalized structure of the database.
  Future<void> updateEvent(EventModel newEvent) async {
    final WriteBatch _batch = FirebaseFirestore.instance.batch();
    // Can't update any of them
    if (newEvent.eventID == null) {
      return;
    }

    // Can't update any of them
    if (newEvent.eventID!.replaceAll(" ", "") == "") {
      return;
    }

    // Get document references based on id
    final DocumentReference _eventsDocRef = _eventsCollection.doc(newEvent.eventID);
    final DocumentReference _searchEventsDocRef = _searchEventsCollection.doc(newEvent.eventID);

    /// No longer necessary to include empty fields, if they're
    /// null assume default values on front end when parsing.
    final attributeMap = this.eventModelToMap(newEvent);
    _batch.update(_eventsDocRef, attributeMap);

    _batch.update(_searchEventsDocRef, {
      ATTRIBUTE_TITLE: newEvent.title!.toUpperCase() ?? '',
      ATTRIBUTE_HOST: newEvent.host!.toLowerCase() ?? '',
      ATTRIBUTE_LOCATION: newEvent.location!.toLowerCase() ?? '',
      ATTRIBUTE_CATEGORY: newEvent.category ?? '',
      ATTRIBUTE_RAW_START_DATE_TIME: newEvent.rawStartDateAndTime ?? null,
    });
    await _batch.commit();
  }

  /// Pins an existing "Event" to the user account
  /// Returns true or false, if the update succeded or not.
  Future<bool> pinEvent(String eventId, String userId) async {
    try {
      print("Pinning Event");
      // User's doc containing all saved events and a count
      final DocumentReference docRef = this._userSavedEventsCollection.doc(userId);
      await docRef.get().then((doc) {
        if (doc.exists) {
          docRef.update({eventId: true});
        } else {
          docRef.set({eventId: true});
        }
      });
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Pins an existing "Event" to the user account
  /// Returns true or false, if the update succeeded or not.
  Future<bool> unpinEvent(String eventId, String userId) async {
    try {
      // User's doc containing all saved events and a count
      final DocumentReference docRef = this._userSavedEventsCollection.doc(userId);

      await docRef.get().then((doc) {
        if (doc.exists) {
          docRef.update({eventId: FieldValue.delete()});
        } else {
          docRef.set({eventId: FieldValue.delete()});
        }
      });
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Deletes an existing "Event" in firebase
  ///
  /// Batched is used to ensure atomicity, due to the denormalized structure of the database.
  Future<bool> deleteEvent(String eventId, String userId) async {
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
      _batch.update(createdEventDocRef, {eventId: FieldValue.delete()});

      // You can delete the event from the current user's pinned
      // events document, but every other user will have a null pointer.
      _batch.update(pinnedEventDocRef, {eventId: FieldValue.delete()});

      await _batch.commit();
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  /// Attempts to upload an image to firebase storage
  /// using the document id of the event as the image name.
  ///
  /// Overwrites existing files (useful for updating an image).
  ///
  /// Returns a listenable upload task, to show upload progress.
  UploadTask? uploadImageToStorage({
    required String eventID, required Uint8List imageBytes
  }) {
    try {
      return _firebaseStorage.ref().child(this.imagePath(eventID: eventID)).putData(imageBytes);
    } catch (e) {
      print(e);
      return null;
    }
  }

  /// Attempts to delete an image uploaded to firebase
  /// using the document id of the event as the image name.
  ///
  /// Returns a listenable upload task, to show upload progress.
  Future<void>? deleteImageFromStorage({required String eventID}) {
    try {
      return _firebaseStorage.ref().child(this.imagePath(eventID: eventID)).delete();
    } catch (e) {
      return null;
    }
  }

  Future<Uint8List?> getImageFromStorage({required String eventID}) async {
    try {
      return await _firebaseStorage.ref().child(this.imagePath(eventID: eventID)).getData(4194304);
    } catch (e) {
      return null;
    }
  }

  String imagePath({required String eventID}) {
    return 'events/$eventID.jpg';
  }

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
      if (eventModel.room!.replaceAll(" ", '') != "") {
        _map[ATTRIBUTE_ROOM] = eventModel.room;
      }
    }

    if (eventModel.rawEndDateAndTime != null) {
      _map[ATTRIBUTE_RAW_END_DATE_TIME] = eventModel.rawEndDateAndTime;
    }

    if (eventModel.highlights != null) {
      _map[ATTRIBUTE_HIGHLIGHTS] = eventModel.highlights;
    }

    if (eventModel.description != null) {
      if (eventModel.description!.replaceAll(" ", '') != "") {
        _map[ATTRIBUTE_DESCRIPTION] = eventModel.description;
      }
    }

    if (eventModel.imageFitCover != null) {
      _map[ATTRIBUTE_IMAGE_FIT_COVER] = eventModel.imageFitCover;
    }

    return _map;
  }
}
