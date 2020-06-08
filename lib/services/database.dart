import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:communitytabs/data/club_event_data.dart';
import 'package:flutter/cupertino.dart';

class DatabaseService {
  //Get local user data
  final String uid;

  //Create a collection reference
  final CollectionReference _eventsCollection =
      Firestore.instance.collection('events');

  //Create a collection reference
  final CollectionReference _usersCollection =
      Firestore.instance.collection('user');

  //Constructor
  DatabaseService({this.uid});

  //Update document function, creates a new document if one doesn't already exist
  Future updateUserData(String email, String password) async {
    return await _usersCollection
        .document(uid)
        .setData({'email': email, 'password': password});
  } //updateUserData

  Future addEvent({@required ClubEventData newEvent}) async {
    return await _eventsCollection.document().setData({
      'title': newEvent.getTitle ?? '',
      'host': newEvent.getHost ?? '',
      'location': newEvent.getLocation ?? '',
      'room': newEvent.getRoom ?? '',
      'startDate': newEvent.getStartDate ?? '',
      'startTime': newEvent.getStartTime ?? '',
      'endDate': newEvent.getEndDate ?? '',
      'endTime' : newEvent.getEndTime ?? '',
      'category' : newEvent.myCategory ?? '',
      'highlights': newEvent.getHighlights ?? [],
      'summary' : newEvent.getSummary ?? '',
    });
  } //addEvent

  ///Creating a Local Object Instance of an Event for ease of use
  List<ClubEventData> _eventListFromSnapshot(QuerySnapshot snap) {
    return snap.documents.map((doc) {
      return ClubEventData(
          ///Category converted to [STRING] from [STRING] in Firebase.
          newCategory: doc.data['category'] ?? '',

          ///Host converted to [STRING] from [STRING] in Firebase.
          newHost: doc.data['host'] ?? '',

          ///Title converted to [STRING] from [STRING] in Firebase.
          newTitle: doc.data['title'] ?? '',

          ///Start Date Converted to [STRING] from [STRING] in Firebase.
          newStartDate: doc.data['startDate'] ?? '',

          ///Start Time Converted to [STRING] from [STRING] in Firebase.
          newStartTime: doc.data['startTime'] ?? '',

          ///Start Date Converted to [STRING] from [STRING] in Firebase.
          newEndDate: doc.data['endDate'] ?? '',

          ///End Time Converted to [STRING] from [STRING] in Firebase.
          newEndTime: doc.data['endTime'] ?? '',

          ///Location Converted to [] from [] in Firebase.
          newLocation: doc.data['location'] ?? '',

          ///Room converted to [STRING] from [String] in Firebase.
          newRoom: doc.data['room'] ?? '',

          ///Summary converted to [STRING] from [STRING] in Firebase.
          newSummary: doc.data['summary'] ?? '',

          ///Highlights converted to [List<String>] from [List<dynamic>] in Firebase.
          newHighlights: List.from(doc.data['highlights']) ??
              [
                '',
                '',
                '',
                '',
                ''
              ],

          ///TODO: Implement Firebase Images.
          newImage: 'images/AsianAllianceLanterns.jpg');
    }).toList();
  } //_eventListFromSnapshot

  //Use Stream to get QuerySnapshots
  Stream<List<ClubEventData>> get getEvents {
    return _eventsCollection.snapshots().map(_eventListFromSnapshot);
  } //Stream get events

} //class
