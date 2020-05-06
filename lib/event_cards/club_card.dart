import 'package:communitytabs/colors/marist_color_scheme.dart';
import 'package:communitytabs/data_definitions/club_event_data.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:ui';

/// This widget defines the card that is used in the list of events

Widget clubCard (ClubEventData newEvent, context) {

  ClubEventData _myEvent = newEvent;

  String _eventHost = _myEvent.getHost;
  String _eventTitle = _myEvent.getTitle;
  String _eventLocation = _myEvent.getLocation;
  String _eventRoom = _myEvent.getRoom;
  String _eventStartTime = _myEvent.getStartTime;
  String _eventEndTime = _myEvent.getEndTime;
  String _eventDate = _myEvent.getDate;

  return Card(
    child: GestureDetector(
      onTap: () { Navigator.pushNamed(context, '/eventDetails', arguments: {'event': _myEvent});},
      child: Container(
        height: 100.00,
        width: double.infinity,
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.white10,
              spreadRadius: 2,
              blurRadius: 2,
              offset: Offset(0, 7), // changes position of shadow
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Expanded(
              flex: 4,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Expanded(
                    flex: 2,
                    child: Container(
                      width: double.infinity,
                      alignment: Alignment.bottomLeft,
                      child: Row(
                        children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.fromLTRB(5.0, 6.0, 0, 0),
                              child: Container(
                                height: double.infinity,
                                alignment: Alignment.bottomCenter,
                                child: Text(
                                  "NOW ",
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    color: Colors.green,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Lato-Regular.ttf',
                                    fontSize: 14,
                                  ),
                                ),
                          ),
                            ),
                          Expanded(
                            flex: 1,
                            child: Container(
                              height: double.infinity,
                              alignment: Alignment.bottomLeft,
                              child: Text(
                                _eventHost,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: cFullRed,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Lato-Regular.ttf',
                                  fontSize: 8,
                            ),
                          ),),),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 4,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(5.0, 0, 0, 0),
                      child: Container(
                        height: double.infinity,
                        width: double.infinity,
                        alignment: Alignment.centerLeft,
                        child: Text(
                            _eventTitle,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontFamily: 'Lato-Regular.ttf',
                            fontWeight: FontWeight.bold,
                            fontSize: 16.0,
                          ),
                        ),
                      ),
                    ),
                  ),
                  subText(_eventLocation, _eventRoom),
                  subText (_eventDate),
                  subText(_eventStartTime + " -", _eventEndTime),
                ],
              ),
            ),
            Expanded(
              flex: 2,
              child: Container(
                height: double.infinity,
                child: Image(
                  image: AssetImage(_myEvent.getImage),
                  fit: BoxFit.fitHeight,
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}


Widget subText (String newText, [String newEventRoom = ""]) {
  return Expanded(
    flex: 1,
    child: Padding(
      padding: const EdgeInsets.fromLTRB(5.0, 0, 0, 3.0),
      child: Container(
        height: double.infinity,
        width: double.infinity,
        alignment: Alignment.centerLeft,
        child: Text(
          newText + " " + newEventRoom,
          style: TextStyle(
            fontFamily: 'Lato-Regular.ttf',
            fontWeight: FontWeight.w400,
            fontSize: 8.0,
            fontStyle: FontStyle.italic,
          ),
        ),
      ),
    ),
  );
}