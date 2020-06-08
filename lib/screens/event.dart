import 'package:communitytabs/constants/marist_color_scheme.dart';
import 'package:communitytabs/data/club_event_data.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

class EventDetails extends StatelessWidget {
  final ClubEventData myEvent;
  EventDetails({@required this.myEvent});
  @override
  Widget build(BuildContext context) {
    double _screenWidth = MediaQuery.of(context).size.width;
    double _screenHeight = MediaQuery.of(context).size.height;
    String currentDate = DateFormat('E, MMMM d, y').format(DateTime.now());
    String currentTime = DateFormat.jm().format(DateTime.now());
    bool sameTime = false;
    bool sameStartDate = false;
    int militaryStartTime = 0;
    int militaryEndTime = 0;
    int militaryCurrentTime = 0;
    String startSubtitle = '';
    String endSubtitle = '';

    int _convertToTwentyFourHour({String time}) {
      int militaryTime;
      if (time.contains('PM')) {
        militaryTime = 1200 +
            int.parse(time
                .replaceAll(':', '')
                .replaceAll('PM', '')
                .replaceAll(' ', ''));
      } else
        militaryTime = int.parse(
            time.replaceAll(':', '').replaceAll('AM', '').replaceAll(' ', ''));

      return militaryTime;
    }

    // Convert to military time
    if (this.myEvent.getEndTime.trim().isNotEmpty) {
      militaryEndTime = _convertToTwentyFourHour(time: this.myEvent.getEndTime);
    } else
      militaryEndTime = -1;
    militaryStartTime =
        _convertToTwentyFourHour(time: this.myEvent.getStartTime);
    militaryCurrentTime = _convertToTwentyFourHour(time: currentTime);

    // Check for same date or same time
    if (militaryCurrentTime == militaryStartTime) sameTime = true;
    if (currentDate == this.myEvent.getStartDate) sameStartDate = true;

    if (sameStartDate && sameTime) {
      startSubtitle = 'Event just started now!';
      endSubtitle = 'Event will end at ${this.myEvent.getEndTime}';
    } else if (sameStartDate) {
      if (currentDate == this.myEvent.getEndDate) {
        // Event ends in the same day, compare times
        if (militaryCurrentTime > militaryStartTime) {
          // Current time is AFTER the Event Start Time, but
          // we don't know if the even is in progress or ended.
          if (militaryEndTime != -1) {
            // Check if a end time was provided...
            if (militaryCurrentTime < militaryEndTime) {
              // Current Time is AFTER the Start Time and
              // BEFORE the End Time, meaning the event
              // is in progress
              startSubtitle = 'Event in progress since ${this.myEvent.getStartTime} today!';
              endSubtitle = 'Event will end at ${this.myEvent.getEndTime} today';
            } else {
              // Current Time is AFTER the End Time meaning,
              // the event has ended
              startSubtitle =
                  'Event started at ${this.myEvent.getStartTime} but has ended.';
              endSubtitle = '';
            }
          } else {
            // No end time was provided, so we don't know if the event ended or not.
            // We'll just let them know how long ago it was when the event ended.
            int timeAgo = militaryCurrentTime - militaryStartTime;
            double decimalVal = timeAgo / 100;
            String timeDiff = decimalVal.toString();
            // Hours: index == 0
            // Minutes: index== 1
            List<String> hoursAndMin = timeDiff.split('.');
            bool hasHours =
                hoursAndMin[0].replaceAll('0', '').trim().isNotEmpty;
            bool hasMinutes =
                hoursAndMin[1].replaceAll('0', '').trim().isNotEmpty;

            if (hasHours && hasHours) {
              startSubtitle =
                  'The event started ${hoursAndMin[0]} hour(s) and ${hoursAndMin[1]} minute(s) ago';
              endSubtitle = '';
            } else if (hasHours && !hasHours) {
              startSubtitle = 'The event started ${hoursAndMin[0]} hour(s) ago';
              endSubtitle = '';
            } else if (!hasHours && hasMinutes) {
              startSubtitle =
                  'The event started ${hoursAndMin[1]} minute(s) ago';
              endSubtitle = '';
            }
          }
        } else {
          // Current Time is BEFORE the Event Start Time
          startSubtitle = 'Starts today at ${this.myEvent.getStartTime}';
          endSubtitle = 'Ends today at ${this.myEvent.getEndTime}';
        }
      } else {
        // Event doesn't end on the same day which means the event is still in progress
        startSubtitle = 'Event in progress since ${this.myEvent.getStartTime} today!';
        if (this.myEvent.getEndDate == ''){
          endSubtitle = '';
        } else endSubtitle = 'Event will end on ${this.myEvent.getEndDate} at ${this.myEvent.getEndTime}';
      }
    } else {
      startSubtitle =
          'Starts on ${this.myEvent.getStartDate}, at ${this.myEvent.getStartTime}';
      if (this.myEvent.getEndDate != '') {
        endSubtitle =
            'Ends on ${this.myEvent.getEndDate}, at ${this.myEvent.getEndTime}';
      } else
        endSubtitle = '';
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
            color: cBackground,
            height: _screenHeight,
            width: _screenWidth,
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Container(
                    width: double.infinity,
                    child: Image(image: AssetImage(this.myEvent.getImage)),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * .01),
                  headerLevelOne(
                    context: context,
                    child: Text(
                      this.myEvent.getTitle,
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
                      text: this.myEvent.getHost),
                  subtitle(
                      context: context,
                      icon: Icons.location_on,
                      text: this.myEvent.getRoom.trim().isNotEmpty
                          ? '${this.myEvent.getLocation}, ${this.myEvent.getRoom}'
                          : '${this.myEvent.getLocation} ${this.myEvent.getRoom}'),
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

                  this.myEvent.getHighlights.length > 0
                      ? SizedBox(height: _screenHeight * .04)
                      : Container(),
                  this.myEvent.getHighlights.length > 0
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

                  this.myEvent.getHighlights.length > 0
                      ? highlightsList(
                          context: context, highlights: myEvent.getHighlights)
                      : Container(),

                  /// Summary Section
                  this.myEvent.getSummary.trim().isEmpty
                      ? Container()
                      : SizedBox(height: _screenHeight * .03475),
                  this.myEvent.getSummary.trim().isEmpty
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

                  this.myEvent.getSummary.trim().isEmpty
                      ? Container()
                      : SizedBox(
                          height: MediaQuery.of(context).size.height * .016),
                  this.myEvent.getSummary.trim().isEmpty
                      ? Container()
                      : Row(
                          children: <Widget>[
                            SizedBox(
                              width: MediaQuery.of(context).size.width * .0875,
                            ),
                            Expanded(
                              flex: 9,
                              child: Text(
                                this.myEvent.getSummary,
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
