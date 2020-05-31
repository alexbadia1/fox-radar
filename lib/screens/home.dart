import 'package:communitytabs/data/club_event_data.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:communitytabs/constants/marist_color_scheme.dart';
import 'package:communitytabs/components/club_card.dart';
import 'package:communitytabs/buttons/customNavigationItem.dart';
import 'package:communitytabs/buttons/maristFoxLogo.dart';
import 'package:communitytabs/components/home/searchButton.dart';
import 'package:communitytabs/components/home/homePageTitle.dart';

class HomePageContent extends StatefulWidget {
  @override
  _HomePageContentState createState() => _HomePageContentState();
}

class _HomePageContentState extends State<HomePageContent> {
  GlobalKey navigation = new GlobalKey();
  List<ClubEventData> _events = [];
  @override
  Widget build(BuildContext context) {
    _events = Provider.of<List<ClubEventData>>(context);
    if (_events == null) {
      _events = [];
    }

    return Container(
      color: cBackground,
      child: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: Colors.transparent,
            pinned: true,
            flexibleSpace: Container(
              width: double.infinity,
              height: MediaQuery.of(context).size.height * 0.0725,
              child: Stack(
                children: <Widget>[
                  Image(
                      width: double.infinity,
                      height: 100.0,
                      image: ResizeImage(
                        AssetImage("images/tenney.jpg"),
                        width: 500,
                        height: 100,
                      ),
                      fit: BoxFit.fill),
                  Container(
                    decoration: BoxDecoration(gradient: cMaristGradientWashed),
                  ),
                  Row(
                    children: <Widget>[
                      Expanded(flex: 1, child: SizedBox()),
                      Expanded(flex: 4,child: MaristFoxLogo()),
                      Expanded(flex: 1, child: SizedBox()),
                      Expanded(flex: 30, child: HomePageTitle()),
                      Expanded(flex: 3, child: SearchButton()),
                      Expanded(flex: 2, child: SizedBox()),
                    ],
                  ),
                ],
              ),
            ),
          ),
          SliverGrid.count(
            key: navigation,
            crossAxisCount: 2,
            crossAxisSpacing: MediaQuery.of(context).size.width * .02,
            mainAxisSpacing: MediaQuery.of(context).size.height * .01,
            childAspectRatio: 4,
            children: <Widget>[
              CustomNavigationItem(
                  option: 'Arts', icon: Icons.palette, nextPage: '/arts'),
              CustomNavigationItem(
                  option: 'Sports', icon: Icons.flag, nextPage: '/sports'),
              CustomNavigationItem(
                  option: 'Diversity',
                  icon: Icons.public,
                  nextPage: '/diversity'),
              CustomNavigationItem(
                  option: 'Student',
                  icon: Icons.library_books,
                  nextPage: '/clubs'),
              CustomNavigationItem(
                  option: 'Food', icon: Icons.local_dining, nextPage: '/food'),
              CustomNavigationItem(
                  option: 'Greek',
                  icon: Icons.account_balance,
                  nextPage: '/greek'),
            ],
          ),
          SliverAppBar(
            centerTitle: false,
            title: Text(
              'Suggestions',
              style: TextStyle(color: kHavenLightGray),
            ),
            backgroundColor: Colors.transparent,
          ),
          SliverList(
            delegate: _events == null
                ? SliverChildListDelegate([
                    Center(
                      child: Text('Welp, Nothings Going On'),
                    )
                  ])
                : SliverChildBuilderDelegate((BuildContext context, int index) {
                    return clubCard(_events[index], context);
                  }, childCount: _events?.length),
          ),
        ],
      ),
    );
  }
}
