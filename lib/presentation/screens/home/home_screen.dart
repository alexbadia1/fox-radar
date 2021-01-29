import 'package:communitytabs/data/homePageViewModel.dart';
import 'package:communitytabs/data/slidingUpPanelMetadata.dart';
import 'package:communitytabs/presentation/components/components.dart';
import 'package:flutter/material.dart';
import 'package:communitytabs/screens/addEvent.dart';
import 'package:provider/provider.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

import '../../../wrappers.dart';
import 'home_screen_body.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SlidingUpPanelMetaData _slidingUpPanelMetaData =
        Provider.of<SlidingUpPanelMetaData>(context);
    HomePageViewModel _homePageViewModel =
        Provider.of<HomePageViewModel>(context);

    return SafeArea(
      child: Material(
        child: SafeArea(
          child: SlidingUpPanel(
            controller: _slidingUpPanelMetaData.getPanelController,
            minHeight: MediaQuery.of(context).size.height * .0625,
            maxHeight: MediaQuery.of(context).size.height,
            collapsed: MaristBottomNavigationBar(currentNamedRoute: '/home'),
            isDraggable: false,
            panel: AddEventContent(),
            body: PageView(
              controller: _homePageViewModel.homePageViewController,
              physics: NeverScrollableScrollPhysics(),
              children: [
                HomeScreenBody(),
                CategoryPageWrapper(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
