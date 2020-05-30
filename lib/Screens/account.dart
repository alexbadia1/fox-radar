import 'package:communitytabs/colors/marist_color_scheme.dart';
import 'package:communitytabs/components/accountDrawer.dart';
import 'package:communitytabs/components/slidingUpNavigationBar.dart';
import 'package:communitytabs/components/toggleDrawer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:communitytabs/data/user.dart';

class Account extends StatefulWidget {
  @override
  _AccountState createState() => _AccountState();
}

class _AccountState extends State<Account> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  void openSideDrawer(ans) {
    ans = 1;
    print('openSideDrawerCalled!');
    _scaffoldKey.currentState.openEndDrawer();
  }

  @override
  Widget build(BuildContext context) {
    User user = Provider.of<User>(context);
    String accountName = '';
    user == null ? accountName = '' : accountName = user.uid;
    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
        ///////////////////////////
        //////////App Bar//////////
        ///////////////////////////
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: Text(
            accountName,
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
            CoverContainer(openDrawerCallback: openSideDrawer)
          ],
        ),

        ///////////////////////////
        ///////Right Drawer////////
        ///////////////////////////
        endDrawer: AccountDrawer(),
        body: SlidingUpNavigationBar(namedRoute: '/account',),
      ),
    );
  }
}
