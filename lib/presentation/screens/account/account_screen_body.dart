import 'dart:async';
import 'package:flutter/material.dart';
import 'package:communitytabs/logic/logic.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:communitytabs/presentation/presentation.dart';

class AccountScreenBody extends StatefulWidget {
  @override
  _AccountScreenBodyState createState() => _AccountScreenBodyState();
} // AccountScreenBody

class _AccountScreenBodyState extends State<AccountScreenBody>
    with AutomaticKeepAliveClientMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  Completer<void> _refreshCompleter;
  ScrollController _scrollController;

  @override
  void initState() {
    super.initState();

    // Instantiate a new Completer to allow for refresh events
    this._refreshCompleter = Completer();

    // Attach a scroll controller for auto pagination
    this._scrollController = ScrollController();

    // When nearing the bottom of the page, fetch more events
    this._scrollController.addListener(() {
      AccountEventsState _currentState =
          BlocProvider.of<AccountEventsBloc>(context).state;

      // User is about 2/3 to the bottom of the list, fetch more
      // events, in an effort to load events before they get to the bottom.
      if (this._scrollController.position.pixels >=
          this._scrollController.position.maxScrollExtent / 3) {
        // Check the current state to prevent spamming bloc with fetch events
        if (_currentState is AccountEventsStateSuccess) {
          if (!_currentState.maxEvents) {
            // Add a fetch event to the AccountsEventsBloc
            BlocProvider.of<AccountEventsBloc>(context)
                .add(AccountEventsEventFetch());
          } // if
        } // if
      } // else-if
    });
  } // initState

  @override
  Widget build(BuildContext accountScreenBodyContext) {
    super.build(
        accountScreenBodyContext); // AutomaticKeepAliveClientMixin require this.
    final screenHeight = MediaQuery.of(accountScreenBodyContext).size.height;
    final screenWidth = MediaQuery.of(accountScreenBodyContext).size.width;
    final screenPaddingBottom =
        MediaQuery.of(accountScreenBodyContext).padding.bottom;
    final screenInsetsBottom =
        MediaQuery.of(accountScreenBodyContext).viewInsets.bottom;
    final screenPaddingTop =
        MediaQuery.of(accountScreenBodyContext).padding.top;

    final _realHeight = screenHeight -
        screenPaddingTop -
        screenPaddingBottom +
        screenInsetsBottom;

    return Scaffold(
      key: this._scaffoldKey,
      backgroundColor: cBackground,
      endDrawer: AccountDrawerContents(),

      /// Name: CustomScrollView
      ///
      /// Description: Behaves as a "Sliver Scaffold" by changing
      ///              the scroll physics to NeverScrollablePhysics.
      body: CustomScrollView(
        physics: NeverScrollableScrollPhysics(),
        slivers: [
          /// Name: MaristSliverAppBar
          ///
          /// Description: Re-use the marist app bar component,
          ///              assigning a "hamburger menu" as the action.
          ///
          /// Design Notes: Sliver App bars inherit the Scaffold's end drawer
          ///               button. You can overwrite the icon, by adding an
          ///               action button to the sliver app bar's properties.
          MaristSliverAppBar(
            title: "Hello, Alex",
            action: Builder(
              builder: (context) {
                return AccountDrawerButton(
                  openDrawerCallback: () {
                    // End Drawer is inherited from scaffold
                    Scaffold.of(accountScreenBodyContext).openEndDrawer();
                  },
                );
              },
            ),
          ),

          /// Name: SliverFillRemaining
          ///
          /// Description: Effectively behaves as the "body" of the "Sliver Scaffold"
          SliverFillRemaining(
            /// Name: Refresh indicator
            ///
            /// Description: Adds a fetch event to the AccountEventsBloc
            ///              then waits for a "Completer" to complete.
            ///
            ///              When the "Completer" is complete, the
            ///              RefreshIndicator's loading widget stops.
            child: Builder(builder: (BuildContext refreshIndicatorContext) {
              final _accountEventsBlocState =
                  refreshIndicatorContext.watch<AccountEventsBloc>().state;

              // AccountEventsBloc must either be [AccountEventsStateSuccess]
              // or [AccountEventsStateFailed] (Not [AccountEventsStateFetching])
              if (!(_accountEventsBlocState is AccountEventsStateFetching)) {
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
                  BlocProvider.of<AccountEventsBloc>(refreshIndicatorContext)
                      .add(AccountEventsEventReload());
                  BlocProvider.of<UploadEventBloc>(refreshIndicatorContext)
                      .add(UploadEventReset());
                  final _future = await this._refreshCompleter.future;
                  return _future;
                },
                child: Scrollbar(
                  radius: Radius.circular(50.0),

                  /// Name: CustomScrollView
                  ///
                  /// Description: Nests a scroll view inside the "SLiver Scaffold"
                  ///              allowing for a list of Events created by the user.
                  child: CustomScrollView(
                    physics: AlwaysScrollableScrollPhysics(),
                    controller: this._scrollController,
                    slivers: [
                      /// Name: Builder
                      ///
                      /// Description: When a new event is created by the
                      ///              user, show the upload progress at the top.
                      Builder(
                        builder: (imageUploadProgressContext) {
                          UploadEventState uploadState =
                              accountScreenBodyContext
                                  .watch<UploadEventBloc>()
                                  .state;

                          // Show upload progress at top
                          if (uploadState is UploadEventStateUploading) {
                            return SliverToBoxAdapter(
                              child: ImageUploadProgress(
                                eventModel: uploadState.eventModel,
                              ),
                            );
                          } // if

                          // Don't show image upload progress
                          return SliverToBoxAdapter(child: SizedBox());
                        },
                      ),

                      /// Name: SliverListHeader
                      ///
                      /// Description: Only show header, if the
                      ///              user events were retrieved.
                      Builder(builder: (headerContext) {
                        final AccountEventsState _accountEventsState =
                            headerContext.watch<AccountEventsBloc>().state;

                        if (_accountEventsState is AccountEventsStateFetching) {
                          return SliverToBoxAdapter(child: Container());
                        } // if

                        return SliverListHeader(text: 'My Events');
                      }),

                      /// Name: CircularProgressIndicator
                      ///
                      /// Description: Show a loading widget
                      ///              while retrieving users' events.
                      Builder(
                        builder: (loadingWidgetContext) {
                          final AccountEventsState _accountEventsBlocState =
                              loadingWidgetContext
                                  .watch<AccountEventsBloc>()
                                  .state;

                          if (!(_accountEventsBlocState
                              is AccountEventsStateFetching)) {
                            return SliverToBoxAdapter(child: Container());
                          } // if

                          return SliverFillRemaining(
                            child: Center(
                              child: SizedBox(
                                height: _realHeight * .03,
                                width: screenWidth * .05,
                                child: CircularProgressIndicator(
                                  backgroundColor: Colors.transparent,
                                  valueColor:
                                      AlwaysStoppedAnimation<Color>(cWhite70),
                                  strokeWidth: 2.25,
                                ),
                              ),
                            ),
                          );
                        },
                      ),

                      /// List of users' events implemented with SliverList.
                      ///
                      /// Sliver List receives data from the AccountEventsBloc
                      /// and builds "Event Cards" for each event, with
                      /// the last widget being a loading widget if necessary.
                      Builder(builder: (userEventsContext) {
                        final _accountEventsState =
                            userEventsContext.watch<AccountEventsBloc>().state;

                        // Show a paginated list view of events created by the account
                        if (_accountEventsState is AccountEventsStateSuccess) {
                          return SliverList(
                            delegate: SliverChildBuilderDelegate(
                              (BuildContext sliverListContext, int index) {
                                /// Not at the bottom...
                                ///
                                /// Show each search result in an [EventCard] widget.
                                /// When clicking on the card, the full event is retrieved.
                                if (index <
                                    _accountEventsState.eventModels.length) {
                                  return EventCard(
                                    newSearchResult: _accountEventsState
                                        .eventModels
                                        .elementAt(index),
                                    onEventCardVertMoreCallback: () {
                                      // Show a modal bottom sheet with
                                      // options to edit or delete an event.
                                      showModalBottomSheet(
                                          context: accountScreenBodyContext,
                                          builder: (modalSheetContext) {
                                            return AccountModalBottomSheet(

                                            );
                                          },// builder
                                      );
                                    },
                                  );
                                } // if

                                /// At the bottom of the list...
                                ///
                                /// Might need to show a loading widget while
                                /// Retrieving more events, unless there are no
                                /// more events to retrieve (maxEvents == true).
                                else {
                                  return Builder(
                                    builder: (bottomListContext) {
                                      final AccountEventsState
                                          _accountEventsState =
                                          bottomListContext
                                              .watch<AccountEventsBloc>()
                                              .state;

                                      /// Only return a loading widget if there are
                                      /// are more events to retrieve. Otherwise
                                      /// show an empty container as a bottom margin.
                                      if (_accountEventsState
                                          is AccountEventsStateSuccess) {
                                        return !_accountEventsState.maxEvents
                                            ? BottomLoadingWidget()
                                            : Container(
                                                height: _realHeight * .1);
                                      } // if
                                      else {
                                        return Container();
                                      } // else
                                    },
                                  );
                                } // else
                              },
                              addAutomaticKeepAlives: true,
                              childCount:
                                  _accountEventsState.eventModels.length + 1,
                            ),
                          );
                        } // if

                        /// The account has no events associated with it.
                        ///
                        /// "Expired" events will be deleted by the database.
                        /// An event is expired when "TBD"...
                        else if (_accountEventsState
                            is AccountEventsStateFailed) {
                          /// Lonely Panda with an inspirational message.
                          /// Trying to inspire the user to make something happen!
                          return SliverFillRemaining(
                            child: Column(
                              children: [
                                Expanded(flex: 1, child: SizedBox()),
                                Expanded(
                                  flex: 1,
                                  child: Image(
                                    image: AssetImage(
                                      'images/lonely_panda.png',
                                    ),
                                    height: screenHeight * .35,
                                    width: screenWidth * .35,
                                  ),
                                ),
                                Text(
                                  'Stop hibernating, make something happen!',
                                  style: TextStyle(color: cWhite70),
                                ),
                                Expanded(flex: 1, child: SizedBox()),
                              ],
                            ),
                          );
                        } // if

                        /// Something went wrong...
                        ///
                        /// TODO: Tell the user what exactly went wrong...
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
          ),
        ],
      ),
    );
  } // build

  @override
  bool get wantKeepAlive => true;

  @override
  void dispose() {
    this._scrollController.dispose();
    super.dispose();
  } // dispose
} // _AccountScreenBodyState
