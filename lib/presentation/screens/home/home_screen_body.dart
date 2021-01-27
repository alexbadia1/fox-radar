import 'package:communitytabs/components/clubCardBig.dart';
import 'file:///C:/Users/alex.badia1/Github/marist_community_tabs/lib/presentation/components/sliver_app_bar.dart';
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


class HomeScreenBody extends StatefulWidget {
  //TODO: Add add preferences Arguments for Horizontal Lists for preferences.
  @override
  _HomeScreenBodyState createState() => _HomeScreenBodyState();
}

class _HomeScreenBodyState extends State<HomeScreenBody> with AutomaticKeepAliveClientMixin {
  GlobalKey navigation = new GlobalKey();
  @override
  Widget build(BuildContext context) {
    super.build(context);
    double screenHeight = MediaQuery.of(context).size.height;
        return Container(
          color: cBackground,
          child: CustomScrollView(
            slivers: [
              MaristSliverAppBar(title: 'Marist'),
              SliverGrid.count(
                key: navigation,
                crossAxisCount: 2,
                crossAxisSpacing: MediaQuery.of(context).size.width * .02,
                mainAxisSpacing: MediaQuery.of(context).size.height * .01,
                childAspectRatio: 4,
                children: <Widget>[
                  CustomNavigationItem(option: 'Arts', icon: Icons.palette, nextPage: '/arts'),
                  CustomNavigationItem(option: 'Sports', icon: Icons.flag, nextPage: '/sports'),
                  CustomNavigationItem(option: 'Diversity', icon: Icons.public, nextPage: '/diversity'),
                  CustomNavigationItem(option: 'Student', icon: Icons.library_books, nextPage: '/student'),
                  CustomNavigationItem(option: 'Food', icon: Icons.local_dining, nextPage: '/food'),
                  CustomNavigationItem(option: 'Greek', icon: Icons.account_balance, nextPage: '/greek'),
                ],
              ),
              SliverAppBar(
                centerTitle: false,
                backgroundColor: Colors.transparent,
                title: Text(
                  'Suggestions',
                  style: TextStyle(color: kHavenLightGray),
                ),
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
