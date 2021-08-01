import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:communitytabs/logic/logic.dart';
import 'package:communitytabs/presentation/presentation.dart';

class HomeScreenBody extends StatefulWidget {
  @override
  _HomeScreenBodyState createState() => _HomeScreenBodyState();
} // HomeScreenBody

class _HomeScreenBodyState extends State<HomeScreenBody> with AutomaticKeepAliveClientMixin {
  Completer<void> _refreshCompleter;
  ScrollController _sliverController;
  GlobalKey navigation = new GlobalKey();

  @override
  void initState() {
    super.initState();

    // Instantiate a new Completer to allow for refresh events
    _refreshCompleter = Completer();

    // Attach a scroll controller for auto pagination
    _sliverController = ScrollController();

    // When nearing the bottom of the page, fetch more events
    _sliverController.addListener(() {
      SuggestedEventsState _currentState = BlocProvider.of<SuggestedEventsBloc>(context).state;

      // User is about 2/3 to the bottom of the list, fetch more
      // events, in an effort to load events before they get to the bottom.
      if (_sliverController.position.pixels >= _sliverController.position.maxScrollExtent / 3) {
        // Check the current state to prevent spamming bloc with fetch events
        if (_currentState is SuggestedEventsStateSuccess) {
          if (!_currentState.maxEvents) {
            // Add a fetch event to the SuggestedEventsBloc
            BlocProvider.of<SuggestedEventsBloc>(context).add(SuggestedEventsEventFetch());
          } // if
        } // if
      } // else-if
    });
  } // initState

