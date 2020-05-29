import 'dart:ui';
import 'package:communitytabs/components/homeSlidingUpNavigationBar.dart';
import 'package:communitytabs/services/search.dart';
import 'package:flutter/material.dart';
import 'package:communitytabs/colors/marist_color_scheme.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: Text(
            "Marist",
            style: TextStyle(color: kHavenLightGray),
          ),
          centerTitle: false,
          flexibleSpace: Stack(
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
                decoration:
                BoxDecoration(gradient: cMaristGradientWashed),
              ),
            ],
          ),
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
        ),
        body: HomeSlidingUpNavigationBar(),
        ),
    );
  }
} //class
