import 'dart:typed_data';
import 'package:communitytabs/constants/marist_color_scheme.dart';
import 'package:communitytabs/data/club_event_data.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';


class EventDetails extends StatelessWidget {
  final ClubEventData myEvent;
  final Uint8List imageBytes;
  EventDetails({this.myEvent, this.imageBytes});
  @override
  Widget build(BuildContext context) {
    double _screenWidth = MediaQuery.of(context).size.width;
    double _screenHeight = MediaQuery.of(context).size.height;
    DateTime myCurrent = DateTime(
        DateTime.now().year,
        DateTime.now().month,
        DateTime.now().day,
        DateTime.now().hour,
        DateTime.now().minute,
        0,
        0,
        0);
    DateTime myStart = myEvent.getRawStartDateAndTime;
    DateTime myEnd = myEvent.getRawEndDateAndTime;
    String myFormattedStartDate = '';
    String myFormattedEndDate = '';
    String startSubtitle = '';
    String endSubtitle = '';

    if (myCurrent.difference(myStart).inDays == 0) {
      myFormattedStartDate = 'today';
    } else if (myCurrent.difference(myStart).inDays == 1) {
      myFormattedStartDate = 'yesterday';
    } else if (myCurrent.difference(myStart).inDays == -1) {
      myFormattedStartDate = 'tomorrow';
    } else {
      myFormattedStartDate = 'on ${myEvent.getStartDate}';
    }

    if (myEnd != null) {
      if (myCurrent
          .difference(myEnd)
          .inDays == 0) {
        myFormattedEndDate = 'today';
      } else if (myCurrent
          .difference(myEnd)
          .inDays == 1) {
        myFormattedEndDate = 'yesterday';
      } else if (myCurrent
          .difference(myEnd)
          .inDays == -1) {
        myFormattedEndDate = 'tomorrow';
      } else {
        myFormattedEndDate = 'on ${myEvent.getEndDate}';
      }
    }

    if (myCurrent.isBefore(myStart)) {
      startSubtitle =
          'Starts $myFormattedStartDate at ${myEvent.getStartTime}';
      if (myEvent.getEndDate.trim().isNotEmpty)
        endSubtitle = 'Ends $myFormattedEndDate at ${myEvent.getEndTime}';
    } else if (myCurrent.isAtSameMomentAs(myStart)) {
      startSubtitle = 'Event starts now!';
      if (myEvent.getEndDate.trim().isNotEmpty)
        endSubtitle = 'Ends at ${myEvent.getEndTime} $myFormattedEndDate';
    } else if (myCurrent.isAfter(myStart)) {
      if (myEnd != null) {
        if (myCurrent.isBefore(myEnd)) {
          startSubtitle = 'Started since ${myEvent.getStartTime} $myFormattedStartDate';
          endSubtitle = 'Ends at ${myEvent.getEndTime} $myFormattedEndDate';
        } else {
          startSubtitle = 'Ended since ${myEvent.getEndTime} $myFormattedEndDate ';
        }
      } else {
        startSubtitle = 'Started since ${myEvent.getStartTime} $myFormattedStartDate';
      }
    } else {
      startSubtitle =
          'Ended since ${myEvent.getEndTime} $myFormattedEndDate ';
    }

    return SafeArea(
      child: Scaffold(
        body: GestureDetector(
          onPanUpdate: (details) {
            if (details.delta.dx > 0) {
              Navigator.pop(context);
            }
          },
          child: Container(
            color: Colors.black,
            height: _screenHeight,
            width: _screenWidth,
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  this.imageBytes == null ? Container() : Container(
                    width: double.infinity,
                    child: Image.memory(this.imageBytes, fit: BoxFit.cover,)
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * .01),
                  headerLevelOne(
                    context: context,
                    child: Text(
                      myEvent.getTitle,
                      style: TextStyle(
                        color: cWhite100,
                        fontSize: 32.0,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Lato',
                      ),
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * .00275),
                  subtitle(
                      context: context,
                      icon: Icons.person,
                      text: myEvent.getHost),
                  subtitle(
                      context: context,
                      icon: Icons.location_on,
                      text: myEvent.getRoom.trim().isNotEmpty
                          ? '${myEvent.getLocation}, ${myEvent.getRoom}'
                          : '${myEvent.getLocation} ${myEvent.getRoom}'),
                  subtitle(
                      context: context,
                      icon: Icons.access_time,
                      text: startSubtitle),
                  endSubtitle.trim().isNotEmpty
                      ? subtitle(
                          context: context,
                          icon: Icons.access_time,
                          text: endSubtitle)
                      : Container(),

                  myEvent.getHighlights.length > 0
                      ? SizedBox(height: _screenHeight * .04)
                      : Container(),
                  myEvent.getHighlights.length > 0
                      ? headerLevelTwo(
                          context: context,
                          child: Text(
                            'Highlights',
                            style: TextStyle(
                              color: cWhite100,
                              fontSize: 26.0,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Lato',
                            ),
                          ),
                        )
                      : Container(),

                  myEvent.getHighlights.length > 0
                      ? highlightsList(
                          context: context, highlights: myEvent.getHighlights)
                      : Container(),

                  /// Summary Section
                  myEvent.getSummary.trim().isEmpty
                      ? Container()
                      : SizedBox(height: _screenHeight * .03475),
                  myEvent.getSummary.trim().isEmpty
                      ? Container()
                      : headerLevelTwo(
                          context: context,
                          child: Text(
                            'Summary',
                            style: TextStyle(
                              color: cWhite100,
                              fontSize: 26.0,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Lato',
                            ),
                          ),
                        ),

                  myEvent.getSummary.trim().isEmpty
                      ? Container()
                      : SizedBox(
                          height: MediaQuery.of(context).size.height * .016),
                  myEvent.getSummary.trim().isEmpty
                      ? Container()
                      : Row(
                          children: <Widget>[
                            SizedBox(
                              width: MediaQuery.of(context).size.width * .0875,
                            ),
                            Expanded(
                              flex: 9,
                              child: Text(
                                myEvent.getSummary,
                                style: TextStyle(
                                  color: cWhite70,
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Lato',
                                ),
                              ),
                            ),
                            SizedBox(
                              width: _screenWidth * .125,
                            ),
                          ],
                        ),

                  /// Back Button
                  SizedBox(height: MediaQuery.of(context).size.height * .03),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(
                        width: MediaQuery.of(context).size.width * .001,
                      ),
                      FlatButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Row(
                          children: <Widget>[
                            Icon(
                              Icons.chevron_left,
                              color: cIlearnGreen,
                            ),
                            Text(
                              'Back',
                              style: TextStyle(color: cIlearnGreen),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * .02),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

Row headerLevelOne({Widget child, BuildContext context}) {
  return Row(
    children: <Widget>[
      SizedBox(
        width: MediaQuery.of(context).size.width * .0175,
      ),
      Expanded(child: child),
      SizedBox(
        width: MediaQuery.of(context).size.width * .125,
      ),
    ],
  );
}

Row subtitle({IconData icon, String text, BuildContext context}) {
  return Row(
    children: <Widget>[
      SizedBox(
        width: MediaQuery.of(context).size.width * .022,
      ),
      Expanded(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Expanded(
              flex: 1,
              child: Icon(
                icon,
                color: cWhite70,
                size: 16.0,
              ),
            ),
            Expanded(
              flex: 10,
              child: Text(
                text,
                style: TextStyle(
                  color: cWhite70,
                  fontSize: 14.0,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Lato',
                ),
              ),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * .125,
            ),
          ],
        ),
      )
    ],
  );
}

Row headerLevelTwo({Widget child, BuildContext context}) {
  return Row(
    children: <Widget>[
      SizedBox(
        width: MediaQuery.of(context).size.width * .042,
      ),
      Expanded(child: child),
      SizedBox(
        width: MediaQuery.of(context).size.width * .125,
      ),
    ],
  );
}

Row highlightsList(
    {IconData icon, List<String> highlights, BuildContext context}) {
  return Row(
    children: <Widget>[
      SizedBox(
        width: MediaQuery.of(context).size.width * .04275,
      ),
      Expanded(
        child: ListView.builder(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: highlights.length,
            itemBuilder: (context, index) {
              return Column(
                children: <Widget>[
                  SizedBox(height: MediaQuery.of(context).size.height * .018),
                  subtitle(
                      context: context,
                      icon: Icons.add,
                      text: highlights[index]),
                ],
              );
            }),
      ),
      SizedBox(
        width: MediaQuery.of(context).size.width * .125,
      ),
    ],
  );
}
