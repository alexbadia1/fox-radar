import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../colors/marist_color_scheme.dart';
import '../../data/IconsStateProvider.dart';

///Abstracted Title to avoid having to rebuild the entire App Bar
///upon opening the slidingUpBar.
class HomePageTitle extends StatefulWidget {
  @override
  _HomePageTitleState createState() => _HomePageTitleState();
}

class _HomePageTitleState extends State<HomePageTitle> {
  @override
  Widget build(BuildContext context) {
    return Consumer<IconStateProvider>(
        builder: (context, iconState, child) {
          return Container(
            child: iconState.showSearch ? Text(
              "Marist",
              style: TextStyle(color: kHavenLightGray),
            ) : Center(
              child: Text(
                "New Event",
                style: TextStyle(color: kHavenLightGray),
              ),
            ),
          );
        }
    );
  }
}
