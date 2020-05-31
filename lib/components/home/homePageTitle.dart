import 'package:flutter/material.dart';
import 'package:communitytabs/constants/marist_color_scheme.dart';

class HomePageTitle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text(
        "Marist",
        style: TextStyle(color: kHavenLightGray, fontSize: 19.0, fontWeight: FontWeight.bold),
      )
    );
  }
}
