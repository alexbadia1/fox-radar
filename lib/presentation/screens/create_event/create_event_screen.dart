import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:communitytabs/logic/logic.dart';
import 'package:communitytabs/presentation/presentation.dart';

class CreateEventScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final SlidingUpPanelState _slidingUpPanelState =
        context.watch<SlidingUpPanelCubit>().state;

    // Sliding Up Panel Closed
    // Show a blank container, background isn't white to avoid white flicker when closing the panel
    if (_slidingUpPanelState is SlidingUpPanelClosed) {
      return Container(
      color: cBackground,
      );
    } // if

    // Sliding Up Panel Open
    // Show a the actual event form
    else if (_slidingUpPanelState is SlidingUpPanelOpen) {
      return CreateEventBody();
    } // else-if

    else {
      return Container(
          child: Center(
              child: Text(
                  'Sliding Up Panel Cubit did not return a state that is either open or closed!')));
    } // else
  }
}
