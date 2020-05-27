import 'package:communitytabs/Screens/loading.dart';
import 'package:communitytabs/Screens/login.dart';
import 'package:flutter/material.dart';
import 'package:communitytabs/data/user.dart';
import 'package:provider/provider.dart';


class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    User _user = Provider.of<User>(context);

    //Depending on what we pick up from the stream show the home or login page
    if(_user == null) {
      return Login();
    } else {
      return LoadingScreen();}
    //Either return the authentication screen or home screen
  }
}
