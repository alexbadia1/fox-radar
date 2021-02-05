import 'dart:async';
import 'package:communitytabs/constants/marist_color_scheme.dart';
import 'package:communitytabs/logic/blocs/blocs.dart';
import 'package:communitytabs/logic/cubits/cubits.dart';
import 'package:communitytabs/presentation/components/components.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
    final screenHeight = MediaQuery.of(context).size.height;
    final screenPaddingBottom = MediaQuery.of(context).padding.bottom;
    final screenInsetsBottom = MediaQuery.of(context).viewInsets.bottom;
    final screenPaddingTop = MediaQuery.of(context).padding.top;

    final _realHeight = screenHeight -
        screenPaddingTop -
        screenPaddingBottom +
        screenInsetsBottom;

    /// The Category Events Bloc is generated and passed directly into the list view
    /// The Category Events Bloc will be closed in the Widget above: Category Screen Body
    return Container(
      color: Color.fromRGBO(33, 33, 33, 1),
      child: Builder(builder: (context) {
        final CategoryEventsState _categoryEventsState =
            context.watch<CategoryEventsBloc>().state;


          /// Completer will complete when a new Category Events Bloc state is emitted.
          /// Refresh indicator will stay loading as long as the Completer is not completed.
          /// Once the Completer is completed, the refresh indicator will stop showing loading
          /// and a new instance of the Completer is created for the user next reload.
          if (_categoryEventsState is CategoryEventsStateSuccess) {
            _refreshCompleter.complete();
            _refreshCompleter = Completer();
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
                    controller: _listViewController,
                    addAutomaticKeepAlives: true,
                    itemCount:
                        _nestedCategoryEventsState.eventModels.length + 1,
                    itemBuilder: (BuildContext context, int index) {
                      if (index <
                          _nestedCategoryEventsState.eventModels.length) {
                        return EventCard(
                            newSearchResult: _nestedCategoryEventsState
                                .eventModels
                                .elementAt(index));
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
                  return Center(child: Text('Looks Like Nothing\'s Going On?'));
                } // if

                /// Something went wrong
                else {
                  return Center(child: Text('Something Went Wrong Oops!'));
                } // else
              }),
            ),
          );
      }),
    );
  } // build
@override
  void dispose() {
    _listViewController.dispose();
    super.dispose();
  }//dispose
} // _SingleCategoryViewState
