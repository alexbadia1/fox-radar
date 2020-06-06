import 'package:communitytabs/data/expansionTileMetadata.dart';
import 'package:communitytabs/data/slidingUpPanelMetadata.dart';
import 'package:communitytabs/constants/marist_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:provider/provider.dart';
import 'package:communitytabs/Screens/addEvent.dart';
import 'package:communitytabs/wrappers.dart';

class SlidingUpNavigationBar extends StatelessWidget {
  final String namedRoute;
  SlidingUpNavigationBar({@required this.namedRoute});
  @override
  Widget build(BuildContext context) {
    SlidingUpPanelMetaData _slidingUpPanelMetaData =
        Provider.of<SlidingUpPanelMetaData>(context);

    return SafeArea(
      child: SlidingUpPanel(
        controller: _slidingUpPanelMetaData.getPanelController,
        minHeight: MediaQuery.of(context).size.height * .0625,
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
    ExpansionTiles _expansionPanels = Provider.of<ExpansionTiles>(context);
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
                            panelState.getPanelController.open();
                            panelState.setPanelIsClosed(false);
                            _expansionPanels.data[0].setHeaderDateValue(DateFormat('E, MMMM d, y').format(DateTime.now()).toString());
                            _expansionPanels.data[0].setHeaderTimeValue(DateFormat.jm().format(DateTime.now()).toString());
                            _expansionPanels.updateExpansionPanels();
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
