import 'package:communitytabs/logic/cubits/cubits.dart';
import 'package:flutter/material.dart';
import 'package:communitytabs/constants/marist_color_scheme.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

class AccountBottomNavigationBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final SlidingUpPanelState _slidingUpPanelState =
        context.watch<SlidingUpPanelCubit>().state;

    /// Sliding panel is open,
    /// Show an empty container to make room for the Create Event Screens App Bar
    if (_slidingUpPanelState is SlidingUpPanelOpen) {
      return Container();
    } // if

    /// Sliding Panel is closed,
    /// Show the bottom navigation bar buttons
    else if (_slidingUpPanelState is SlidingUpPanelClosed) {
      return Stack(
        children: <Widget>[
          Container(color: Colors.white),
          Container(decoration: BoxDecoration(gradient: cMaristGradient)),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              /// This button navigates to the Home Screen
              IconButton(
                  icon: Icon(Icons.home),
                  color: kHavenLightGray,
                  splashColor: kActiveHavenLightGray,
                  onPressed: () {
                    Navigator.pushReplacementNamed(context, '/');
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

              /// This does nothing, this is the Account Screen
              IconButton(
                icon: Icon(Icons.person),
                color: kHavenLightGray,
                splashColor: kActiveHavenLightGray,
                onPressed: () {},
              ),
            ],
          ),
        ],
      );
    } //else if

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
