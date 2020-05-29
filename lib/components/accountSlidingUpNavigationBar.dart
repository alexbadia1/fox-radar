import 'package:communitytabs/Screens/account.dart';
import 'package:communitytabs/Screens/addEvent.dart';
import 'package:communitytabs/Screens/index.dart';
import 'package:communitytabs/colors/marist_color_scheme.dart';
import 'package:communitytabs/components/accountPageContent.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class AccountSlidingUpNavigationBar extends StatefulWidget {
  @override
  _AccountSlidingUpNavigationBarState createState() => _AccountSlidingUpNavigationBarState();
}

class _AccountSlidingUpNavigationBarState extends State<AccountSlidingUpNavigationBar> {

  @override
  Widget build(BuildContext context) {
    PanelController pc = Provider.of<PanelController>(context);
    return SlidingUpPanel(
        controller: pc,
        minHeight: MediaQuery.of(context).size.height * .065,
        maxHeight: MediaQuery.of(context).size.height,
        collapsed: Stack(
          children: <Widget>[
            Container(
              color: Colors.white,
            ),
            Container(
              decoration: BoxDecoration(gradient: cMaristGradient),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                IconButton(
                  icon: Icon(Icons.home),
                  color: kHavenLightGray,
                  splashColor: kActiveHavenLightGray,
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (context, animation1, animation2) =>
                            HomePage(),
                      ),
                    );
                  },
                ),
                IconButton(
                    icon: Icon(Icons.add),
                    color: kHavenLightGray,
                    splashColor: kActiveHavenLightGray,
                    onPressed: () => pc.open()),
                IconButton(
                  icon: Icon(Icons.person),
                  color: kHavenLightGray,
                  splashColor: kActiveHavenLightGray,
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (context, animation1, animation2) =>
                            Account(),
                      ),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
        isDraggable: false,
        panel: AddEvent(),
      body: AccountPageContent(),
    );
  }
}