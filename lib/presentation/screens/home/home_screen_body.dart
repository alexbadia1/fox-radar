import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:communitytabs/logic/blocs/blocs.dart';
import 'package:communitytabs/presentation/buttons/buttons.dart';
import 'package:communitytabs/constants/marist_color_scheme.dart';
import 'package:communitytabs/presentation/components/components.dart';

class HomeScreenBody extends StatefulWidget {
  //TODO: Add add preferences Arguments for Horizontal Lists for preferences.
  @override
  _HomeScreenBodyState createState() => _HomeScreenBodyState();
} // HomeScreenBody

class _HomeScreenBodyState extends State<HomeScreenBody> {
  Completer<void> _refreshCompleter;
  ScrollController _sliverController;
  GlobalKey navigation = new GlobalKey();

  @override
  void initState() {
    super.initState();
    _refreshCompleter = Completer();
    _sliverController = ScrollController();

    _sliverController.addListener(() {
      SuggestedEventsState _currentState = BlocProvider.of<SuggestedEventsBloc>(context).state;

      /// User is at bottom, fetch more events
      if (_sliverController.position.pixels >= _sliverController.position.maxScrollExtent / 3) {

        /// Check the current state to prevent spamming bloc with fetch events
        if (_currentState is SuggestedEventsStateSuccess) {
          if (!_currentState.maxEvents) {

            /// Add a fetch event to the SuggestedEventsBloc
            BlocProvider.of<SuggestedEventsBloc>(context).add(SuggestedEventsEventFetch());
          } // if
        } // if
      } // else-if
    });
  } // initState

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final screenPaddingBottom = MediaQuery.of(context).padding.bottom;
    final screenInsetsBottom = MediaQuery.of(context).viewInsets.bottom;
    final screenPaddingTop = MediaQuery.of(context).padding.top;

    final _realHeight = screenHeight -
        screenPaddingTop -
        screenPaddingBottom +
        screenInsetsBottom;

