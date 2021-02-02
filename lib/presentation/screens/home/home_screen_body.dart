import 'package:communitytabs/logic/blocs/blocs.dart';
import 'package:communitytabs/presentation/components/components.dart';
import 'package:flutter/cupertino.dart';
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

class _HomeScreenBodyState extends State<HomeScreenBody> with AutomaticKeepAliveClientMixin {
  GlobalKey navigation = new GlobalKey();
  ScrollController _sliverController = new ScrollController();

  @override
  void initState() {
    super.initState();

    // Setup the listener.
    _sliverController.addListener(() {
      if (_sliverController.position.atEdge && _sliverController.position.pixels != 0) {
        // Fetch more data...
        BlocProvider.of<SuggestedEventsBloc>(context).add(SuggestedEventsEventFetch());
        print("Fetching more events...");
      }// if
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final screenPaddingBottom = MediaQuery.of(context).padding.bottom;
    final screenInsetsBottom = MediaQuery.of(context).viewInsets.bottom;
    final screenPaddingTop = MediaQuery.of(context).padding.top;

    final height = screenHeight -
        screenPaddingTop -
        screenPaddingBottom +
        screenInsetsBottom;

    return Container(
      color: Color.fromRGBO(24, 24, 24, 1.0),
      child: CustomScrollView(
        controller: _sliverController,
        slivers: [
          MaristSliverAppBar(title: 'Marist'),
          Builder(builder: (context) {
            final SuggestedEventsState _suggestedEventsState =
                context.watch<SuggestedEventsBloc>().state;
            if (_suggestedEventsState is SuggestedEventsStateFetching) {
              return SliverToBoxAdapter(
                child: Container(
                  height: 0,
                  color: Color.fromRGBO(61, 61, 61, 1.0),
                ),
              );
            } // if
            return SliverPadding(
              padding: const EdgeInsets.fromLTRB(12.0, 8.0, 12.0, 16.0),
              sliver: SliverGrid.count(
                key: navigation,
                crossAxisCount: 2,
                crossAxisSpacing: MediaQuery.of(context).size.width * .05,
                mainAxisSpacing: MediaQuery.of(context).size.height * .015,
                childAspectRatio: 4,
                children: <Widget>[
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
          Builder(builder: (context) {
            final SuggestedEventsState _suggestedEventsState = context.watch<SuggestedEventsBloc>().state;
            if (_suggestedEventsState is SuggestedEventsStateFetching) {
              return SliverToBoxAdapter(
                child: Container(
                  height: height - MediaQuery.of(context).size.height * .0625 - MediaQuery.of(context).size.height * 0.0725,
                  child: Center(
                    child: SizedBox(
                      height: height * .05,
                      width: screenWidth * .08,
                      child: CircularProgressIndicator(
                        backgroundColor: Colors.transparent,
                        valueColor: AlwaysStoppedAnimation<Color>(cWhite70),
                      ),
                    ),
                  ),
                ),
              );
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
          Builder(
            builder: (context) {
              final SuggestedEventsState _suggestedEventsState = context.watch<SuggestedEventsBloc>().state;
              if (_suggestedEventsState is SuggestedEventsStateSuccess) {
                return SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (BuildContext context, int index) {
                      if (index <
                          _suggestedEventsState.eventModels.length - 1) {
                        return EventCard(
                            newEvent: _suggestedEventsState.eventModels
                                .elementAt(index));
                      } // if
                      else {
                        return Column(
                          children: <Widget>[
                            EventCard(
                                newEvent: _suggestedEventsState.eventModels
                                    .elementAt(index)),
                            SizedBox(
                              height: screenHeight * .1,
                              width: double.infinity,
                            ),
                          ],
                        );
                      } // else
                    },
                    addAutomaticKeepAlives: true,
                    childCount: _suggestedEventsState.eventModels.length,
                  ),
                );
              } // if
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
              } else {
                return SliverList(
                  delegate: SliverChildListDelegate(
                    [
                      Center(
                          child: Container(
                        color: Colors.red,
                      ))
                    ],
                  ),
                );
              } // else
            },
          )
        ],
      ),
    );
  }

  @override
  void dispose() {
    _sliverController.dispose();
    super.dispose();
  }// dispose
  @override
  bool get wantKeepAlive => true;
}
