import 'package:communitytabs/colors/marist_color_scheme.dart';
import 'package:communitytabs/components/slidingUpNavigationBar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:communitytabs/services/search.dart';


class SportsList extends StatefulWidget {
  @override
  _SportsListState createState() => _SportsListState();
}

class _SportsListState extends State<SportsList> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 3,
        child: SafeArea(
          child: Scaffold(
            appBar: AppBar(
              flexibleSpace: Stack(
                children: <Widget>[
                  Container(
                    width: double.infinity,
                    height: double.infinity,
                    child: Image(
                      image: ResizeImage(AssetImage("images/tenney.jpg"),
                        width: int.parse(MediaQuery.of(context).size.width.toString().replaceAll('.', ''),
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
                icon: Icon(Icons.arrow_back),
                color: kHavenLightGray,
                splashColor: kActiveHavenLightGray,
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              title: Text('Sports', style: TextStyle(color: kHavenLightGray, fontWeight: FontWeight.bold)),
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
                tabs: <Widget>[
                  Tab(text: 'Intramural'),
                  Tab(text: 'College'),
                  Tab(text: 'Club'),
                ],
              ),
            ),
            body: TabBarView(
              children: <Widget>[
                PageView(
                  children: <Widget>[
                    Container(
                    )
                  ],
                ),
                PageView(
                  children: <Widget>[
                    Container(
                      color: Colors.green,
                    )
                  ],
                ),
                PageView(
                  children: <Widget>[
                    Container(
                      color: Colors.blue,
                    )
                  ],
                ),
              ],
            ),
            bottomNavigationBar: SlidingUpNavigationBar(namedRoute: '/sports',),
          ),
        ),
    );
  }
}
