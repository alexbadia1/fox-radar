import 'package:communitytabs/data/categoryPanels.dart';
import 'package:communitytabs/data/expansionTileMetadata.dart';
import 'package:communitytabs/data/slidingUpPanelMetadata.dart';
import 'package:communitytabs/constants/marist_color_scheme.dart';
import 'package:flutter/material.dart';
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
        collapsed: CollapsedWidget(namedRoute: this.namedRoute),
        isDraggable: false,
        panel: AddEventContent(),
        body: SlidingUpPanelBodyWrapper(namedRoute: this.namedRoute),
      ),
    );
  }
}

class CollapsedWidget extends StatelessWidget {
  final String namedRoute;
  CollapsedWidget({@required this.namedRoute});
  @override
  Widget build(BuildContext context) {
    ExpansionTiles _expansionPanels = Provider.of<ExpansionTiles>(context);
    CategoryPanels categoryPanels = Provider.of<CategoryPanels>(context);
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
                          if (this.namedRoute != '/home') {
                            Navigator.pushReplacement(
                              context,
                              PageRouteBuilder(
                                pageBuilder: (context, animation1,
                                    animation2) =>
                                    HomePage(),
                                maintainState: true
                              ),
                            );
                          }
                        }
                      ),
                      IconButton(
                          icon: Icon(Icons.add),
                          color: kHavenLightGray,
                          splashColor: kActiveHavenLightGray,
                          onPressed: () {
                            DateTime currentTime = DateTime.now();
                            panelState.getPanelController.open();
                            panelState.setPanelIsClosed(false);
                            _expansionPanels.data[0].setHeaderDateValue(currentTime);
                            _expansionPanels.data[0].setHeaderTimeValue(currentTime);
                            _expansionPanels.updateExpansionPanels();

                            /// Remember the original category
                            categoryPanels.getCategoryPanels()[0].defaultCategoryPicked = categoryPanels.getCategoryPanels()[0].categoryPicked;
                            /// Remember the original Start Date and Time
                            _expansionPanels.originalStartDateAndTime = currentTime;

                          }),
                      IconButton(
                        icon: Icon(Icons.person),
                        color: kHavenLightGray,
                        splashColor: kActiveHavenLightGray,
                        onPressed: () {
                          if (this.namedRoute != '/account') {
                            Navigator.pushReplacementNamed(
                              context,
                              '/account'
                            );
                          }
                        }
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
