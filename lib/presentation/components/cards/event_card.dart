import 'dart:typed_data';
import 'package:communitytabs/constants/marist_color_scheme.dart';
import 'package:communitytabs/logic/cubits/cubits.dart';
import 'package:communitytabs/presentation/routes/navigation.dart';
import 'package:database_repository/database_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EventCard extends StatefulWidget {
  final EventModel newEvent;
  EventCard({this.newEvent});

  @override
  _EventCardState createState() => _EventCardState();
} // ClubBigCard

class _EventCardState extends State<EventCard> {
  Uint8List _imageBytes;

  @override
  Widget build(BuildContext context) {
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
    //filePath = 'events/Meet The CommutersColin McCannCommuter Lounge.jpg';

    return BlocProvider(
      create: (context) => FetchImageCubit(
          db: RepositoryProvider.of<DatabaseRepository>(context))
        ..fetchImage(path: filePath),
      child: GestureDetector(
        onTap: () {
          Navigator.of(context).pushNamed(
            '/event',
            arguments: EventScreenArguments(
                documentId: _myEvent.id, imageBytes: _imageBytes),
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
                    final FetchImageState _fetchImageState =
                        context.watch<FetchImageCubit>().state;
                    if (_fetchImageState is FetchImageSuccess) {
                      _imageBytes = _fetchImageState.imageBytes;
                      return Image.memory(
                        _fetchImageState.imageBytes,
                        fit:
                            _eventImageFitCover ? BoxFit.cover : BoxFit.contain,
                      );
                    } // if

                    else if (_fetchImageState is FetchImageFailure) {
                      print('Looking for: $filePath');
                      return Container(
                        color: Colors.black,
                      );
                    } // else if

                    else {
                      return LoadingWidget();
                    } // else
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
} //
