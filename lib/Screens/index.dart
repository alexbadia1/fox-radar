import 'dart:ui';
import 'package:communitytabs/authentication/auth.dart';
import 'package:communitytabs/data_definitions/club_event_data.dart';
import 'package:flutter/material.dart';
import 'package:communitytabs/colors/marist_color_scheme.dart';
import 'package:communitytabs/event_cards/club_card.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  Map _myData = {};
  List<ClubEventData> _myEventList = [];
  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {

     try { _myData = ModalRoute
          .of(context)
          .settings
          .arguments;
      _myEventList = _myData['events'];
     } on Error {_myEventList = [];}

    return Scaffold(
      backgroundColor: cBackgroundColor,
      appBar: AppBar (
        title: Text("Marist"),
        centerTitle: true,
        flexibleSpace: Container(
          decoration: BoxDecoration (
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: <Color> [
                cWashedRed,
                cFullRed,
              ],
            ),
          ),
        ),
        leading: FlatButton(
          child: Text("Sign Out"),
          onPressed: () async {
            await _auth.signOut();
            Navigator.pushReplacementNamed(context, '/');
          },
        ),
      ),
      body: ListView.builder (
          itemCount: _myEventList.length,
          itemBuilder: (BuildContext context, int index) {
            return clubCard(_myEventList[index], context);
          }
      ),
    );
  }
}