  @override
  Widget build(BuildContext homeScreenBodyContext) {
    super.build(homeScreenBodyContext); // AutomaticKeepAliveClientMixin require this.
    final screenHeight = MediaQuery.of(homeScreenBodyContext).size.height;
    final screenWidth = MediaQuery.of(homeScreenBodyContext).size.width;
    final screenPaddingBottom = MediaQuery.of(homeScreenBodyContext).padding.bottom;
    final screenInsetsBottom = MediaQuery.of(homeScreenBodyContext).viewInsets.bottom;
    final screenPaddingTop = MediaQuery.of(homeScreenBodyContext).padding.top;

    final _realHeight = screenHeight - screenPaddingTop - screenPaddingBottom + screenInsetsBottom;

    return Container(
      color: Color.fromRGBO(24, 24, 24, 1.0),

      /// Name: CustomScrollView
      ///
      /// Description: Behaves as a "Sliver Scaffold" by changing
      ///              the scroll physics to NeverScrollablePhysics.
      child: CustomScrollView(
        physics: NeverScrollableScrollPhysics(),
        slivers: [
          /// Name: MaristSliverAppBar
          ///
          /// Description: Re-use the marist app bar component,
          ///              assigning a "search icon" as the action.
          MaristSliverAppBar(
            title: 'Marist',
            action: SearchButton(),
          ),

          /// On "App Startup", Make the loading widget take up the
          /// whole screen. Otherwise, the loading widget should be hidden.
          Builder(
            builder: (loadingWidgetContext) {
              final SuggestedEventsState _suggestedEventsState = loadingWidgetContext.watch<SuggestedEventsBloc>().state;

              if (_suggestedEventsState is SuggestedEventsStateFetching) {
                return SliverFillRemaining(
                  child: Container(
                    width: double.infinity,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(height: _realHeight * .35),
                        CustomCircularProgressIndicator(),
                      ],
                    ),
                  ),
                );
              } // if

              /// Name: SliverFillRemaining
              ///
              /// Description: Effectively behaves as the "body" of the "Sliver Scaffold"
              return SliverFillRemaining(
                /// Name: Refresh indicator
                ///
                /// Description: Adds a fetch event to the SuggestedEventsBloc
                ///              then waits for a "Completer" to complete.
                ///
                ///              When the "Completer" is complete, the
                ///              RefreshIndicator's loading widget stops.
                child: Builder(builder: (refreshIndicatorContext) {
                  final _suggestedEventsBlocState = context.watch<SuggestedEventsBloc>().state;

                  if (!(_suggestedEventsBlocState is SuggestedEventsStateFetching)) {
                    // To stop the Refresh Indicator's loading widget,
                    // complete [complete()] the completer [_refreshCompleter].
                    this._refreshCompleter.complete();

                    // Instantiate a new Completer to allow for a new reload event.
                    this._refreshCompleter = Completer();
                  } // if

                  return RefreshIndicator(
                    color: cWhite70,
                    displacement: 15,
                    backgroundColor: Colors.transparent,
                    onRefresh: () async {
                      BlocProvider.of<SuggestedEventsBloc>(refreshIndicatorContext).add(SuggestedEventsEventReload());
                      final _future = await _refreshCompleter.future;
                      return _future;
                    },

                    // Scrollbar is placed around the nested scrollview
                    // to prevent the scroll bar from overlapping the Appbar.
                    child: Scrollbar(
                      radius: Radius.circular(50.0),

                      /// Name: CustomScrollView
                      ///
                      /// Description: Nests a scroll view inside the "SLiver Scaffold"
                      ///              allowing for a list of Events created by the user.
                      child: CustomScrollView(
                        controller: _sliverController,
                        physics: const AlwaysScrollableScrollPhysics(),
                        slivers: [
                          /// CategoryNavigationButtons
                          ///
                          /// Changes the page view to the appropriate category
                          Builder(builder: (navigationContext) {
                            final SuggestedEventsState _suggestedEventsState = navigationContext.watch<SuggestedEventsBloc>().state;

                            // Don't show the Category Navigation Menu while retrieving events
                            if (_suggestedEventsState is SuggestedEventsStateFetching) {
                              return SliverToBoxAdapter(child: Container(color: Color.fromRGBO(61, 61, 61, 1.0)));
                            } // if

                            // Note: if more categories are to be added,
                            // make the SliverGrid scroll horizontally.
                            return SliverPadding(
                              padding: const EdgeInsets.all(12.0),
                              sliver: SliverGrid.count(
                                key: navigation,
                                crossAxisCount: 2,
                                crossAxisSpacing: MediaQuery.of(navigationContext).size.width * .05,
                                mainAxisSpacing: MediaQuery.of(navigationContext).size.height * .015,
                                childAspectRatio: 4,
                                children: <Widget>[
                                  /// The Navigation Item is a re-usable button
                                  /// Arguments:
                                  ///   [option]: sets the title of the next PageView
                                  ///   [icon]: sets the current icon of the navigation button
                                  ///   [gradient]: an image that sets the background for the navigation button
                                  CategoryNavigationButton(category: 'Arts', icon: Icons.palette, imagePath: "images/soft_red_banner.jpg"),
                                  CategoryNavigationButton(category: 'Sports', icon: Icons.flag, imagePath: "images/soft_green_banner.png"),
                                  CategoryNavigationButton(category: 'Diversity', icon: Icons.public, imagePath: "images/fresh_milk_banner.png"),
                                  CategoryNavigationButton(category: 'Student', icon: Icons.library_books, imagePath: "images/sharp_blue_banner.png"),
                                  CategoryNavigationButton(category: 'Food', icon: Icons.local_dining, imagePath: "images/soft_yellow_banner.jpg"),
                                  CategoryNavigationButton(
                                      category: 'Greek', icon: Icons.account_balance, imagePath: "images/everlasting_banner.png"),
                                ],
                              ),
                            );
                          }),

                          /// Name: SliverListHeader
                          ///
                          /// Description: Only show header, if the
                          ///              user events were retrieved.
                          Builder(builder: (headerContext) {
                            final SuggestedEventsState _suggestedEventsState = headerContext.watch<SuggestedEventsBloc>().state;

                            if (_suggestedEventsState is SuggestedEventsStateFetching) {
                              return SliverToBoxAdapter(child: Container(color: Color.fromRGBO(61, 61, 61, 1.0)));
                            } // if
                            return SliverListHeader(text: 'Up Coming');
                          }),

                          /// List of users' events implemented with SliverList.
                          ///
                          /// Sliver List receives data from the AccountEventsBloc
                          /// and builds "Event Cards" for each event, with
                          /// the last widget being a loading widget if necessary.
                          Builder(builder: (suggestedEventsContext) {
                            final _suggestedEventsState = suggestedEventsContext.watch<SuggestedEventsBloc>().state;

                            if (_suggestedEventsState is SuggestedEventsStateSuccess) {
                              return SliverList(
                                delegate: SliverChildBuilderDelegate(
                                  (BuildContext context, int index) {
                                    /// Not at the bottom...
                                    ///
                                    /// Show each search result in an [EventCard] widget.
                                    /// When clicking on the card, the full event is retrieved.
                                    if (index < _suggestedEventsState.eventModels.length) {
                                      return EventCard(
                                        key: ObjectKey(_suggestedEventsState.eventModels.elementAt(index)),
                                        newSearchResult: _suggestedEventsState.eventModels.elementAt(index),
                                        onEventCardVertMoreCallback: (imageBytes) {
                                          // TODO: Give user options to save or report events
                                        },
                                      );
                                    } // if

                                    /// At the bottom of the list...
                                    ///
                                    /// Might need to show a loading widget while
                                    /// Retrieving more events, unless there are no
                                    /// more events to retrieve (maxEvents == true).
                                    else {
                                      return Builder(builder: (context) {
                                        final SuggestedEventsState _nestedSuggestedEventsState = context.watch<SuggestedEventsBloc>().state;

                                        /// Only return a loading widget if there are
                                        /// are more events to retrieve. Otherwise
                                        /// show an empty container as a bottom margin.
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
                                        } // else
                                      });
                                    } // else
                                  },
                                  addAutomaticKeepAlives: true,
                                  childCount: _suggestedEventsState.eventModels.length + 1,
                                ),
                              );
                            } // if

                            // There are no events that start near the current time
                            else if (_suggestedEventsState is SuggestedEventsStateFailed) {
                              return SliverToBoxAdapter(
                                child: Column(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Image(
                                      image: AssetImage(
                                        'images/cactus_bulldog.png',
                                      ),
                                      height: _realHeight * .29,
                                      width: screenWidth * .29,
                                    ),
                                    Text(
                                      'No events, but we found this on our servers...',
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(color: cWhite70, fontSize: 16.0),
                                    ),
                                    cVerticalMarginSmall(context),
                                    Builder(
                                      builder: (retryContext) {
                                        final _state = retryContext.watch<SuggestedEventsBloc>().state;

                                        if (_state is SuggestedEventsStateFetching) {
                                          return CustomCircularProgressIndicator();
                                        } // if

                                        return TextButton(
                                          child: Text(
                                            'RETRY',
                                            style: TextStyle(color: Colors.blueAccent, fontSize: 16.0),
                                          ),
                                          onPressed: () {
                                            BlocProvider.of<SuggestedEventsBloc>(context).add(SuggestedEventsEventReload());
                                          },
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              );
                            } // else if

                            // Don't show the sliver list, since events are still being fetched,
                            // Also don't know if the event fetch failed, so can't return the cactus dog image.
                            else if (_suggestedEventsState is SuggestedEventsStateFetching) {
                              return SliverToBoxAdapter(child: Container(color: Color.fromRGBO(61, 61, 61, 1.0)));
                            } // else if

                            // Don't show anything, since a reload failure should immediately be followed by an event fetch failure
                            else if (_suggestedEventsState is SuggestedEventsStateReloadFailed) {
                              return SliverToBoxAdapter(child: Container(color: Color.fromRGBO(61, 61, 61, 1.0)));
                            } // else if

                            // Something went wrong
                            else {
                              return SliverFillRemaining(
                                child: Center(
                                  child: Text('Something Went Wrong Oops!'),
                                ),
                              );
                            } // else
                          }),
                        ],
                      ),
                    ),
                  );
                }),
              );
            },
          ),
        ],
      ),
    );
  } // build

  @override
  bool get wantKeepAlive => true;

  @override
  void dispose() {
    _sliverController.dispose();
    super.dispose();
  } // dispose
} // _HomeScreenBodyState
