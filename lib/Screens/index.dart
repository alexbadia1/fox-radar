import 'dart:ui';
import 'package:communitytabs/components/home/homePageTitle.dart';
import 'package:communitytabs/components/temporaryCancelButton.dart';
import 'package:communitytabs/components/slidingUpNavigationBar.dart';
import 'package:communitytabs/components/home/searchButton.dart';
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
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(MediaQuery.of(context).size.height * .0725),
          child: AppBar(
            backgroundColor: Colors.transparent,
            automaticallyImplyLeading: false,
            leading: TemporaryCloseButton(),
            title: HomePageTitle(),
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
              SearchButton()
            ],
          ),
        ),
        body: SlidingUpNavigationBar(namedRoute: '/home',),
        ),
    );
  }
} //class