    return Container(
      color: Color.fromRGBO(24, 24, 24, 1.0),
      child: CustomScrollView(
        slivers: [
          MaristSliverAppBar(title: 'Marist'),
          SliverFillRemaining(
            child: Builder(builder: (context) {
              final _suggestedEventsBlocState = context.watch<SuggestedEventsBloc>().state;

              // Completer will complete when a new SuggestedEventsStateSuccess state is emitted by the bloc.
              // Refresh indicator will stay loading until this state changed is observed. Once the Completer
              // is completed, a new instance of the Completer is created for the user next reload.
              if (_suggestedEventsBlocState is SuggestedEventsStateSuccess) {
                  _refreshCompleter.complete();
                  _refreshCompleter = Completer();
              } // if

              // Refresh indicator adds a fetch event to the SuggestedEventsBloc then waits for a "Completer" to complete.
              return RefreshIndicator(
                color: cWhite70,
                displacement: 15,
                backgroundColor: Colors.transparent,
                onRefresh: () async {
                  BlocProvider.of<SuggestedEventsBloc>(context).add(SuggestedEventsEventReload());
                  final _future = await _refreshCompleter.future;
                  return _future;
                },

                // Scrollbar is placed around the nested scrollview to prevent the scroll bar from overlapping the Appbar.
                child: Scrollbar(
                  radius: Radius.circular(50.0),
                  child: CustomScrollView(
                    controller: _sliverController,
                    physics: AlwaysScrollableScrollPhysics(),
                    slivers: [

                      // On "App Startup", Make the loading widget take up the whole screen
                      // Otherwise, the loading widget should be hidden
                      Builder(
                        builder: (context) {
                          final SuggestedEventsState _suggestedEventsState =
                              context.watch<SuggestedEventsBloc>().state;
                          if (_suggestedEventsState
                              is SuggestedEventsStateFetching) {
                            return SliverToBoxAdapter(
                              child: Container(
                                height: _realHeight -
                                    MediaQuery.of(context).size.height * .0625 -
                                    MediaQuery.of(context).size.height * 0.0725,
                                child: Center(
                                  child: SizedBox(
                                    height: _realHeight * .03,
                                    width: screenWidth * .05,
                                    child: CircularProgressIndicator(
                                      backgroundColor: Colors.transparent,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                          cWhite70),
                                      strokeWidth: 2.25,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          } // if
                          return SliverToBoxAdapter(child: Container());
                        },
                      ),

                      // A list of buttons that trigger the PageView to go to the next page
                      // in the page view and show the appropriate list views
                      Builder(builder: (context) {
                        final SuggestedEventsState _suggestedEventsState = context.watch<SuggestedEventsBloc>().state;

                        // Don't show the Category Navigation Menu while retrieving events
                        if (_suggestedEventsState is SuggestedEventsStateFetching) {
                          return SliverToBoxAdapter(
                            child: Container(
                              color: Color.fromRGBO(61, 61, 61, 1.0),
                            ),
                          );
                        } // if

                        // The Category Navigation Menu is implemented with a SliverGrid wrapped in Sliver Padding.
                        // Currently there are 6 Navigation Widgets, however if more categories are to be added,
                        // make the SliverGrid scroll horizontally.
                        return SliverPadding(
                          padding: const EdgeInsets.all(12.0),
                          sliver: SliverGrid.count(
                            key: navigation,
                            crossAxisCount: 2,
                            crossAxisSpacing: MediaQuery.of(context).size.width * .05,
                            mainAxisSpacing: MediaQuery.of(context).size.height * .015,
                            childAspectRatio: 4,
                            children: <Widget>[

                              // The Navigation Item is a re-usable button
                              // Arguments:
                              //   [option]: sets the title of the next PageView
                              //   [icon]: sets the current icon of the navigation button
                              //   [gradient]: an image that sets the background for the navigation button
                              CategoryNavigationButton(
                                  category: 'Arts',
                                  icon: Icons.palette,
                                  imagePath: "images/soft_red_banner.jpg"),
                              CategoryNavigationButton(
                                  category: 'Sports',
                                  icon: Icons.flag,
                                  imagePath: "images/soft_green_banner.png"),
                              CategoryNavigationButton(
                                  category: 'Diversity',
                                  icon: Icons.public,
                                  imagePath: "images/fresh_milk_banner.png"),
                              CategoryNavigationButton(
                                  category: 'Student',
                                  icon: Icons.library_books,
                                  imagePath: "images/sharp_blue_banner.png"),
                              CategoryNavigationButton(
                                  category: 'Food',
                                  icon: Icons.local_dining,
                                  imagePath: "images/soft_yellow_banner.jpg"),
                              CategoryNavigationButton(
                                  category: 'Greek',
                                  icon: Icons.account_balance,
                                  imagePath: "images/everlasting_banner.png"),
                            ],
                          ),
                        );
                      }),

                      SliverListHeader(),

                      // List of events implemented with SliverList.
                      // Sliver List receives data from the SuggestedEventsBloc and builds "Event Cards"
                      // for each event, with the last widget being a loading widget if necessary
                      Builder(
                        builder: (context) {
                          final _suggestedEventsState = context.watch<SuggestedEventsBloc>().state;

                          if (_suggestedEventsState is SuggestedEventsStateSuccess) {
                            return SliverList(
                              delegate: SliverChildBuilderDelegate(
                                (BuildContext context, int index) {
                                  if (index <
                                      _suggestedEventsState
                                          .eventModels.length) {
                                    return EventCard(
                                        newSearchResult: _suggestedEventsState
                                            .eventModels
                                            .elementAt(index));
                                  } // if
                                  else {
                                    return Builder(builder: (context) {
                                      final SuggestedEventsState _nestedSuggestedEventsState = context.watch<SuggestedEventsBloc>().state;
                                      if (_nestedSuggestedEventsState is SuggestedEventsStateSuccess) {
                                        if (!_nestedSuggestedEventsState.maxEvents) {
                                          return BottomLoadingWidget();
                                        } // if
                                        else {
                                          return Container(height: _realHeight * .1);
                                        } // else
                                      } // if
                                      else {
                                        return Container();
                                      }// else
                                    });
                                  } // else
                                },
                                addAutomaticKeepAlives: true,
                                childCount: _suggestedEventsState.eventModels.length + 1
                              ),
                            );
                          } // if

                          // Kindly tell the user there are no events
                          else if (_suggestedEventsState is SuggestedEventsStateFailed) {
                            return SliverFillRemaining(child: Center(child: Text('Looks Like Nothing\'s Going On?')));
                          }// if

                          // Something went wrong
                          else {
                            return SliverFillRemaining(child: Center(child: Text('Something Went Wrong Oops!')));
                          } // else
                        },
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }// build

  @override
  void dispose() {
    _sliverController.dispose();
    super.dispose();
  } // dispose
}// _HomeScreenBodyState
