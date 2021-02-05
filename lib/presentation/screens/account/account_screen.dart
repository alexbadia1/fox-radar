import 'package:communitytabs/logic/cubits/cubits.dart';
import 'package:communitytabs/presentation/screens/screens.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'account_bottom_navigation_bar.dart';
import 'account_screen_body.dart';
import 'package:flutter/material.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class AccountScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Material(
        child: SafeArea(
          child: SlidingUpPanel(
            controller: BlocProvider.of<SlidingUpPanelCubit>(context).slidingUpPanelControl,
            minHeight: MediaQuery.of(context).size.height * .0625,
            maxHeight: MediaQuery.of(context).size.height,
            collapsed: AccountBottomNavigationBar(),
            isDraggable: false,
            panel: CreateEventScreen(),
            body: AccountScreenBody(),
          ),
        ),
      ),
    );
  }
}
