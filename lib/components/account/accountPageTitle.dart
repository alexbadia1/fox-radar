import 'package:flutter/material.dart';
import '../../constants/marist_color_scheme.dart';

///Abstracted Title to avoid having to rebuild the entire AppBar
///upon opening the slidingUpBar.
class AccountPageTitle extends StatefulWidget {
  final String username;
  AccountPageTitle({this.username});

  @override
  _AccountPageTitleState createState() => _AccountPageTitleState();
}

class _AccountPageTitleState extends State<AccountPageTitle> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child:Text(
        this.widget.username,
        style: TextStyle(color: kHavenLightGray, fontSize: 19.0, fontWeight: FontWeight.bold),
      )
    );
  }
}