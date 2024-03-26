import 'dart:async';
import 'package:flutter/material.dart';
import 'package:fox_radar/logic/logic.dart';
import 'package:fox_radar/presentation/presentation.dart';

/*
category_screen_body_list.dart

  The specific list view in each Page View in the Category Screen
  Each List View is able to be refreshed and lazily retrieve events of a specified category.
 */
class SingleCategoryView extends StatefulWidget {
  const SingleCategoryView({Key? key}) : super(key: key);
  @override
  _SingleCategoryViewState createState() => _SingleCategoryViewState();
}

class _SingleCategoryViewState extends State<SingleCategoryView> {
  late Completer _refreshCompleter;
  late ScrollController _listViewController;

  @override
  void initState() {
    super.initState();
    _refreshCompleter = Completer();
    _listViewController = ScrollController();

    /// List View Controller to lazily fetch more events
    _listViewController.addListener(() {
      CategoryEventsState _currentState = BlocProvider.of<CategoryEventsBloc>(context).state;

      /// User is at bottom, fetch more events
      if (_listViewController.position.pixels >= _listViewController.position.maxScrollExtent / 3) {
        /// Check the current state to prevent spamming bloc with fetch events
        if (_currentState is CategoryEventsStateSuccess) {
          if (!_currentState.maxEvents) {
            /// Add a fetch event to the CategoryEventsBloc
            BlocProvider.of<CategoryEventsBloc>(context).add(CategoryEventsEventFetch());
          } // if
        } // if
      } // else-if
    });
  } // initState

