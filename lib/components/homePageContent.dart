import 'package:communitytabs/colors/marist_color_scheme.dart';
import 'package:communitytabs/data/club_event_data.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'club_card.dart';
import 'customNavigationItem.dart';

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
    if (_events == null) {_events = [];}

    return CustomScrollView(
      slivers: [
        SliverGrid.count(
          key: navigation,
          crossAxisCount: 2,
          crossAxisSpacing: MediaQuery.of(context).size.width * .015,
          mainAxisSpacing: MediaQuery.of(context).size.height * .01,
          childAspectRatio: 5,
          children: <Widget>[
            CustomNavigationItem(
                option: 'Arts', icon: Icons.palette, nextPage: '/sports'),
            CustomNavigationItem(
              option: 'Sports',
              icon: Icons.flag,
              nextPage: '/sports',
            ),
            CustomNavigationItem(
                option: 'Diversity',
                icon: Icons.public,
                nextPage: '/sports'),
            CustomNavigationItem(
                option: 'Clubs', icon: Icons.group, nextPage: '/sports'),
            CustomNavigationItem(
                option: 'Food',
                icon: Icons.local_dining,
                nextPage: '/sports'),
            CustomNavigationItem(
                option: 'Greek',
                icon: Icons.account_balance,
                nextPage: '/sports'),
          ],
        ),
        SliverAppBar(
          centerTitle: false,
          title: Text('Suggestions', style: TextStyle(color: kHavenLightGray),),
          backgroundColor: Colors.transparent,
        ),
        SliverList(
          delegate: _events == null?
          SliverChildListDelegate(
            [Center(child: Text('Welp, Nothings Going On'),)]
          )
          :SliverChildBuilderDelegate((BuildContext context, int index) {
            return clubCard(_events[index], context);
          }, childCount: _events?.length ),
        ),
      ],
    );
  }
}
