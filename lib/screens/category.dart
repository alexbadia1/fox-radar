import 'package:communitytabs/components/category/singleCategoryList.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:communitytabs/services/search.dart';
import 'package:communitytabs/constants/marist_color_scheme.dart';
import 'package:communitytabs/wrappers.dart';

///CategoryContent Definition:
///  An abstraction of the multiple category pages. Instead of having multiple different files
///  to display the contents of each category [Arts, Diversity, Food, Sports, Clubs, Greek],
///  this Widget receives arguments to dynamically display: different page AppBar titles, a
///  different number of tabs, different names for each tab, a different number of PageViews
///  that are each linked to a corresponding tab, and different content in each PageView.
///
///Used by:
///  SlidingUpPanelBodyWrapper Widget
///
///Uses:
///  SuggestionsWrapper Widget
class CategoryContent extends StatefulWidget {
  ///Specifies the title each time this page is called
  final String title;

  ///Specifies the name of each tab from Left to Right. This means the Left-Most Tab's name is
  ///equal to the List's value at the smallest index (typically where, i = 0) and the Right-Most Tab's name is
  ///equal to the List's value at the largest index (typically where, i = list.length - 1).
  final List<String> tabNamesFromLtoR;

  CategoryContent({@required this.title, @required this.tabNamesFromLtoR});

  @override
  _CategoryContentState createState() => _CategoryContentState();
}

class _CategoryContentState extends State<CategoryContent> {
  @override
  Widget build(BuildContext context) {
    ///Temporary lists to allow for the dynamic building of Tabs and PageViews
    List<Widget> _tabs = [];
    List<Widget> _pageView = [];

    ///Dynamically Generating Tabs
    for (int i = 0; i < this.widget.tabNamesFromLtoR.length; ++i) {
      _tabs.add(Tab(text: this.widget.tabNamesFromLtoR[i]));
    } //for

    ///Dynamically Generating PageViews
    for (int i = 0; i < this.widget.tabNamesFromLtoR.length; ++i) {
      _pageView.add(SingleCategoryView(eventType: this.widget.tabNamesFromLtoR[i]));
    } //for
    ///TODO: Account for only 1 sub-Category. Maybe just use a different special widget
    return SafeArea(
      child: DefaultTabController(
        length: this.widget.tabNamesFromLtoR.length,
        child: Scaffold(
          appBar: PreferredSize(
            preferredSize:
                Size.fromHeight(MediaQuery.of(context).size.height * .15),
            child: AppBar(
              flexibleSpace: Stack(
                children: <Widget>[
                  Container(
                    width: double.infinity,
                    height: double.infinity,
                    child: Image(
                      image: ResizeImage(
                        AssetImage("images/tenney.jpg"),
                        width: int.parse(
                          MediaQuery.of(context)
                              .size
                              .width
                              .toString()
                              .replaceAll('.', ''),
                        ),
                      ),
                      fit: BoxFit.fill,
                    ),
                  ),
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
                onPressed: () => Navigator.pushReplacement(
                  context,
                  //TODO: Add a Slide-In-Left to the Home Page.
                  PageRouteBuilder(
                    pageBuilder: (context, animation1, animation2) =>
                        HomePage(),
                  ),
                ),
              ),
              centerTitle: false,
              title: Text(this.widget.title,
                  style: TextStyle(
                      color: kHavenLightGray, fontWeight: FontWeight.bold)),
              actions: <Widget>[
                IconButton(
                  color: kHavenLightGray,
                  splashColor: kActiveHavenLightGray,
                  icon: Icon(Icons.search),
                  onPressed: () async {
                    await showSearch(context: context, delegate: Search());
                  },
                )
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
