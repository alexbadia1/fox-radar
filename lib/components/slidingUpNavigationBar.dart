import 'package:communitytabs/data/categoryPanels.dart';
import 'package:communitytabs/data/expansionTileMetadata.dart';
import 'package:communitytabs/data/slidingUpPanelMetadata.dart';
import 'package:communitytabs/constants/marist_color_scheme.dart';
import 'package:communitytabs/presentation/components/bottom_navigation_bar.dart';
import 'package:communitytabs/presentation/screens/home/home_screen.dart';
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
        collapsed: MaristBottomNavigationBar(currentNamedRoute: this.namedRoute),
        isDraggable: false,
        panel: AddEventContent(),
        body: SlidingUpPanelBodyWrapper(namedRoute: this.namedRoute),
      ),
    );
  }
}