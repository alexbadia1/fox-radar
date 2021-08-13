import 'dart:async';
import 'package:flutter/material.dart';
import 'package:communitytabs/logic/logic.dart';
import 'package:communitytabs/presentation/presentation.dart';
import 'package:database_repository/database_repository.dart';
import 'package:authentication_repository/authentication_repository.dart';

/*
category_screen_body_list.dart

  The specific list view in each Page View in the Category Screen
  Each List View is able to be refreshed and lazily retrieve events of a specified category.
 */
class SingleCategoryView extends StatefulWidget {
  const SingleCategoryView({Key key}) : super(key: key);
  @override
  _SingleCategoryViewState createState() => _SingleCategoryViewState();
} // SingleCategoryView

class _SingleCategoryViewState extends State<SingleCategoryView> {
  Completer _refreshCompleter;
  ScrollController _listViewController;

  @override
  void initState() {
    super.initState();
    _refreshCompleter = Completer();
    _listViewController = ScrollController();

    /// List View Controller to lazily fetch more events
    _listViewController.addListener(() {
      CategoryEventsState _currentState =
          BlocProvider.of<CategoryEventsBloc>(context).state;

      /// User is at bottom, fetch more events
      if (_listViewController.position.pixels >=
          _listViewController.position.maxScrollExtent / 3) {
        /// Check the current state to prevent spamming bloc with fetch events
        if (_currentState is CategoryEventsStateSuccess) {
          if (!_currentState.maxEvents) {
            /// Add a fetch event to the CategoryEventsBloc
            BlocProvider.of<CategoryEventsBloc>(context)
                .add(CategoryEventsEventFetch());
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
      color: Color.fromRGBO(24, 24, 24, 1.0),
      child: Builder(builder: (context) {
        final CategoryEventsState _categoryEventsState =
            context.watch<CategoryEventsBloc>().state;

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
        } // if

        if (!(_categoryEventsState is CategoryEventsStateFetching)) {
          // To stop the Refresh Indicator's loading widget,
          // complete [complete()] the completer [_refreshCompleter].
          this._refreshCompleter.complete();

          // Instantiate a new Completer to allow for a new reload event.
          this._refreshCompleter = Completer();
        } // if

        return Scrollbar(
          radius: Radius.circular(50.0),
          child: RefreshIndicator(
            color: cWhite70,
            displacement: 15,
            backgroundColor: Colors.transparent,
            onRefresh: () async {
              BlocProvider.of<CategoryEventsBloc>(context)
                  .add(CategoryEventsEventReload());
              final _future = await _refreshCompleter.future;
              return _future;
            },
            child: Builder(builder: (context) {
              final CategoryEventsState _nestedCategoryEventsState =
                  context.watch<CategoryEventsBloc>().state;

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
                      final _categoryEVent = _nestedCategoryEventsState.eventModels
                            .elementAt(index);
                      return EventCard(
                        key: ObjectKey(_categoryEVent),
                        newSearchResult: _categoryEVent,
                        onEventCardVertMoreCallback: (imageBytes) {
                          return showModalBottomSheet(
                            context: listContext,
                            builder: (modalSheetContext) {
                              /// Pass the current AccountEventsBloc.
                              ///
                              /// Bottom Modal Sheet is built within
                              /// its own context, that doesn't have
                              /// access to the current widget's context.
                              return MultiBlocProvider(
                                providers: [
                                  BlocProvider<PinEventCubit>(
                                    create: (context) => PinEventCubit.instance(
                                      db: RepositoryProvider.of<
                                          DatabaseRepository>(context),
                                      pinnedEvents:
                                          BlocProvider.of<PinnedEventsBloc>(
                                                  context)
                                              .pinnedEvents,
                                      eventId: _categoryEVent.eventId,
                                      uid: RepositoryProvider.of<
                                              AuthenticationRepository>(context)
                                          .getUserModel()
                                          .userID,
                                    ),
                                  ),
                                ],
                                child: Builder(builder: (modalSheetContext) {
                                  final PinEventState pinnedState =
                                      modalSheetContext
                                          .watch<PinEventCubit>()
                                          .state;

                                  if (pinnedState is PinEventStateUnpinned) {
                                    return ModalActionMenu(
                                      actions: [
                                        ModalActionMenuButton(
                                          icon: Icons.edit,
                                          description: "Pin",
                                          color: Colors.blueAccent,
                                          onPressed: () {
                                            BlocProvider.of<PinEventCubit>(
                                                    context)
                                                .pinEvent(_categoryEVent
                                                    .eventId);
                                            Navigator.pop(context);
                                          },
                                        ),
                                      ],
                                      cancel: true,
                                    );
                                  } // if

                                  return ModalActionMenu(
                                    actions: [
                                      ModalActionMenuButton(
                                        icon: Icons.delete,
                                        description: "Unpin",
                                        color: Colors.redAccent,
                                        onPressed: () {
                                          BlocProvider.of<PinEventCubit>(
                                                  context)
                                              .unpinEvent(_categoryEVent
                                                  .eventId);
                                          Navigator.pop(context);
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
                    } // if
                    else {
                      return Builder(builder: (context) {
                        final CategoryEventsState
                            _nestedNestedCategoryEventsState =
                            context.watch<CategoryEventsBloc>().state;
                        if (_nestedNestedCategoryEventsState
                            is CategoryEventsStateSuccess) {
                          if (!_nestedNestedCategoryEventsState.maxEvents) {
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
                );
              } // if

              /// Kindly tell the user there are no events
              else if (_nestedCategoryEventsState
                  is CategoryEventsStateFailed) {
                return Container(
                  width: double.infinity,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      cVerticalMarginSmall(context),
                      Image(
                        image: AssetImage(
                          'images/cactus_bulldog.png',
                        ),
                        height: _realHeight * .35,
                        width: _realScreenWidth * .35,
                      ),
                      Text(
                        'No events, but we found this on our servers...',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(color: cWhite70),
                      ),
                      cVerticalMarginSmall(context),
                      Builder(
                        builder: (retryContext) {
                          final CategoryEventsState _state =
                              retryContext.watch<CategoryEventsBloc>().state;

                          if (_state is CategoryEventsStateFetching) {
                            return CustomCircularProgressIndicator();
                          } // if

                          return TextButton(
                            child: Text(
                              'RETRY',
                              style: TextStyle(
                                  color: Colors.blueAccent, fontSize: 16.0),
                            ),
                            onPressed: () {
                              BlocProvider.of<CategoryEventsBloc>(context)
                                  .add(CategoryEventsEventReload());
                            },
                          );
                        },
                      )
                    ],
                  ),
                );
              } // else if

              /// CategoryEventsStateFetching is unreachable, and there are no other reachable states.
              else {
                return Center(child: Text('Something went wrong!'));
              } // else
            }),
          ),
        );
      }),
    );
  } // build

  @override
  void dispose() {
    this._listViewController.dispose();
    super.dispose();
  } //dispose
} // _SingleCategoryViewState
