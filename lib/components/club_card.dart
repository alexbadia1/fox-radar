import 'package:communitytabs/constants/marist_color_scheme.dart';
import 'package:communitytabs/data/club_event_data.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:ui';

/// This widget defines the card that is used in the list of events
Widget clubCard(ClubEventData newEvent, context) {
  ClubEventData _myEvent = newEvent;
  String _eventTitle = _myEvent.getTitle ?? '[Event Title]';
  String _eventHost = _myEvent.getHost ?? '[Event Host]';
  String _eventLocation = _myEvent.getLocation ?? '[Event Location]';
  String _eventRoom = _myEvent.getRoom ?? '[Event Room]';
  String _eventStartDate = _myEvent.getStartDate ?? '[Event Start Date]';
  String _eventStartTime = _myEvent.getStartTime ?? '[Event Start Time]';
  String _eventEndDate = _myEvent.getEndDate ?? '[Event End Date]';
  String _eventEndTime = _myEvent.getEndTime ?? '[Event End Time]';
  return GestureDetector(
    onTap: () {
      Navigator.pushNamed(context, '/eventDetails',
          arguments: {'event': _myEvent});
    },
    child: Container(
      color: cCard,
      height: 100.00,
      width: double.infinity,
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
                            ),
                          ),
                        ),
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
                          color: Color.fromRGBO(255, 255, 255, .99),
                          fontFamily: 'Lato-Regular.ttf',
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0,
                        ),
                      ),
                    ),
                  ),
                ),
                subText(_eventLocation, _eventRoom),
                subText(_eventStartDate),
                subText(_eventStartTime + " -", _eventEndTime),
              ],
            ),
          ),
          Expanded(
            flex: 2,
            child: Container(
              height: double.infinity,
//              child: Image(
//                image: AssetImage(_eventImage),
//                fit: BoxFit.fitHeight,
//              ),
            ),
          ),
        ],
      ),
    ),
  );
}

Widget subText(String newText, [String newEventRoom = ""]) {
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
            color: Color.fromRGBO(255, 255, 255, .7),
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
