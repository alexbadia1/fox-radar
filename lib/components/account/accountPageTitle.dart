import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../colors/marist_color_scheme.dart';
import '../../data/IconsStateProvider.dart';

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
    return Consumer<IconStateProvider>(
        builder: (context, iconState, child) {
          return Container(
            child: iconState.showDrawer ? Text(
              this.widget.username,
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