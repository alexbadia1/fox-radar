import 'dart:typed_data';
import 'package:communitytabs/constants/marist_color_scheme.dart';
import 'package:communitytabs/logic/cubits/cubits.dart';
import 'package:communitytabs/screens/event.dart';
import 'package:database_repository/database_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ClubBigCard extends StatefulWidget {
  final EventModel newEvent;
  ClubBigCard({this.newEvent});

  @override
  _ClubBigCardState createState() => _ClubBigCardState();
}// ClubBigCard

class _ClubBigCardState extends State<ClubBigCard>
    with AutomaticKeepAliveClientMixin {
  Uint8List globalImageBytes;
  @override
  Widget build(BuildContext context) {
    super.build(context);
    EventModel _myEvent = this.widget.newEvent;
    String _eventTitle = _myEvent.getTitle ?? '[Event Title]';
    String _eventLocation = _myEvent.getLocation ?? '[Event Location]';
    String _eventStartDate = _myEvent.getStartDate ?? '[Event Start Date]';
    String _eventStartTime = _myEvent.getStartTime ?? '[Event Start Time]';
    bool _eventImageFitCover = _myEvent.getImageFitCover ?? true;
    String pathVariable = widget.newEvent.getTitle +
        widget.newEvent.getHost +
        widget.newEvent.getLocation;
    String filePath = 'events/$pathVariable.jpg';

    /// TODO: REMOVE THIS LINE
    filePath = 'events/Meet The CommutersColin McCannCommuter Lounge.jpg';

    return BlocProvider(
      create: (context) => FetchImageCubit(
          db: RepositoryProvider.of<DatabaseRepository>(context))
        ..fetchImage(path: filePath),
      child: GestureDetector(
        onTap: () {
          Navigator.of(context).push(
            PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) =>
                  EventDetails(myEvent: _myEvent, imageBytes: globalImageBytes),
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                var begin = Offset(1.0, 0.0);
                var end = Offset.zero;
                var curve = Curves.ease;

                var tween = Tween(begin: begin, end: end)
                    .chain(CurveTween(curve: curve));

                return SlideTransition(
                  position: animation.drive(tween),
                  child: child,
                );
              },
            ),
          );
        },
        child: Column(
          children: <Widget>[
            AspectRatio(
              aspectRatio: 16 / 9,
              child: Container(
                color: Colors.black,
                child: Builder(
                  builder: (context) {
                    final FetchImageState _fetchImageState = context.watch<FetchImageCubit>().state;

                    if (_fetchImageState is FetchImageSuccess) {
                      return Image.memory(
                        _fetchImageState.imageBytes,
                        fit:
                            _eventImageFitCover ? BoxFit.cover : BoxFit.contain,
                      );
                    }// if

                    else if (_fetchImageState is FetchImageFailure) {
                      print('Looking for: $filePath');
                      return Container(color: Colors.amber,);
                    }// else if

                    else {
                      return LoadingWidget();
                    }// else
                  },
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
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
                        text: _eventLocation + '\n',
                        style: TextStyle(color: cWhite70, fontSize: 10.0)),
                    TextSpan(
                        text: _eventStartDate,
                        style: TextStyle(color: cWhite70, fontSize: 10.0)),
                    TextSpan(text: ' - '),
                    TextSpan(
                        text: _eventStartTime,
                        style: TextStyle(color: cWhite70, fontSize: 10.0))
                  ]),
                ),
                trailing: Icon(Icons.more_vert, color: cWhite70),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}//

