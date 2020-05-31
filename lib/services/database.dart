import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:communitytabs/data/club_event_data.dart';

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

  Future addEvent(
      [String title,
      String host,
      String summary,
      String location,
      String room,
      int startTime,
      int endTime,
      List<String> highlights]) async {
    return await _eventsCollection.document().setData({
      'title': title,
      'host': host,
      'summary': summary,
      'location': location,
      'room': room,
      'startTime': startTime,
      'endTime': endTime,
      'highlights': highlights
    });
  } //addEvent

  ///Creating a Local Object Instance of an Event for ease of use
  List<ClubEventData> _eventListFromSnapshot(QuerySnapshot snap) {
    return snap.documents.map((doc) {
      return ClubEventData(
          ///Host converted to [STRING] from [STRING] in Firebase.
          newHost: doc.data['host'] ?? 'Host',

          ///Title converted to [STRING] from [STRING] in Firebase.
          newTitle: doc.data['title'] ?? 'Title',

          ///Date Converted to [] from [TIMESTAMP] in Firebase.
          newDate: doc.data['date'] ?? 'Date',

          ///Date Converted to [] from [] in Firebase.
          newStartTime: doc.data['startTime'] ?? 'Start Time',

          ///Date Converted to [] from [] in Firebase.
          newEndTime: doc.data['endTime'] ?? 'End Time',

          ///Date Converted to [] from [] in Firebase.
          newLocation: doc.data['location'] ?? 'Location',

          ///Room converted to [STRING] from [String] in Firebase.
          newRoom: doc.data['room'] ?? 'Room',

          ///Summary converted to [STRING] from [STRING] in Firebase.
          newSummary: doc.data['summary'] ?? 'Summary',

          ///Highlights converted to [List<String>] from [List<dynamic>] in Firebase.
          newHighlights: List.from(doc.data['highlights']) ??
              [
                '[Highlight 1]',
                '[Highlight 2]',
                '[Highlight 3]',
                '[Highlight 4]',
                '[Highlight 5]'
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
