import 'package:communitytabs/logic/cubits/cubits.dart';
import 'package:flutter/material.dart';
import 'package:communitytabs/data/categoryPanels.dart';
import 'package:communitytabs/data/expansionTileMetadata.dart';
import 'package:communitytabs/data/slidingUpPanelMetadata.dart';
import 'package:communitytabs/constants/marist_color_scheme.dart';
import 'package:communitytabs/presentation/screens/home/home_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

class MaristBottomNavigationBar extends StatelessWidget {
  final String currentNamedRoute;
  const MaristBottomNavigationBar({@required this.currentNamedRoute});
  @override
  Widget build(BuildContext context) {
    ExpansionTiles _expansionPanels = Provider.of<ExpansionTiles>(context);
    CategoryPanels categoryPanels = Provider.of<CategoryPanels>(context);
    HomePageViewCubit _homePageViewCubit = BlocProvider.of<HomePageViewCubit>(context);

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
                      if (this.currentNamedRoute != '/home') {
                        Navigator.pushReplacement(
                          context,
                          PageRouteBuilder(
                              pageBuilder: (context, animation1,
                                  animation2) =>
                                  HomeScreen(),
                              maintainState: true
                          ),
                        );
                      }

                      /// Allows home button to be used to close a category list
                      ///
                      /// Works by defaulting the page view index back to 0
                      if (_homePageViewCubit.currentPage() == 0.0) {
                        _homePageViewCubit.animateToHomePage();
                      }// if
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
                      if (this.currentNamedRoute != '/account') {
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