  @override
  Widget build(BuildContext context) {
    final _realScreenWidth = MediaQuery.of(context).size.width;
    final _realHeight = MediaQuery.of(context).size.height -
        MediaQuery.of(context).padding.top -
        MediaQuery.of(context).padding.bottom +
        MediaQuery.of(context).viewInsets.bottom;

    /// The Category Events Bloc is generated and passed directly into the list view
    /// The Category Events Bloc will be closed in the Widget above: Category Screen Body
    return Container(
      color: cBackground,
      child: Builder(builder: (context) {
        final CategoryEventsState _categoryEventsState = context.watch<CategoryEventsBloc>().state;

        if (_categoryEventsState is CategoryEventsStateFetching) {
          return Container(
            width: double.infinity,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: _realHeight * .35),
                CustomCircularProgressIndicator(),
              ],
            ),
          );
        }

        if (!(_categoryEventsState is CategoryEventsStateFetching)) {
          // To stop the Refresh Indicator's loading widget,
          // complete [complete()] the completer [_refreshCompleter].
          this._refreshCompleter.complete();

          // Instantiate a new Completer to allow for a new reload event.
          this._refreshCompleter = Completer();
        }

        return Scrollbar(
          radius: Radius.circular(50.0),
          child: RefreshIndicator(
            color: cWhite70,
            displacement: 15,
            backgroundColor: Colors.transparent,
            onRefresh: () async {
              BlocProvider.of<CategoryEventsBloc>(context).add(CategoryEventsEventReload());
              final _future = await _refreshCompleter.future;
              return _future;
            },
            child: Builder(builder: (context) {
              final CategoryEventsState _nestedCategoryEventsState = context.watch<CategoryEventsBloc>().state;

              /// List View Builder dynamically shows all events returned by the category events bloc
              if (_nestedCategoryEventsState is CategoryEventsStateSuccess) {
                return ListView.builder(
                  /// List must always be scrollable to allow for the refresh indicator
                  physics: const AlwaysScrollableScrollPhysics(),
                  controller: this._listViewController,
                  addAutomaticKeepAlives: true,
                  itemCount: _nestedCategoryEventsState.eventModels.length + 1,
                  itemBuilder: (BuildContext listContext, int index) {
                    if (index < _nestedCategoryEventsState.eventModels.length) {
                      final _categoryEvent = _nestedCategoryEventsState.eventModels.elementAt(index);
                      return EventCard(
                        key: ObjectKey(_categoryEvent),
                        newSearchResult: _categoryEvent,
                        onEventCardVertMoreCallback: (imageBytes) {
                          return showModalBottomSheet(
                            context: listContext,
                            builder: (modalSheetContext) {
                              /// Pass the current AccountEventsBloc.
                              ///
                              /// Bottom Modal Sheet is built within
                              /// its own context, that doesn't have
                              /// access to the current widget's context.
                              return BlocProvider<PinnedEventsBloc>.value(
                                value: BlocProvider.of<PinnedEventsBloc>(modalSheetContext),
                                child: Builder(builder: (modalSheetContext) {
                                  // Not pinned, so let user pin the bloc
                                  if (!BlocProvider.of<PinnedEventsBloc>(context).pinnedEvents!.contains(_categoryEvent.eventId)) {
                                    return ModalActionMenu(
                                      actions: [
                                        ModalActionMenuButton(
                                          icon: Icons.edit,
                                          description: "Pin",
                                          color: Colors.blueAccent,
                                          onPressed: () {
                                            BlocProvider.of<PinnedEventsBloc>(modalSheetContext).add(PinnedEventsEventPin(_categoryEvent.eventId!));
                                            Navigator.pop(modalSheetContext);
                                          },
                                        ),
                                      ],
                                      cancel: true,
                                    );
                                  }

                                  // Already pinned, so let user pin the bloc
                                  return ModalActionMenu(
                                    actions: [
                                      ModalActionMenuButton(
                                        icon: Icons.undo_rounded,
                                        description: "Unpin",
                                        color: Colors.redAccent,
                                        onPressed: () {
                                          BlocProvider.of<PinnedEventsBloc>(modalSheetContext).add(PinnedEventsEventUnpin(_categoryEvent.eventId!));
                                          Navigator.pop(modalSheetContext);
                                        },
                                      )
                                    ],
                                    cancel: true,
                                  );
                                }),
                              );
                            }, // builder
                          );
                        },
                      );
                    } else {
                      return Builder(builder: (context) {
                        final CategoryEventsState _nestedNestedCategoryEventsState = context.watch<CategoryEventsBloc>().state;
                        if (_nestedNestedCategoryEventsState is CategoryEventsStateSuccess) {
                          if (!_nestedNestedCategoryEventsState.maxEvents) {
                            return BottomLoadingWidget();
                          } else {
                            return Container();
                          }
                        }
                        else {
                          return Container();
                        }
                      });
                    }
                  },
                );
              }

              /// Kindly tell the user there are no events
              else if (_nestedCategoryEventsState is CategoryEventsStateFailed) {
                return Container(
                  width: double.infinity,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      cVerticalMarginSmall(context),
                      cVerticalMarginSmall(context),
                      cVerticalMarginSmall(context),
                      LonelyPandaImage(),
                      Builder(
                        builder: (BuildContext context) {
                          final _connection = context.watch<DeviceNetworkBloc>().state;

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
                            'No events, make something happen!',
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(color: cWhite70),
                          );
                        },
                      ),
                      cVerticalMarginSmall(context),
                      Builder(
                        builder: (retryContext) {
                          final CategoryEventsState _state = retryContext.watch<CategoryEventsBloc>().state;

                          if (_state is CategoryEventsStateFetching) {
                            return CustomCircularProgressIndicator();
                          }

                          return TextButton(
                            child: Text(
                              'RETRY',
                              style: TextStyle(color: Colors.blueAccent, fontSize: 16.0),
                            ),
                            onPressed: () {
                              BlocProvider.of<CategoryEventsBloc>(context).add(CategoryEventsEventReload());
                            },
                          );
                        },
                      )
                    ],
                  ),
                );
              }

              /// CategoryEventsStateFetching is unreachable, and there are no other reachable states.
              else {
                return Center(child: Text('Something went wrong!'));
              }
            }),
          ),
        );
      }),
    );
  }

  @override
  void dispose() {
    this._listViewController.dispose();
    super.dispose();
  }
}
