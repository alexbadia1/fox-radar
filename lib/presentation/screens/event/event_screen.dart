import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:fox_radar/logic/logic.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:database_repository/database_repository.dart';
import 'package:fox_radar/presentation/presentation.dart';

class EventScreen extends StatelessWidget {
  final String? eventId;
  final Uint8List? imageBytes;
  EventScreen({this.eventId, this.imageBytes});

  @override
  Widget build(BuildContext context) {
    print(eventId.toString());

    double _screenWidth = MediaQuery.of(context).size.width;
    double _screenHeight = MediaQuery.of(context).size.height;

    return BlocProvider(
      create: (context) => FetchFullEventCubit(
          db: RepositoryProvider.of<DatabaseRepository>(context))
        ..fetchEvent(documentId: this.eventId),
      child: SafeArea(
        child: Scaffold(
          body: GestureDetector(
            onPanUpdate: (details) {
              if (details.delta.dx > 0) {
                Navigator.pop(context);
              } // if
            },
            child: Container(
              color: Colors.black,
              height: _screenHeight,
              width: _screenWidth,
              child: CustomScrollView(
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                slivers: [
                  SliverAppBar(
                    backgroundColor: Colors.black,
                    automaticallyImplyLeading: false,
                    flexibleSpace: EventSliverAppBarFlexibleSpace(
                        imageBytes: this.imageBytes!),
                    expandedHeight: (9 * _screenWidth) / 16,
                  ),
                  SliverToBoxAdapter(
                    child: Builder(
                      builder: (context) {
                        final _fetchEventState =
                            context.watch<FetchFullEventCubit>().state;

                        if (_fetchEventState is FetchFullEventSuccess) {
                          final EventModel _event = _fetchEventState.eventModel;
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              HeaderLevelOne(text: _event.title!),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  children: [
                                    /// Host
                                    ///
                                    /// Only show [Icons.person] followed by host name if it was included
                                    _event.host!.replaceAll(" ", "").isNotEmpty
                                        ? Subtitle(
                                            icon: Icons.person,
                                            text: _event.host)
                                        : SizedBox(),

                                    /// Location
                                    ///
                                    /// Only show [Icons.location_on] followed by location if it was included
                                    _event.location
                                            !.replaceAll(" ", "")
                                            .isNotEmpty
                                        ? Subtitle(
                                            icon: Icons.location_on,
                                            text: _event.room
                                                    !.replaceAll(" ", "")
                                                    .isNotEmpty
                                                ? '${_event.location} ${_event.room}'
                                                    .trim()
                                                : _event.location!.trim(),
                                          )
                                        : SizedBox(),

                                    /// Start Date Time
                                    ///
                                    /// Only show [Icons.access_time] followed by Start Date and Time if it was included
                                    _fetchEventState.startSubtitle
                                            .replaceAll(" ", "")
                                            .isNotEmpty
                                        ? Subtitle(
                                            icon: Icons.access_time,
                                            text: _fetchEventState.startSubtitle,
                                          )
                                        : SizedBox(),

                                    /// End Date Time
                                    ///
                                    /// Only show [Icons.access_time] followed by End Date and Time if it was included
                                    /// _fetchEventState.startSubtitle
                                    _fetchEventState.endSubtitle
                                            .replaceAll(" ", "")
                                            .isNotEmpty
                                        ? Subtitle(
                                            icon: Icons.access_time,
                                            text: _fetchEventState.endSubtitle,
                                          )
                                        : SizedBox(),
                                  ],
                                ),
                              ),
                              _event.highlights!.isNotEmpty ? HeaderLevelTwo(text: 'Highlights') : SizedBox(),
                              _event.highlights!.isNotEmpty ? HighlightsList(highlights: _event.highlights!) : SizedBox(),

                              /// Summary Section
                              _event.description!.replaceAll(" ", "").isNotEmpty ? HeaderLevelTwo(text: 'Summary') : SizedBox(),

                              _event.description!.replaceAll(" ", "").isNotEmpty ? Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  children: <Widget>[
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          .0875,
                                    ),
                                    Expanded(
                                      flex: 9,
                                      child: Text(
                                        _event.description!,
                                        style: TextStyle(
                                          color: cWhite70,
                                          fontSize: 12.0,
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
                              ) : SizedBox(),

                              /// Back Button
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width *
                                        .001,
                                  ),
                                  TextButton(
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
                            ],
                          );
                        } else if (_fetchEventState is FetchFullEventFailure) {
                          return Center(
                            child: Text(
                                'OOPS! Looks like we can\'t find the event!'),
                          );
                        } // if
                        else {
                          return Center(child: LoadingWidget());
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
