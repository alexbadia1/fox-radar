import 'package:communitytabs/components/clubCardBig.dart';
import 'package:communitytabs/services/deprecated_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:communitytabs/constants/marist_color_scheme.dart';
import 'package:communitytabs/buttons/customNavigationItem.dart';
import 'package:communitytabs/buttons/maristFoxLogo.dart';
import 'package:communitytabs/components/home/searchButton.dart';
import 'package:communitytabs/components/home/homePageTitle.dart';

import 'package:database_repository/database_repository.dart';


class HomePageContent extends StatefulWidget {
  //TODO: Add add preferences Arguments for Horizontal Lists for preferences.
  @override
  _HomePageContentState createState() => _HomePageContentState();
}

class _HomePageContentState extends State<HomePageContent> with AutomaticKeepAliveClientMixin {
  GlobalKey navigation = new GlobalKey();
  @override
  Widget build(BuildContext context) {
    super.build(context);
    double screenHeight = MediaQuery.of(context).size.height;
        return Container(
          color: cBackground,
          child: CustomScrollView(
            slivers: [
              SliverAppBar(
                backgroundColor: Colors.transparent,
                elevation: 0.0,
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
                          Expanded(flex: 4, child: MaristFoxLogo()),
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
                      nextPage: '/student'),
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
              // Consumer<DatabaseRepository>(
              //   builder: (context, db, child) {
              //     return StreamBuilder(
              //       stream: db.streamSuggested,
              //       builder: (context, snapshot) {
              //         int size;
              //         snapshot.hasData ? size = snapshot.data?.length : size = 0;
              //         return SliverList(
              //           delegate: !snapshot.hasData
              //               ? SliverChildListDelegate([
              //                   Center(
              //                     child: Text('Welp, Nothings Going On', style: TextStyle(color: Colors.white),),
              //                   )
              //                 ],)
              //               : SliverChildBuilderDelegate(
              //                   (BuildContext context, int index) {
              //                   return index < size - 1
              //                       ? ClubBigCard(newEvent: snapshot.data[index])
              //                       : Column(
              //                           children: <Widget>[
              //                             ClubBigCard(newEvent: snapshot.data[index]),
              //                             SizedBox(
              //                               height: screenHeight * .1,
              //                               width: double.infinity,
              //                             ),
              //                           ],
              //                         );
              //                 }, childCount: size),
              //         );
              //       }
              //     );
              //   }
              // ),
            ],
          ),
        );
  }

  @override
  bool get wantKeepAlive => true;
}
