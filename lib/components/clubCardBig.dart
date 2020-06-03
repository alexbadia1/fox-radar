import 'package:communitytabs/constants/marist_color_scheme.dart';
import 'package:communitytabs/data/club_event_data.dart';
import 'package:communitytabs/screens/event.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:ui';

/// This widget defines the card that is used in the list of events
Widget clubCardBig(ClubEventData newEvent, context) {
  ClubEventData _myEvent = newEvent;
  String _eventHost = _myEvent.getHost;
  String _eventTitle = _myEvent.getTitle;
  String _eventLocation = _myEvent.getLocation;
  String _eventRoom = _myEvent.getRoom;
  String _eventStartTime = _myEvent.getStartTime;
  String _eventEndTime = _myEvent.getEndTime;
  String _eventDate = _myEvent.getDate;
  String _eventImage = _myEvent.getImage;
  return GestureDetector(
    onTap: () {
      Navigator.of(context).push(PageRouteBuilder(
          ///TODO: Add Slide-In-Right Transition
          pageBuilder: (context, animation1, animation2) =>
              EventDetails(myEvent: _myEvent)));
    },
    child: Column(
      children: <Widget>[
        Image(
          image: AssetImage(_eventImage),
        ),
        Container(
          child: ListTile(
            leading: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                CircleAvatar(
                  backgroundColor: Colors.redAccent,
                ),
              ],
            ),
            title: Text(
              _eventTitle,
              textAlign: TextAlign.start,
              style: TextStyle(color: cWhite100),
            ),
            subtitle: RichText(
              text: TextSpan(children: [
                TextSpan(
                    text: _eventLocation,
                    style: TextStyle(color: cWhite70, fontSize: 10.0)),
                TextSpan(text: ' - '),
                TextSpan(
                    text: _eventDate,
                    style: TextStyle(color: cWhite70, fontSize: 10.0))
              ]),
            ),
            trailing: Icon(Icons.more_vert, color: cWhite70),
          ),
        ),
      ],
    ),
  );
}
