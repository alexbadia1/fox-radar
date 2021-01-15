import 'package:communitytabs/buttons/maristFoxLogo.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:communitytabs/constants/marist_color_scheme.dart';
import 'file:///C:/Users/alex.badia1/Github/Marist_Community_Tabs/lib/services/deprecated_user_model.dart';
import 'package:communitytabs/components/account/accountDrawerContents.dart';
import 'package:communitytabs/components/account/accountPageTitle.dart';

class AccountPageContent extends StatefulWidget {
  @override
  _AccountPageContentState createState() => _AccountPageContentState();
}

class _AccountPageContentState extends State<AccountPageContent> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    // User user = Provider.of<User>(context);

    String accountName = '';

    // user == null ? accountName = '' : accountName = user.getFirstName + ' ' + user.getLastName;
    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
        endDrawer: AccountDrawerContents(),
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(MediaQuery.of(context).size.height * .0725),
          child: AppBar(
            iconTheme: IconThemeData(color: kHavenLightGray),
            backgroundColor: Colors.transparent,
            flexibleSpace: Container(
              width: double.infinity,
              height: MediaQuery.of(context).size.height * .0725,
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
                  Container(decoration: BoxDecoration(gradient: cMaristGradientWashed)),
                  Row(
                    children: <Widget>[
                      Expanded(flex: 1, child: SizedBox()),
                      Expanded(flex: 4, child: MaristFoxLogo()),
                      Expanded(flex: 1, child: SizedBox()),
                      Expanded(flex: 30, child: AccountPageTitle(username: accountName),),
                      Expanded(flex: 3, child: SizedBox()),
                      Expanded(flex: 2, child: SizedBox()),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        body: Container(
          color: cBackground,
          child: Center(
            child: Text('Account Content TBA', style: TextStyle(color: Colors.white)),
          ),
        ),
      ),
    );
  }
}
