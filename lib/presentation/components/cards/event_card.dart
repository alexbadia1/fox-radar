import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:communitytabs/logic/logic.dart';
import 'package:database_repository/database_repository.dart';
import 'package:communitytabs/presentation/presentation.dart';

typedef OnEventCardVertMoreCallback = Function(Uint8List);

class EventCard extends StatefulWidget {
  /// The search result, from firebase
  final SearchResultModel newSearchResult;

  /// The vert more bar, when pressed gives the user,
  /// more options to handle the search result.
  ///
  /// The options will should be displayed using a modal bottom sheet
  final OnEventCardVertMoreCallback onEventCardVertMoreCallback;

  EventCard({Key key, @required this.newSearchResult, this.onEventCardVertMoreCallback})
      : assert(newSearchResult != null),
        super(key: key);

  @override
  _EventCardState createState() => _EventCardState();
} // EventCard

class _EventCardState extends State<EventCard> with AutomaticKeepAliveClientMixin {
  Uint8List _imageBytes;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BlocProvider(
      create: (context) => FetchImageCubit(
        db: RepositoryProvider.of<DatabaseRepository>(context),
      )..fetchImage(eventID: this.widget.newSearchResult.eventId),
      child: GestureDetector(
        onTap: () => Navigator.of(context).pushNamed(
          '/event',
          arguments: EventScreenArguments(
              documentId: this.widget.newSearchResult.eventId,
              imageBytes: _imageBytes,
          ),
        ),
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
                      final FetchImageState _fetchImageState = context.watch<FetchImageCubit>().state;
                      if (_fetchImageState is FetchImageSuccess) {

                        print("Image received, displaying Image.memory!");
                        _imageBytes = _fetchImageState.imageBytes;
                        return Image.memory(
                          _fetchImageState.imageBytes,
                          fit: this.widget.newSearchResult.imageFitCover ? BoxFit.cover : BoxFit.contain,
                        );
                      } // if

                      else if (_fetchImageState is FetchImageFailure) {
                        return Container(
                          color: Colors.black,
                        );
                      } // else if

                      // Image is still being fetch, show a cool loading animation
                      else {
                        return Container(
                          color: Colors.black,
                        );
                      } // else
                    },
                  ),
                ),
              ),
              EventCardDescription(
                profilePicture: Icon(Icons.person),
                title: this.widget.newSearchResult.title,
                location: this.widget.newSearchResult.location,
                startDate: this.widget.newSearchResult.startDate,
                startTime: this.widget.newSearchResult.startTime,
                trailingActions: [
                  Builder(
                    builder: (iconButtonContext) {
                      final imageState = iconButtonContext.watch<FetchImageCubit>().state;

                      if (imageState is FetchImageSuccess) {
                        return IconButton(
                          icon: Icon(Icons.more_vert),
                          color: cWhite70,
                          onPressed: () => this.widget.onEventCardVertMoreCallback(imageState.imageBytes),
                        );
                      } // if

                      /// If the image is still being fetch
                      /// don't let the "more vert button" work.
                      ///
                      /// Don't want a user to try and update an
                      /// event that hasn't fully been fetched yet.
                      return IconButton(
                        icon: Icon(Icons.more_vert),
                        color: cWhite70,
                        onPressed: () => this.widget.onEventCardVertMoreCallback(null),
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true; // build
} // _EventCardState
