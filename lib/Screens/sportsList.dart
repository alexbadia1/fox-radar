import 'package:communitytabs/colors/marist_color_scheme.dart';
import 'package:flutter/material.dart';

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
                Image(
                    image: AssetImage("images/tenney.jpg"), fit: BoxFit.cover),
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: <Color>[
                        cWashedRed,
                        cFullRed,
                      ],
                    ),
                  ),
                ),
              ],
            ),
            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            title: Text('Sports'),
            actions: <Widget>[
              IconButton(
                icon: Icon(Icons.search),
                onPressed: () {

                },
              )
            ],
            bottom: TabBar(
              indicatorSize: TabBarIndicatorSize.tab,
              tabs: <Widget>[
                Tab(
                  child: Text('Intramural'),
                ),
                Tab(child: Text('College')),
                Tab(child: Text('Club')),
              ],
            ),
          ),
          body: TabBarView(
            children: <Widget>[
              PageView(
                children: <Widget>[
                  Container(
                    color: Colors.red,
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
        ),
      ),
    );
  }
}
