import 'package:communitytabs/colors/marist_color_scheme.dart';
import 'package:communitytabs/components/accountSlidingUpNavigationBar.dart';
import 'package:communitytabs/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:communitytabs/data/user.dart';

class Account extends StatelessWidget {
  final AuthService _auth = new AuthService();
  @override
  Widget build(BuildContext context) {
    User user = Provider.of<User>(context);
    String accountName = '';
    user == null ? accountName = '': accountName = user.uid;

    return SafeArea(
      child: Scaffold(

        ///////////////////////////
        //////////App Bar//////////
        ///////////////////////////
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: Text(accountName, style: TextStyle(color: kHavenLightGray),),
          centerTitle: false,
          flexibleSpace:
              Container(decoration: BoxDecoration(gradient: cMaristGradient)),
        ),

        ///////////////////////////
        ///////Right Drawer////////
        ///////////////////////////
        endDrawer: Drawer(
          child: FlatButton(
            child: Text("Sign Out"),
            onPressed: () async {
              dynamic success = await _auth.signOut();
              success != -1
                  ? Navigator.pushReplacementNamed(context, '/')
                  : print("Error Signing Out");
            },
          ),
        ),
        body: AccountSlidingUpNavigationBar(),
      ),
    );
  }
}
