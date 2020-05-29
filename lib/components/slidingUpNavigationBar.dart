import 'package:communitytabs/Screens/account.dart';
import 'package:communitytabs/Screens/addEvent.dart';
import 'package:communitytabs/Screens/index.dart';
import 'package:communitytabs/Screens/slidingUpPanelBodyWrapper.dart';
import 'package:communitytabs/colors/marist_color_scheme.dart';
import 'package:communitytabs/data/IconsStateProvider.dart';
import 'package:flutter/material.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:provider/provider.dart';

class SlidingUpNavigationBar extends StatefulWidget {
  final String namedRoute;
  SlidingUpNavigationBar({this.namedRoute});
  @override
  _SlidingUpNavigationBarState createState() =>
      _SlidingUpNavigationBarState();
}

class _SlidingUpNavigationBarState extends State<SlidingUpNavigationBar> {

  @override
  Widget build(BuildContext context) {

    PanelController pc = Provider.of<PanelController>(context);
    var iconsProvider = Provider.of<IconStateProvider>(context);

    return SlidingUpPanel(
      controller: pc,
      minHeight: MediaQuery.of(context).size.height * .065,
      maxHeight: MediaQuery.of(context).size.height,
      collapsed: iconsProvider.showSearch ? Stack(
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
                  onPressed: () {
                    pc.open();
                    iconsProvider.setShowSearch(false);
                    iconsProvider.setShowDrawer(false);
                  }
                  ),
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
      ) : Container(),
      isDraggable: false,
      panel: AddEvent(),
      body: SlidingUpPanelBodyWrapper(namedRoute: this.widget.namedRoute),
    );
  }
}
