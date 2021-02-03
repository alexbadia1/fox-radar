import 'package:communitytabs/logic/blocs/blocs.dart';
import 'package:communitytabs/presentation/components/bottom_loading_widget.dart';
import 'package:communitytabs/presentation/components/components.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:communitytabs/constants/marist_color_scheme.dart';
import 'package:communitytabs/presentation/buttons/buttons.dart';
import 'package:database_repository/database_repository.dart';

class HomeScreenBody extends StatefulWidget {
  //TODO: Add add preferences Arguments for Horizontal Lists for preferences.
  @override
  _HomeScreenBodyState createState() => _HomeScreenBodyState();
}

class _HomeScreenBodyState extends State<HomeScreenBody> {
  GlobalKey navigation = new GlobalKey();
  ScrollController _sliverController = new ScrollController();

  @override
  void initState() {
    super.initState();
    // Setup the listener.
    _sliverController.addListener(() {
      double _reloadThreshold =
          MediaQuery.of(context).size.height * .0725 * -1.0;
      SuggestedEventsState _currentState =
          BlocProvider.of<SuggestedEventsBloc>(context).state;

      /// User wiped up to reload
      if (_sliverController.position.outOfRange &&
          _sliverController.position.pixels < _reloadThreshold) {
        print("Show loading widget!");

        /// TODO: Reset the Suggested Events Bloc State back to the initial state
        if (_currentState is SuggestedEventsStateSuccess){
          if (!_currentState.isFetching) {
            BlocProvider.of<SuggestedEventsBloc>(context)
                .add(SuggestedEventsEventReload());
          }// if
        }// if
      } // if

      /// User is at bottom, fetch more events
      else if (_sliverController.position.outOfRange &&
          _sliverController.position.pixels >=
              _sliverController.position.maxScrollExtent) {
        /// Check the current state to prevent spamming bloc with fetch events
        if (_currentState is SuggestedEventsStateSuccess) {
          if (!_currentState.maxEvents) {
            /// Add a fetch event to the SuggestedEventsBloc
            BlocProvider.of<SuggestedEventsBloc>(context)
                .add(SuggestedEventsEventFetch());
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
        physics: BouncingScrollPhysics(),
        controller: _sliverController,
        slivers: [
          MaristSliverAppBar(title: 'Marist'),

          /// Builders Allow us to directly access the "anonymous context"
          /// of the "SliverToBoxAdapter" Widget
          Builder(
            builder: (context) {
              /// Re-use this loading widget by changing it's size,
              /// On App start up, the widget is shown covering the whole screen
              /// On Swipe Up To Reload, this widget will be much smaller
              /// [Google: Why Swipe Up To Reload Must Die! Maybe Swipe Up to Search?]
              double _loadingWidgetContainerHeight;
              final SuggestedEventsState _suggestedEventsState =
                  context.watch<SuggestedEventsBloc>().state;

              /// On "App Startup", Make the loading widget take up the whole screen
              if (_suggestedEventsState is SuggestedEventsStateFetching) {
                _loadingWidgetContainerHeight = _realHeight -
                    MediaQuery.of(context).size.height * .0625 -
                    MediaQuery.of(context).size.height * 0.0725;
              } // if

              /// On "Swipe Up To Reload", Make the loading widget much smaller
              if (_suggestedEventsState is SuggestedEventsStateSuccess) {
                if (_suggestedEventsState.isFetching) {
                  _loadingWidgetContainerHeight =
                      MediaQuery.of(context).size.height * .08;
                } // if
                else {
                  return SliverToBoxAdapter(child: SizedBox());
                } // else
              } // if

              return SliverToBoxAdapter(
                child: Container(
                  height: _loadingWidgetContainerHeight,
                  child: Center(
                    child: SizedBox(
                      height: _realHeight * .03,
                      width: screenWidth * .05,
                      child: CircularProgressIndicator(
                        backgroundColor: Colors.transparent,
                        valueColor: AlwaysStoppedAnimation<Color>(cWhite70),
                        strokeWidth: 2.25,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),

          /// A list of buttons that trigger the PageView to go to the next page
          /// in the page view and show the appropriate list views
          Builder(builder: (context) {
            final SuggestedEventsState _suggestedEventsState =
                context.watch<SuggestedEventsBloc>().state;

            /// Don't show the Category Navigation Menu while retrieving events
            if (_suggestedEventsState is SuggestedEventsStateFetching) {
              return SliverToBoxAdapter(
                child: Container(
                  height: 0,
                  color: Color.fromRGBO(61, 61, 61, 1.0),
                ),
              );
            } // if

            /// The Category Navigation Menu is implemented with a SliverGrid wrapped in Sliver Padding.
            /// Currently there are 6 Navigation Widgets, however if more categories are to be added,
            /// make the SliverGrid scroll horizontally.
            return SliverPadding(
              padding: const EdgeInsets.fromLTRB(12.0, 8.0, 12.0, 16.0),
              sliver: SliverGrid.count(
                key: navigation,
                crossAxisCount: 2,
                crossAxisSpacing: MediaQuery.of(context).size.width * .05,
                mainAxisSpacing: MediaQuery.of(context).size.height * .015,
                childAspectRatio: 4,
                children: <Widget>[
                  /// The Navigation Item is a re-usable button
                  /// Arguments:
                  ///   [option]: sets the title of the next PageView
                  ///   [icon]: sets the current icon of the navigation button
                  ///   [nextPage]: determines which page will be shown in the next page view
                  ///   [gradient]: an image that sets the background for the navigation button
                  CategoryNavigationItem(
                      option: 'Arts',
                      icon: Icons.palette,
                      nextPage: '/arts',
                      gradient: "images/soft_red_banner.jpg"),
                  CategoryNavigationItem(
                      option: 'Sports',
                      icon: Icons.flag,
                      nextPage: '/sports',
                      gradient: "images/soft_green_banner.png"),
                  CategoryNavigationItem(
                      option: 'Diversity',
                      icon: Icons.public,
                      nextPage: '/diversity',
                      gradient: "images/fresh_milk_banner.png"),
                  CategoryNavigationItem(
                      option: 'Student',
                      icon: Icons.library_books,
                      nextPage: '/student',
                      gradient: "images/sharp_blue_banner.png"),
                  CategoryNavigationItem(
                      option: 'Food',
                      icon: Icons.local_dining,
                      nextPage: '/food',
                      gradient: "images/soft_yellow_banner.jpg"),
                  CategoryNavigationItem(
                      option: 'Greek',
                      icon: Icons.account_balance,
                      nextPage: '/greek',
                      gradient: "images/everlasting_banner.png"),
                ],
              ),
            );
          }),

          /// TODO: Turn into a re-usable header for later user
          Builder(builder: (context) {
            final SuggestedEventsState _suggestedEventsState =
                context.watch<SuggestedEventsBloc>().state;
            if (_suggestedEventsState is SuggestedEventsStateFetching) {
              return SliverToBoxAdapter(child: Container());
            } // if
            return SliverToBoxAdapter(
              child: Container(
                height: screenHeight * .09,
                alignment: Alignment.centerLeft,
                decoration: BoxDecoration(
                  color: Color.fromRGBO(33, 33, 33, 1.0),
                  border: Border(
                    top: BorderSide(
                      color: Color.fromRGBO(61, 61, 61, 1.0),
                    ),
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: SizedBox(),
                    ),
                    Text(
                      'Suggestions',
                      style: TextStyle(color: cWhite100, fontSize: 16.5),
                    ),
                    Expanded(
                      flex: 20,
                      child: SizedBox(),
                    ),
                  ],
                ),
              ),
            );
          }),

          /// List of events implemented with SliverList.
          /// Sliver List receives data from the SuggestedEventsBloc and builds "Event Cards"
          /// for each event, with the last widget being a loading widget if necessary
          Builder(
            builder: (context) {
              final _suggestedEventsState =
                  context.watch<SuggestedEventsBloc>().state;

              if (_suggestedEventsState is SuggestedEventsStateSuccess) {
                return SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (BuildContext context, int index) {
                      if (index < _suggestedEventsState.eventModels.length) {
                        return EventCard(
                            newEvent: _suggestedEventsState.eventModels
                                .elementAt(index));
                      } // if
                      else {
                        return BottomLoadingWidget();
                      } // else
                    },
                    addAutomaticKeepAlives: true,
                    childCount: _suggestedEventsState.eventModels.length + 1,
                  ),
                );
              } // if

              /// No events
              /// Tell the user kindly...
              else if (_suggestedEventsState is SuggestedEventsStateFailed) {
                return SliverList(
                  delegate: SliverChildListDelegate(
                    [
                      Center(
                          child: Text('Welp, Nothings Going On',
                              style: TextStyle(color: Colors.white)))
                    ],
                  ),
                );
              }

              /// Something went wrong
              else {
                return SliverList(
                  delegate: SliverChildListDelegate(
                    [
                      Center(
                        child: Container(
                          color: Colors.red,
                        ),
                      )
                    ],
                  ),
                );
              } // else
            },
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _sliverController.dispose();
    super.dispose();
  } // dispose
}
