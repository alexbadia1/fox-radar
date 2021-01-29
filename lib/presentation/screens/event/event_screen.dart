import 'dart:typed_data';
import 'package:communitytabs/constants/marist_color_scheme.dart';
import 'package:communitytabs/logic/cubits/fetch_event_cubit.dart';
import 'package:communitytabs/logic/cubits/fetch_event_state.dart';
import 'package:database_repository/database_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'event.dart';

class EventScreen extends StatelessWidget {
  final String eventId;
  final Uint8List imageBytes;
  EventScreen({this.eventId, this.imageBytes});

  @override
  Widget build(BuildContext context) {
    print(eventId.toString());

    double _screenWidth = MediaQuery.of(context).size.width;
    double _screenHeight = MediaQuery.of(context).size.height;

    final screenHeight = MediaQuery.of(context).size.height;
    final screenPaddingBottom = MediaQuery.of(context).padding.bottom;
    final screenInsetsBottom = MediaQuery.of(context).viewInsets.bottom;
    final screenPaddingTop = MediaQuery.of(context).padding.top;

    final height = screenHeight -
        screenPaddingTop -
        screenPaddingBottom +
        screenInsetsBottom;

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
                    automaticallyImplyLeading: false,
                    flexibleSpace: EventSliverAppBarFlexibleSpace(
                        imageBytes: this.imageBytes),
                    expandedHeight: (9 * _screenWidth) / 16,
                  ),
                  SliverToBoxAdapter(
                    child: Builder(
                      builder: (context) {
                        final _fetchEventState =
                            context.watch<FetchFullEventCubit>().state;

                        if (_fetchEventState is FetchFullEventSuccess) {
                          final EventModel _event =
                              _fetchEventState.eventModel;
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              HeaderLevelOne(text: _event.getTitle),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                    children: [
                                      Subtitle(
                                          icon: Icons.person,
                                          text: _event.getHost),
                                      Subtitle(
                                          icon: Icons.location_on,
                                          text:
                                              '${_event.getLocation} ${_event.getRoom}'
                                                  .trim()),
                                      Subtitle(
                                          icon: Icons.access_time,
                                          text: _fetchEventState.startSubtitle),
                                      Subtitle(
                                          icon: Icons.access_time,
                                          text: _fetchEventState.endSubtitle),
                                    ],
                                  ),
                              ),
                              HeaderLevelTwo(text: 'Highlights'),
                              HighlightsList(highlights: _event.getHighlights),

                              /// Summary Section
                              HeaderLevelTwo(text: 'Summary'),

                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  children: <Widget>[
                                    SizedBox(
                                      width:
                                          MediaQuery.of(context).size.width *
                                              .0875,
                                    ),
                                    Expanded(
                                      flex: 9,
                                      child: Text(
                                        _event.getSummary,
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
                              ),

                              /// Back Button
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width *
                                        .001,
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
                                          style:
                                              TextStyle(color: cIlearnGreen),
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
