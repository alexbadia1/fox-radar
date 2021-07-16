import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:communitytabs/logic/logic.dart';
import 'package:database_repository/database_repository.dart';
import 'package:communitytabs/presentation/presentation.dart';

/*
category_screen_body.dart

  An abstraction of the multiple category pages.

  Instead of having multiple different files to display the contents of each category
  [Arts, Diversity, Food, Sports, Clubs, Greek, etc]...

  This Widget receives arguments to dynamically display:
    Varying AppBar titles.
    Varying Number of tabs and their names .
    Varying number of PageViews linked to each corresponding tab.
    And different content (provided by a unique instance of the same bloc) in each PageView.
 */

class CategoryBody extends StatelessWidget {
  /// Specifies the title each time this page is called
  final String title;

  /// Specifies the name of each tab from Left to Right. This means the Left-Most Tab's name is
  /// equal to the List's value at the smallest index (typically where, i = 0) and the Right-Most Tab's name is
  /// equal to the List's value at the largest index (typically where, i = list.length - 1).
  final List<String> tabNamesFromLtoR;

  CategoryBody({@required this.title, @required this.tabNamesFromLtoR});

  @override
  Widget build(BuildContext context) {
    /// Temporary lists to allow for the dynamic building of Tabs and PageViews
    List<Widget> _tabs = [];
    List<Widget> _pageView = [];

    /// Dynamically Generating Tabs
    print('Generating Tabs');
    for (int i = 0; i < this.tabNamesFromLtoR.length; ++i) {
      _tabs.add(Tab(text: this.tabNamesFromLtoR[i]));
    } //for

    /// Dynamically Generating PageViews
    /// Each PageView has its own instance of a Category Bloc Provider
    /// that has a uniquely generated key to to ensure each Bloc Provider instance is unique.
    print('Generating Page Views');
    for (int i = 0; i < this.tabNamesFromLtoR.length; ++i) {
      _pageView.add(
          BlocProvider(
            key: UniqueKey(),
            create: (context) => CategoryEventsBloc(
                db: RepositoryProvider.of<DatabaseRepository>(context),
                category: this.tabNamesFromLtoR[i])..add(CategoryEventsEventFetch(),
            ),
            child:SingleCategoryView(),
      ));
    } //for


    ///TODO: Account for only 1 sub-Category. Maybe just use a different special widget
    return SafeArea(
      child: DefaultTabController(
        length: this.tabNamesFromLtoR.length,
        child: Scaffold(
          appBar: PreferredSize(
            preferredSize:
                Size.fromHeight(MediaQuery.of(context).size.height * .15),
            child: AppBar(
              flexibleSpace: Stack(
                children: <Widget>[
//                  Container(
//                    width: double.infinity,
//                    height: double.infinity,
//                    child: Image(
//                      image: ResizeImage(
//                        AssetImage("images/image1.jpg"),
//                        width: int.parse(
//                          MediaQuery.of(context)
//                              .size
//                              .width
//                              .toString()
//                              .replaceAll('.', ''),
//                        ),
//                      ),
//                      fit: BoxFit.fill,
//                    ),
//                  ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: <Color>[
                          cWashedRedFaded,
                          cFullRedFaded,
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              leading: IconButton(
                color: kHavenLightGray,
                splashColor: kActiveHavenLightGray,
                icon: Icon(Icons.chevron_left),
                onPressed: () =>
                    BlocProvider.of<HomePageViewCubit>(context).animateToHomePage(),
              ),
              centerTitle: false,
              title: Text(this.title,
                  style: TextStyle(
                      color: kHavenLightGray, fontWeight: FontWeight.bold)),
              actions: <Widget>[
                // IconButton(
                //   color: kHavenLightGray,
                //   splashColor: kActiveHavenLightGray,
                //   icon: Icon(Icons.search),
                //   onPressed: () async {
                //     await showSearch(context: context, delegate: Search());
                //   },
                // )
              ],
              bottom: TabBar(
                labelStyle: TextStyle(color: kActiveHavenLightGray),
                unselectedLabelColor: kHavenLightGray,
                indicatorSize: TabBarIndicatorSize.tab,
                indicatorColor: kHavenLightGray,
                tabs: _tabs,
              ),
            ),
          ),
          body: TabBarView(children: _pageView),
        ),
      ),
    );
  }
}
