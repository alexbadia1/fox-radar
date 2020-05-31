import 'package:communitytabs/data/slidingUpPanelMetadata.dart';
import 'package:communitytabs/wrappers/accountWrapper.dart';
import 'package:communitytabs/wrappers/homeWrapper.dart';
import 'package:communitytabs/wrappers/slidingUpPanelWrapper.dart';
import 'package:communitytabs/constants/marist_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:provider/provider.dart';
import 'package:communitytabs/Screens/addEvent.dart';

class SlidingUpNavigationBar extends StatelessWidget {
  final String namedRoute;
  SlidingUpNavigationBar({@required this.namedRoute});
  @override
  Widget build(BuildContext context) {

    SlidingUpPanelMetaData _slidingUpPanelMetaData = Provider.of<SlidingUpPanelMetaData>(context);

    return SafeArea(
      child: SlidingUpPanel(
        controller: _slidingUpPanelMetaData.getPanelController,
        minHeight: MediaQuery.of(context).size.height * .065,
        maxHeight: MediaQuery.of(context).size.height,
        collapsed: CollapsedWidget(),
        isDraggable: false,
        panel: AddEventContent(),
        body: SlidingUpPanelBodyWrapper(namedRoute: this.namedRoute),
      ),
    );
  }
}

class CollapsedWidget extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Consumer<SlidingUpPanelMetaData>(
      builder: (context, panelState, child) {
        return panelState.getPanelIsClosed
            ? Stack(
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
                            print("+ pressed");
                            panelState.getPanelController.open();
                            panelState.setPanelIsClosed(false);
                          }),
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
              )
            : Container();
      },
    );
  }
}
