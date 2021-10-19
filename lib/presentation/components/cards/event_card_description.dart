import 'package:flutter/material.dart';
import 'package:fox_radar/presentation/presentation.dart';

class EventCardDescription extends StatelessWidget {
  const EventCardDescription({
    Key key,
    @required this.profilePicture,
    @required this.title,
    @required this.location,
    @required this.startDate,
    @required this.startTime,
    @required this.trailingActions,
  }) : super(key: key);

  final Widget profilePicture;
  final String title;
  final String location;
  final String startDate;
  final String startTime;
  final List<Widget> trailingActions;

  @override
  Widget build(BuildContext context) {
    final _adjustedHeight = MediaQuery.of(context).size.height -
        MediaQuery.of(context).padding.top -
        MediaQuery.of(context).padding.bottom +
        MediaQuery.of(context).viewInsets.bottom;

    return ConstrainedBox(
      constraints: BoxConstraints(
          minWidth: double.infinity,
          minHeight: _adjustedHeight * .12,
          maxHeight: _adjustedHeight * .15,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Expanded(
              flex: 3,
              child: CircleAvatar(
                child: this.profilePicture,
              ),
          ),
          Expanded(
            flex: 13,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      /// Name: Text
                      ///
                      /// Description: The title of the event,
                      ///              Ellipses on overflow.
                      Text(
                        this.title,
                        maxLines: 2,
                        textAlign: TextAlign.start,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(color: cWhite100, fontSize: 16.0),
                      ),
                      SizedBox(height: 4),

                      /// Name: Text
                      ///
                      /// Description: The location of the event,
                      ///              Ellipses on overflow.
                      Text(
                        this.location,
                        maxLines: 1,
                        textAlign: TextAlign.start,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(color: cWhite70, fontSize: 12.0),
                      ),
                      SizedBox(height: 2),

                      /// Name: Text
                      ///
                      /// Description: The start date and
                      ///              time of the event,
                      ///              Ellipses on overflow.
                      Text(
                        '${this.startDate} ${this.startTime}',
                        maxLines: 1,
                        textAlign: TextAlign.start,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(color: cWhite70, fontSize: 12.0),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 3,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: this.trailingActions,
            ),
          ),
        ],
      ),
    );
  }// build
} // _EventCardDescription