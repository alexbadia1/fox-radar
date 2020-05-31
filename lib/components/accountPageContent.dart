import 'package:flutter/material.dart';

import '../colors/marist_color_scheme.dart';

class AccountPageContent extends StatefulWidget {
  @override
  _AccountPageContentState createState() => _AccountPageContentState();
}

class _AccountPageContentState extends State<AccountPageContent> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        color: cBackground,
        child: Center(
          child: Text('Account Content TBA', style: TextStyle(color: Colors.white),),
        ),
      ),
    );
  }
}