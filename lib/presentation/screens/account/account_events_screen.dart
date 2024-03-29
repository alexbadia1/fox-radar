import 'dart:async';
import 'package:flutter/material.dart';
import 'package:fox_radar/logic/logic.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:fox_radar/presentation/presentation.dart';
import 'package:database_repository/database_repository.dart';

class AccountEventsScreen extends StatefulWidget {
  @override
  _AccountEventsScreenState createState() => _AccountEventsScreenState();
}

class _AccountEventsScreenState extends State<AccountEventsScreen> with AutomaticKeepAliveClientMixin {
  late Completer<void> _refreshCompleter;
  late ScrollController _scrollController;
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
      AccountEventsState _currentState = BlocProvider.of<AccountEventsBloc>(context).state;

      // User is about 2/3 to the bottom of the list, fetch more
      // events, in an effort to load events before they get to the bottom.
      if (this._scrollController.position.pixels >= this._scrollController.position.maxScrollExtent / 3) {
        // Check the current state to prevent spamming bloc with fetch events
        if (_currentState is AccountEventsStateSuccess) {
          if (!_currentState.maxEvents) {
            // Add a fetch event to the AccountsEventsBloc
            BlocProvider.of<AccountEventsBloc>(context).add(AccountEventsEventFetch());
          }
        }
      }
    });
  }

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
            title: "My Events",
            icon: Icons.chevron_left,
            onIconPressed: () {
              BlocProvider.of<AccountPageViewCubit>(context).animateToPinnedEventsPage();
            },

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
                    showModalBottomSheet(
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
            /// Name: CircularProgressIndicator
            ///
            /// Description: Show a loading widget while retrieving users' events.
            final _accountEventsBlocState = loadingWidgetContext.watch<AccountEventsBloc>().state;

            if (_accountEventsBlocState is AccountEventsStateFetching) {
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

            /// Name: Refresh indicator
            ///
            /// Description: Adds a fetch event to the AccountEventsBloc
            ///              then waits for a "Completer" to complete.
            ///
            ///              When the "Completer" is complete, the
            ///              RefreshIndicator's loading widget stops.
            return SliverFillRemaining(
              child: Builder(builder: (BuildContext refreshIndicatorContext) {
                final _accountEventsBlocState = refreshIndicatorContext.watch<AccountEventsBloc>().state;

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
                    BlocProvider.of<AccountEventsBloc>(refreshIndicatorContext).add(AccountEventsEventReload());
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
                        /// List of users' events implemented with SliverList.
                        ///
                        /// Sliver List receives data from the AccountEventsBloc
                        /// and builds "Event Cards" for each event, with
                        /// the last widget being a loading widget if necessary.
                        Builder(builder: (userEventsContext) {
                          final _accountEventsState = userEventsContext.watch<AccountEventsBloc>().state;

                          // Show a paginated list view of events created by the account
                          if (_accountEventsState is AccountEventsStateSuccess) {
                            return SliverList(
                              delegate: SliverChildBuilderDelegate(
                                (BuildContext sliverListContext, int index) {
                                  /// Not at the bottom...
                                  ///
                                  /// Show each search result in an [EventCard] widget.
                                  /// When clicking on the card, the full event is retrieved.
                                  if (index < _accountEventsState.eventModels.length) {
                                    final searchResult = _accountEventsState.eventModels.elementAt(index);
                                    return Slidable(
                                      enabled: true,
                                      direction: Axis.horizontal,
                                      actionPane: SlidableStrechActionPane(),
                                      actionExtentRatio: 0.3,
                                      child: EventCard(
                                        key: ObjectKey(searchResult),
                                        newSearchResult: searchResult,
                                        onEventCardVertMoreCallback: (imageBytes) {
                                          // Show a modal bottom sheet with
                                          // options to edit or delete an event.
                                          showModalBottomSheet(
                                            context: sliverListContext,
                                            builder: (modalSheetContext) {
                                              /// Pass the current AccountEventsBloc.
                                              ///
                                              /// Bottom Modal Sheet is built within
                                              /// its own context, that doesn't have
                                              /// access to the current widget's context.
                                              return MultiBlocProvider(
                                                providers: [
                                                  BlocProvider.value(value: BlocProvider.of<AccountEventsBloc>(sliverListContext)),
                                                  BlocProvider.value(value: BlocProvider.of<PinnedEventsBloc>(sliverListContext)),
                                                  BlocProvider.value(value: BlocProvider.of<UploadEventBloc>(sliverListContext)),
                                                  BlocProvider(
                                                    create: (fetchEventCubitContext) => FetchFullEventCubit(
                                                      db: RepositoryProvider.of<DatabaseRepository>(sliverListContext),
                                                    ),
                                                  ),
                                                ],
                                                child: Builder(builder: (modalSheetContext) {
                                                  BlocProvider.of<FetchFullEventCubit>(modalSheetContext)
                                                      .fetchEvent(documentId: searchResult.eventId);
                                                  return AccountModalBottomSheet(
                                                    listViewIndex: index,
                                                    searchResultModel: _accountEventsState.eventModels.elementAt(index),
                                                    onEdit: (EventModel fullEvent) {
                                                      // Set image bytes to the event model, before passing on
                                                      fullEvent.imageBytes = imageBytes;
                                                      final _uploadState = BlocProvider.of<UploadEventBloc>(context).state;

                                                      if (_uploadState is UploadEventStateUploading && !_uploadState.complete) {
                                                        showModalBottomSheet<void>(
                                                          context: context,
                                                          builder: (BuildContext context) {
                                                            return BlocProvider.value(
                                                              value: BlocProvider.of<UploadEventBloc>(context),
                                                              child: ModalConfirmation(
                                                                prompt:
                                                                    'An event is already currently being upload. Please wait for, or cancel, that event!',
                                                                cancelText: 'CANCEL CURRENT UPLOAD',
                                                                cancelColor: Colors.redAccent,
                                                                onCancel: () {
                                                                  showModalBottomSheet(
                                                                      context: context,
                                                                      builder: (context) {
                                                                        return ModalConfirmation(
                                                                          cancelText: 'CANCEL CURRENT UPLOAD',
                                                                          cancelColor: Colors.redAccent,
                                                                          onCancel: () {
                                                                            BlocProvider.of<UploadEventBloc>(context).add(UploadEventCancel());

                                                                            Navigator.popUntil(context, (route) => route.isFirst);
                                                                          },
                                                                          confirmText: "NEVERMIND",
                                                                          confirmColor: Colors.blueAccent,
                                                                          onConfirm: () => Navigator.popUntil(context, (route) => route.isFirst),
                                                                        );
                                                                      });
                                                                },
                                                                confirmText: 'I CAN WAIT',
                                                                confirmColor: Colors.blueAccent,
                                                                onConfirm: () => Navigator.pop(context),
                                                              ),
                                                            );
                                                          },
                                                        );
                                                      } // if

                                                      else {
                                                        if (_uploadState is UploadEventStateUploading && _uploadState.complete) {
                                                          // Reset the upload event bloc
                                                          BlocProvider.of<UploadEventBloc>(context).add(UploadEventReset());
                                                        } // if
                                                        showModalBottomSheet(
                                                          isScrollControlled: true,
                                                          enableDrag: false,
                                                          context: context,
                                                          builder: (bottomModalSheetContext) {
                                                            return MultiBlocProvider(
                                                              providers: [
                                                                BlocProvider.value(
                                                                  value: BlocProvider.of<UploadEventBloc>(context),
                                                                ),
                                                                BlocProvider.value(
                                                                  value: BlocProvider.of<AccountPageViewCubit>(context),
                                                                ),
                                                              ],
                                                              child: CreateEventScreen(initialEventModel: fullEvent),
                                                            );
                                                          }, // builder
                                                        );
                                                      }
                                                    },
                                                  );
                                                }),
                                              );
                                            }, // builder
                                          );
                                        },
                                      ),
                                      secondaryActions: <Widget>[
                                        Builder(builder: (context) {
                                          return GestureDetector(
                                            onTap: () {
                                              Slidable.of(context)?.close();

                                              // Confirm Delete
                                              showModalBottomSheet(
                                                  // Make sure user is focused on task at hand only
                                                  isDismissible: false,
                                                  context: context,
                                                  builder: (confirmDeleteButtonContext) {
                                                    return BlocProvider.value(
                                                      value: BlocProvider.of<AccountEventsBloc>(context),
                                                      child: ConfirmDelete(searchResultModel: searchResult, listViewIndex: index),
                                                    );
                                                  });
                                            },
                                            child: Container(
                                              color: Colors.red,
                                              child: Center(
                                                child: Column(
                                                  mainAxisSize: MainAxisSize.min,
                                                  children: [
                                                    Icon(
                                                      Icons.delete,
                                                      key: UniqueKey(),
                                                      color: Colors.white,
                                                    ),
                                                    Text(
                                                      "Delete",
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
                                        final AccountEventsState _accountEventsState = bottomListContext.watch<AccountEventsBloc>().state;

                                        /// Only return a loading widget if there are
                                        /// are more events to retrieve. Otherwise
                                        /// show an empty container as a bottom margin.
                                        if (_accountEventsState is AccountEventsStateSuccess) {
                                          return !_accountEventsState.maxEvents ? BottomLoadingWidget() : Container();
                                        } // if
                                        else {
                                          return Container();
                                        } // else
                                      },
                                    );
                                  } // else
                                },
                                addAutomaticKeepAlives: true,
                                childCount: _accountEventsState.eventModels.length + 1,
                              ),
                            );
                          } // if

                          /// The account has no events associated with it.
                          ///
                          /// "Expired" events will be deleted by the database.
                          /// An event is expired when "TBD"...
                          else if (_accountEventsState is AccountEventsStateFailed) {
                            /// Lonely Panda with an inspirational message.
                            /// Trying to inspire the user to make something happen!
                            return SliverToBoxAdapter(
                              child: Column(
                                children: [
                                  cVerticalMarginSmall(context),
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
                                      BlocProvider.of<AccountEventsBloc>(refreshIndicatorContext).add(AccountEventsEventReload());
                                    },
                                  ),
                                ],
                              ),
                            );
                          } // if

                          // Don't show the sliver list, since events are still being fetched,
                          // Also don't know if the event fetch failed, so can't return the cactus dog image.
                          else if (_accountEventsState is AccountEventsStateFetching) {
                            return SliverToBoxAdapter(child: Container(color: Color.fromRGBO(61, 61, 61, 1.0)));
                          } // else if

                          // Don't show anything, since a reload failure should immediately be followed by an event fetch failure
                          else if (_accountEventsState is AccountEventsStateReloadFailed) {
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
                          }
                        }),
                      ],
                    ),
                  ),
                );
              }),
            );
          }),
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;

  @override
  void dispose() {
    this._scrollController.dispose();
    super.dispose();
  }
}
