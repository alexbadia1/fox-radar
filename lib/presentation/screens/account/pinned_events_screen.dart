import 'dart:async';
import 'package:flutter/material.dart';
import 'package:communitytabs/logic/logic.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
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
      PinnedEventsState _currentState = BlocProvider.of<PinnedEventsBloc>(context).state;

      // User is about 2/3 to the bottom of the list, fetch more
      // events, in an effort to load events before they get to the bottom.
      if (this._scrollController.position.pixels >= this._scrollController.position.maxScrollExtent / 3) {
        // Check the current state to prevent spamming bloc with fetch events
        if (_currentState is PinnedEventsStateSuccess) {
          if (!_currentState.maxEvents) {
            // Add a fetch event to the SavedEventsBloc
            BlocProvider.of<PinnedEventsBloc>(context).add(PinnedEventsEventFetch());
          } // if
        } // if
      } // else-if
    });
  } // initState

  @override
  Widget build(BuildContext context) {
    super.build(context); // AutomaticKeepAliveClientMixin require this.
    final _realHeight = MediaQuery.of(context).size.height -
        MediaQuery.of(context).padding.top -
        MediaQuery.of(context).padding.bottom +
        MediaQuery.of(context).viewInsets.bottom;

    return Scaffold(
        key: this._scaffoldKey,
        backgroundColor: cBackground,
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
                      return showModalBottomSheet(
                        context: context,
                        enableDrag: false,
                        isScrollControlled: true,
                        builder: (context) {
                          return MultiBlocProvider(
                            providers: [
                              BlocProvider<LoginBloc>.value(value: BlocProvider.of<LoginBloc>(accountDrawerButtonContext)),
                              BlocProvider<UpdateProfileBloc>.value(value: BlocProvider.of<UpdateProfileBloc>(accountDrawerButtonContext)),
                            ],
                            child: AccountDrawerContents(),
                          );
                        },
                      );
                    },
                  );
                },
              ),
            ),
            Builder(builder: (loadingWidgetContext) {
              final _accountSavedEventsBlocState = loadingWidgetContext.watch<PinnedEventsBloc>().state;

              if (_accountSavedEventsBlocState is PinnedEventsStateFetching) {
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
                  final _savedEventState = refreshIndicatorContext.watch<PinnedEventsBloc>().state;
                  // SavedEventsBloc must either be [SavedEventsStateSuccess]
                  // or [SavedEventsStateFailed] (Not [SavedEventsStateFetching])
                  if (!(_savedEventState is PinnedEventsStateFetching)) {
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
                      BlocProvider.of<PinnedEventsBloc>(refreshIndicatorContext).add(PinnedEventsEventReload());
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
                            final PinnedEventsState _savedEventsState = headerContext.watch<PinnedEventsBloc>().state;

                            if (_savedEventsState is PinnedEventsStateFetching) {
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
                            final PinnedEventsState _savedEventsState = headerContext.watch<PinnedEventsBloc>().state;

                            if (_savedEventsState is PinnedEventsStateFetching) {
                              return SliverToBoxAdapter(child: Container());
                            } // if

                            return SliverListHeader(text: 'Pinned Events', trailing: DropdownEventsFilter());
                          }),

                          /// List of users' events implemented with SliverList.
                          ///
                          /// Sliver List receives data from the SavedEventsBloc
                          /// and builds "Event Cards" for each event, with
                          /// the last widget being a loading widget if necessary.
                          Builder(builder: (pinnedEventsContext) {
                            final _savedEventsState = pinnedEventsContext.watch<PinnedEventsBloc>().state;

                            // Show a paginated list view of events pinned by the account
                            if (_savedEventsState is PinnedEventsStateSuccess) {
                              return SliverList(
                                delegate: SliverChildBuilderDelegate(
                                  (BuildContext sliverListContext, int index) {
                                    /// Not at the bottom...
                                    ///
                                    /// Show each search result in an [EventCard] widget.
                                    /// When clicking on the card, the full event is retrieved.
                                    if (index < _savedEventsState.eventModels.length) {
                                      final _pinnedEvent = _savedEventsState.eventModels.elementAt(index);
                                      return Slidable(
                                        enabled: true,
                                        direction: Axis.horizontal,
                                        actionPane: SlidableStrechActionPane(),
                                        actionExtentRatio: 0.3,
                                        child: EventCard(
                                          key: ObjectKey(_pinnedEvent),
                                          newSearchResult: _pinnedEvent,
                                          onEventCardVertMoreCallback: (imageBytes) {
                                            // Show a modal bottom sheet with
                                            // options to edit or delete an event.
                                            return showModalBottomSheet(
                                              context: sliverListContext,
                                              builder: (modalSheetContext) {
                                                /// Pass the current SavedEventsBloc.
                                                ///
                                                /// Bottom Modal Sheet is built within
                                                /// its own context, that doesn't have
                                                /// access to the current widget's context.
                                                return BlocProvider<PinnedEventsBloc>.value(
                                                  value: BlocProvider.of<PinnedEventsBloc>(context),
                                                  child: Builder(
                                                    builder: (modalSheetContext) {
                                                      // Events shown on rhe screen should already be unpinned
                                                      return ModalActionMenu(
                                                        actions: [
                                                          ModalActionMenuButton(
                                                            icon: Icons.undo_rounded,
                                                            description: "Unpin Event",
                                                            color: Colors.redAccent,
                                                            onPressed: () {
                                                              // Remove from local list
                                                              BlocProvider.of<PinnedEventsBloc>(modalSheetContext)
                                                                  .add(PinnedEventsEventUnpin(_pinnedEvent.eventId));
                                                              Navigator.pop(modalSheetContext);
                                                            },
                                                          ),
                                                        ],
                                                        cancel: true,
                                                      );
                                                    },
                                                  ),
                                                );
                                              }, // builder
                                            );
                                          },
                                        ),
                                        secondaryActions: <Widget>[
                                          Builder(builder: (context) {
                                            return GestureDetector(
                                              onTap: () {
                                                Slidable.of(context).close();
                                                // Remove from local list
                                                BlocProvider.of<PinnedEventsBloc>(context).add(PinnedEventsEventUnpin(_pinnedEvent.eventId));
                                              },
                                              child: Container(
                                                color: Colors.red,
                                                child: Center(
                                                  child: Column(
                                                    mainAxisSize: MainAxisSize.min,
                                                    children: [
                                                      Icon(
                                                        Icons.undo_rounded,
                                                        key: UniqueKey(),
                                                        color: Colors.white,
                                                      ),
                                                      Text(
                                                        "Unpin",
                                                        style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 12,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            );
                                          })
                                        ],
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
                                          final _state = pinnedEventsContext.watch<PinnedEventsBloc>().state;

                                          /// Only return a loading widget if there are
                                          /// are more events to retrieve. Otherwise
                                          /// show an empty container as a bottom margin.
                                          if (_state is PinnedEventsStateSuccess) {
                                            return !_state.maxEvents ? BottomLoadingWidget() : Container();
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
                            else if (_savedEventsState is PinnedEventsStateFailed) {
                              /// Lonely Panda with an inspirational message.
                              /// Trying to inspire the user to make something happen!
                              return SliverToBoxAdapter(
                                child: Column(
                                  children: [
                                    cVerticalMarginSmall(context),
                                    cVerticalMarginSmall(context),
                                    LonelyPandaImage(),
                                    Builder(
                                      builder: (BuildContext context) {
                                        final _connection = loadingWidgetContext.watch<DeviceNetworkBloc>().state;

                                        // Check internet connection first
                                        if (_connection is DeviceNetworkStateNone) {
                                          return Text(
                                            'No Internet Connection',
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(color: cWhite70, fontSize: 16.0),
                                          );
                                        } // if
                                        return Text(
                                          'Stop hibernating, make something happen!',
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(color: cWhite70, fontSize: 16.0),
                                        );
                                      },
                                    ),
                                    cVerticalMarginSmall(context),
                                    TextButton(
                                      child: Text(
                                        'RELOAD',
                                        style: TextStyle(color: Colors.blueAccent, fontSize: 16.0),
                                      ),
                                      onPressed: () {
                                        BlocProvider.of<PinnedEventsBloc>(refreshIndicatorContext).add(PinnedEventsEventReload());
                                        BlocProvider.of<UploadEventBloc>(refreshIndicatorContext).add(UploadEventReset());
                                      },
                                    ),
                                  ],
                                ),
                              );
                            } // if

                            // Don't show the sliver list, since events are still being fetched,
                            // Also don't know if the event fetch failed, so can't return the cactus dog image.
                            else if (_savedEventsState is PinnedEventsStateFetching) {
                              return SliverToBoxAdapter(child: Container(color: Color.fromRGBO(61, 61, 61, 1.0)));
                            } // else if

                            // Don't show anything, since a reload failure should immediately be followed by an event fetch failure
                            else if (_savedEventsState is PinnedEventsStateReloadFailed) {
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
