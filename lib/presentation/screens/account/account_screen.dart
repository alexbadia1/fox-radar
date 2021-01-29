import 'package:communitytabs/data/slidingUpPanelMetadata.dart';
import 'package:communitytabs/screens/addEvent.dart';
import 'package:provider/provider.dart';
import 'account_bottom_navigation_bar.dart';
import 'account_screen_body.dart';
import 'package:flutter/material.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class AccountScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    SlidingUpPanelMetaData _slidingUpPanelMetaData =
    Provider.of<SlidingUpPanelMetaData>(context);

    return SafeArea(
      child: Material(
        child: SafeArea(
          child: SlidingUpPanel(
            controller: _slidingUpPanelMetaData.getPanelController,
            minHeight: MediaQuery.of(context).size.height * .0625,
            maxHeight: MediaQuery.of(context).size.height,
            collapsed: AccountBottomNavigationBar(),
            isDraggable: false,
            panel: AddEventContent(),
            body: AccountScreenBody(),
          ),
        ),
      ),
    );
  }
}
