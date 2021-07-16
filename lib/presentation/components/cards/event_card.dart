import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:communitytabs/logic/logic.dart';
import 'package:database_repository/database_repository.dart';
import 'package:communitytabs/presentation/presentation.dart';

class EventCard extends StatefulWidget {
  final SearchResultModel newSearchResult;
  EventCard({@required this.newSearchResult}) : assert(newSearchResult != null);

  @override
  _EventCardState createState() => _EventCardState();
} // ClubBigCard

class _EventCardState extends State<EventCard> with AutomaticKeepAliveClientMixin{
  Uint8List _imageBytes;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    String filePath = 'events/${this.widget.newSearchResult.eventId}.jpg';

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
            arguments: EventScreenArguments(documentId: this.widget.newSearchResult.eventId, imageBytes: _imageBytes),
          );
        },
        child: Container(
          decoration: BoxDecoration(
            color: Color.fromRGBO(33, 33, 33, 1.0),
            border: Border(
              top: BorderSide(
                color: Color.fromRGBO(61, 61, 61, 1.0),
              ),
            ),
          ),
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
                          this.widget.newSearchResult.getImageFitCover ? BoxFit.cover : BoxFit.contain,
                        );
                      } // if

                      else if (_fetchImageState is FetchImageFailure) {
                        print('Looking for: $filePath');
                        return Container(
                          color: Colors.black,
                        );
                      } // else if

                      else {
                        return Container(
                          color: Colors.black,
                        );
                        // return LoadingWidget(
                        //   size: 75.0,
                        // );
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
                    this.widget.newSearchResult.getTitle,
                    textAlign: TextAlign.start,
                    style: TextStyle(color: cWhite100),
                  ),
                  subtitle: RichText(
                    text: TextSpan(children: [
                      TextSpan(
                          text: this.widget.newSearchResult.getLocation + '\n',
                          style: TextStyle(color: cWhite70, fontSize: 10.0)),
                      TextSpan(
                          text: this.widget.newSearchResult.myStartDate,
                          style: TextStyle(color: cWhite70, fontSize: 10.0)),
                      TextSpan(text: ' '),
                      TextSpan(
                          text: this.widget.newSearchResult.myStartTime,
                          style: TextStyle(color: cWhite70, fontSize: 10.0))
                    ]),
                  ),
                  trailing: Icon(Icons.more_vert, color: cWhite70),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }// build

  @override
  bool get wantKeepAlive => true;
} // _EventCardState
