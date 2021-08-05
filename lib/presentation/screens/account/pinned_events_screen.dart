import 'dart:async';
import 'package:flutter/material.dart';
import 'package:communitytabs/logic/logic.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:communitytabs/presentation/presentation.dart';

class PinnedEventsScreen extends StatefulWidget {
  @override
  _PinnedEventsScreenState createState() => _PinnedEventsScreenState();
} // PinnedEventsScreen

class _PinnedEventsScreenState extends State<PinnedEventsScreen> with AutomaticKeepAliveClientMixin {
  Completer<void> _refreshCompleter;
  ScrollController _scrollController;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();

    // Instantiate a new Completer to allow for refresh events
    this._refreshCompleter = Completer();

    // Attach a scroll controller for auto pagination
    this._scrollController = ScrollController();

    // When nearing the bottom of the page, fetch more events
    this._scrollController.addListener(() {
      SavedEventsState _currentState = BlocProvider.of<SavedEventsBloc>(context).state;

      // User is about 2/3 to the bottom of the list, fetch more
      // events, in an effort to load events before they get to the bottom.
      if (this._scrollController.position.pixels >= this._scrollController.position.maxScrollExtent / 3) {
        // Check the current state to prevent spamming bloc with fetch events
        if (_currentState is SavedEventsStateSuccess) {
          if (!_currentState.maxEvents) {
            // Add a fetch event to the SavedEventsBloc
            BlocProvider.of<SavedEventsBloc>(context).add(SavedEventsEventFetch());
          } // if
        } // if
      } // else-if
    });
  } // initState

  @override
  Widget build(BuildContext context) {
    super.build(context); // AutomaticKeepAliveClientMixin require this.
    final screenWidth = MediaQuery.of(context).size.width;

    final _realHeight = MediaQuery.of(context).size.height -
        MediaQuery.of(context).padding.top -
        MediaQuery.of(context).padding.bottom +
        MediaQuery.of(context).viewInsets.bottom;

    return Scaffold(
        key: this._scaffoldKey,
        backgroundColor: cBackground,
        endDrawer: AccountDrawerContents(),
        body: CustomScrollView(
          physics: NeverScrollableScrollPhysics(),
          slivers: [
            MaristSliverAppBar(
              title: "Hello, Alex",

              /// Name: Builder
              ///
              /// Description: Scaffold was declared in AccountScreenBody's
              ///              context, using [Builder] to access the
              ///              AccountDrawerButtons context in order to
              ///              access the Scaffold.of() functions.
              action: Builder(
                builder: (accountDrawerButtonContext) {
                  return AccountDrawerButton(
                    openDrawerCallback: () {
                      // End Drawer is inherited from scaffold
                      Scaffold.of(accountDrawerButtonContext).openEndDrawer();
                    },
                  );
                },
              ),
            ),
            Builder(builder: (loadingWidgetContext) {
              final _accountSavedEventsBlocState = loadingWidgetContext.watch<SavedEventsBloc>().state;

              if (_accountSavedEventsBlocState is SavedEventsStateFetching) {
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

              return SliverFillRemaining(
                child: Builder(builder: (BuildContext refreshIndicatorContext) {
                  final _savedEventState = refreshIndicatorContext.watch<SavedEventsBloc>().state;
                  // SavedEventsBloc must either be [SavedEventsStateSuccess]
                  // or [SavedEventsStateFailed] (Not [SavedEventsStateFetching])
                  if (!(_savedEventState is SavedEventsStateFetching)) {
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
                      BlocProvider.of<SavedEventsBloc>(refreshIndicatorContext).add(SavedEventsEventReload());
                      BlocProvider.of<UploadEventBloc>(refreshIndicatorContext).add(UploadEventReset());
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
                        physics: const AlwaysScrollableScrollPhysics(),
                        controller: this._scrollController,
                        slivers: [
                          /// Name: Builder
                          ///
                          /// Description: When a new event is created by the
                          ///              user, show the upload progress at the top.
                          Builder(
                            builder: (imageUploadProgressContext) {
                              UploadEventState uploadState = imageUploadProgressContext.watch<UploadEventBloc>().state;

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
                            final SavedEventsState _savedEventsState = headerContext.watch<SavedEventsBloc>().state;

                            if (_savedEventsState is SavedEventsStateFetching) {
                              return SliverToBoxAdapter(child: Container());
                            } // if

                            return SliverListHeader(
                              text: 'My Events',
                              icon: Icons.event,
                              onPressed: () {
                                BlocProvider.of<AccountPageViewCubit>(context).animateToMyEventsPage();
                              },
                            );
                          }),

                          /// Name: SliverListHeader
                          ///
                          /// Description: Only show header, if the
                          ///              user events were retrieved.
                          Builder(builder: (headerContext) {
                            final SavedEventsState _savedEventsState = headerContext.watch<SavedEventsBloc>().state;

                            if (_savedEventsState is SavedEventsStateFetching) {
                              return SliverToBoxAdapter(child: Container());
                            } // if

                            return SliverListHeader(text: 'Pinned Events');
                          }),

                          /// List of users' events implemented with SliverList.
                          ///
                          /// Sliver List receives data from the SavedEventsBloc
                          /// and builds "Event Cards" for each event, with
                          /// the last widget being a loading widget if necessary.
                          Builder(builder: (pinnedEventsContext) {
                            final _savedEventsState = pinnedEventsContext.watch<SavedEventsBloc>().state;

                            // Show a paginated list view of events pinned by the account
                            if (_savedEventsState is SavedEventsStateSuccess) {
                              return SliverList(
                                delegate: SliverChildBuilderDelegate(
                                  (BuildContext sliverListContext, int index) {
                                    /// Not at the bottom...
                                    ///
                                    /// Show each search result in an [EventCard] widget.
                                    /// When clicking on the card, the full event is retrieved.
                                    if (index < _savedEventsState.eventModels.length) {
                                      return EventCard(
                                        key: ObjectKey(_savedEventsState.eventModels.elementAt(index)),
                                        newSearchResult: _savedEventsState.eventModels.elementAt(index),
                                        onEventCardVertMoreCallback: (imageBytes) {
                                          // Show a modal bottom sheet with
                                          // options to edit or delete an event.
                                          showModalBottomSheet(
                                            context: pinnedEventsContext,
                                            builder: (modalSheetContext) {
                                              /// Pass the current SavedEventsBloc.
                                              ///
                                              /// Bottom Modal Sheet is built within
                                              /// its own context, that doesn't have
                                              /// access to the current widget's context.
                                              return Builder(
                                                builder: (modalSheetContext) {
                                                  // Events shown on rhe screen should already be unpinned
                                                  return ModalActionMenu(
                                                    prompt: "Upinning the event will make it no longer viewable on the Account Screen.",
                                                    actions: [
                                                      ModalActionMenuButton(
                                                          icon: Icons.undo_rounded,
                                                          description: "Unpin Event",
                                                          color: Colors.blueAccent,
                                                          onPressed: () {}),
                                                    ],
                                                    cancel: true,
                                                  );
                                                },
                                              );
                                            }, // builder
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
                                          final _state = pinnedEventsContext.watch<SavedEventsBloc>().state;

                                          /// Only return a loading widget if there are
                                          /// are more events to retrieve. Otherwise
                                          /// show an empty container as a bottom margin.
                                          if (_state is SavedEventsStateSuccess) {
                                            return !_state.maxEvents ? BottomLoadingWidget() : Container(height: _realHeight * .1);
                                          } // if
                                          else {
                                            return Container();
                                          } // else
                                        },
                                      );
                                    } // else
                                  },
                                  addAutomaticKeepAlives: true,
                                  childCount: _savedEventsState.eventModels.length + 1,
                                ),
                              );
                            } // if

                            /// The account has no pinned events with it.
                            ///
                            /// "Expired" events will be deleted by the database.
                            /// An event is expired when "TBD"...
                            else if (_savedEventsState is SavedEventsStateFailed) {
                              /// Lonely Panda with an inspirational message.
                              /// Trying to inspire the user to make something happen!
                              return SliverToBoxAdapter(
                                child: Column(
                                  children: [
                                    cVerticalMarginSmall(context),
                                    Image(
                                      image: AssetImage(
                                        'images/lonely_panda.png',
                                      ),
                                      height: _realHeight * .35,
                                      width: screenWidth * .35,
                                    ),
                                    Text(
                                      'Stop hibernating, make something happen!',
                                      style: TextStyle(color: cWhite70, fontSize: 16.0),
                                    ),
                                    cVerticalMarginSmall(context),
                                    TextButton(
                                      child: Text(
                                        'RELOAD',
                                        style: TextStyle(color: Colors.blueAccent, fontSize: 16.0),
                                      ),
                                      onPressed: () {
                                        BlocProvider.of<SavedEventsBloc>(refreshIndicatorContext).add(SavedEventsEventReload());
                                        BlocProvider.of<UploadEventBloc>(refreshIndicatorContext).add(UploadEventReset());
                                      },
                                    ),
                                  ],
                                ),
                              );
                            } // if

                            // Don't show the sliver list, since events are still being fetched,
                            // Also don't know if the event fetch failed, so can't return the cactus dog image.
                            else if (_savedEventsState is SavedEventsStateFetching) {
                              return SliverToBoxAdapter(child: Container(color: Color.fromRGBO(61, 61, 61, 1.0)));
                            } // else if

                            // Don't show anything, since a reload failure should immediately be followed by an event fetch failure
                            else if (_savedEventsState is SavedEventsStateReloadFailed) {
                              return SliverToBoxAdapter(child: Container(color: Color.fromRGBO(61, 61, 61, 1.0)));
                            } // else if

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
              );
            })
          ],
        ));
  } // build

  @override
  bool get wantKeepAlive => true;

  @override
  void dispose() {
    this._scrollController.dispose();
    super.dispose();
  } // dispose
} // _PinnedEventsScreenState
