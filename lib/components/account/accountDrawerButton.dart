import 'package:communitytabs/constants/marist_color_scheme.dart';
import 'package:flutter/material.dart';

class AccountDrawerButton extends StatelessWidget {
  final openDrawerCallback;
  AccountDrawerButton({this.openDrawerCallback});
  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {return openDrawerCallback(2);},
      color: kHavenLightGray,
      icon: Icon(Icons.menu, color: kHavenLightGray),
    );
  }
}
