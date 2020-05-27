import 'dart:ui';
import 'package:communitytabs/components/suggestions.dart';
import 'package:communitytabs/data/club_event_data.dart';
import 'package:communitytabs/services/auth.dart';
import 'package:communitytabs/services/database.dart';
import 'package:flutter/material.dart';
import 'package:communitytabs/colors/marist_color_scheme.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  final AuthService _auth = AuthService();
  @override
  Widget build(BuildContext context) {
    return StreamProvider<List<ClubEventData>>.value(
      value: DatabaseService().getEvents,
      child: Scaffold(
        backgroundColor: cBackgroundColor,
        appBar: AppBar(
          title: Text("Marist"),
          centerTitle: true,
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: <Color>[
                  cWashedRed,
                  cFullRed,
                ],
              ),
            ),
          ),
          leading: FlatButton(
            child: Text("Sign Out"),
            onPressed: () async {
              dynamic success = await _auth.signOut();
              success != -1
                  ? Navigator.pushReplacementNamed(context, '/')
                  : print("Error Signing Out");
            },
          ),
        ),
        body: Suggestions(),
      ),
    );
  }
}//class
