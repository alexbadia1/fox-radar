import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:communitytabs/data/club_event_data.dart';

class DatabaseService {
  //Get local user data
  final String uid;

  //Create a collection reference
  final CollectionReference _eventsCollection = Firestore.instance.collection('events');

  //Create a collection reference
  final CollectionReference _usersCollection = Firestore.instance.collection('user');

  //Constructor
  DatabaseService({this.uid});

  //Update document function, creates a new document if one doesn't already exist
  Future updateUserData(String email, String password) async {
    return await _usersCollection.document(uid).setData({
      'email' : email,
      'password': password});
  }//updateUserData

  Future addEvent([
    String title,
    String host,
    String summary,
    String location,
    String room,
    int startTime,
    int endTime,
    List<String> highlights]) async{
    return await _eventsCollection.document().setData({
      'title' : title,
      'host' : host,
      'summary' : summary,
      'location' : location,
      'room' : room,
      'startTime' : startTime,
      'endTime' : endTime,
      'highlights' : highlights
    });
  }//addEvent

  //Convert documents into a list local objects
  List<ClubEventData> _eventListFromSnapshot(QuerySnapshot snap) {
    return snap.documents.map((doc) {
      return ClubEventData(
        newHost: doc.data['host'] ?? 'Host',
        newTitle: doc.data['title'] ?? 'Title',
        newDate: doc.data['date'] ?? 'Date',
        newStartTime: doc.data['startTime'] ?? 'Start Time',
        newEndTime: doc.data['endTime'] ?? 'End Time',
        newLocation: doc.data['location'] ?? 'Location',
        newRoom: doc.data['room'] ?? 'Room',
        newSummary: doc.data['summary'] ?? 'Summary',
        newHighlights:  doc.data['highlights'] ?? ['1', '2', '3', '4', '5'],
        newImage: 'images/AsianAllianceLanterns.jpg');
    }).toList();
  }//_eventListFromSnapshot

  //Use Stream to get QuerySnapshots
  Stream<List<ClubEventData>> get getEvents {
    return _eventsCollection.snapshots().map(_eventListFromSnapshot);
  }//Stream get events

}//class