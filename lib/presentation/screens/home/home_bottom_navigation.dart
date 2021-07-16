import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:communitytabs/logic/logic.dart';
import 'package:communitytabs/presentation/presentation.dart';

class HomeBottomNavigationBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    HomePageViewCubit _homePageViewCubit = BlocProvider.of<HomePageViewCubit>(context);

    final SlidingUpPanelState _slidingUpPanelState =
        context.watch<SlidingUpPanelCubit>().state;

    /// Sliding panel is open
    /// Show an empty container to make room for the Create Event Screens App Bar
    if (_slidingUpPanelState is SlidingUpPanelOpen) {
      return SizedBox();
    } // if

    /// Sliding Panel is closed
    /// Show the bottom navigation bar buttons
    else if (_slidingUpPanelState is SlidingUpPanelClosed) {
      return Stack(
        children: <Widget>[
          Container(color: Colors.white),
          Container(decoration: BoxDecoration(gradient: cMaristGradient)),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              /// This does nothing, since this is the Home Screen
              IconButton(
                  icon: Icon(Icons.home),
                  color: kHavenLightGray,
                  splashColor: kActiveHavenLightGray,
                  onPressed: () {
                    /// Allows home button to be used to close a category list
                    /// Works by defaulting the page view index back to 0
                    if (_homePageViewCubit.currentPage() == 1.0) {
                      _homePageViewCubit.animateToHomePage();
                    } // if
                  }),

              /// This button opens the sliding up panel
              IconButton(
                  icon: Icon(Icons.add),
                  color: kHavenLightGray,
                  splashColor: kActiveHavenLightGray,
                  onPressed: () {
                    BlocProvider.of<SlidingUpPanelCubit>(context).openPanel();
                  },
              ),

              /// This button navigates to the Account Screen
              IconButton(
                  icon: Icon(Icons.person),
                  color: kHavenLightGray,
                  splashColor: kActiveHavenLightGray,
                  onPressed: () {
                    Navigator.pushReplacementNamed(context, '/account');
                  }),
            ],
          ),
        ],
      );
    } // else-if

    /// Sliding Up Panel Cubit did not return a state that is either open or closed
    else {
      return Container(
          child: Center(
              child: Text(
                  'Sliding Up Panel Cubit did not return a state that is either open or closed!'),
          ),
      );
    } // else
  }
}
