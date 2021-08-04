import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:communitytabs/logic/logic.dart';
import 'package:communitytabs/presentation/presentation.dart';

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
                  icon: Icon(Icons.home_outlined),
                  color: kHavenLightGray,
                  splashColor: kActiveHavenLightGray,
                  onPressed: () {
                    BlocProvider.of<AppPageViewCubit>(context).jumpToHomePage();
                  }),

              /// This button opens the sliding up panel
              IconButton(
                icon: Icon(Icons.add_circle_outline_rounded),
                color: kHavenLightGray,
                splashColor: kActiveHavenLightGray,
                onPressed: () {
                  final state = BlocProvider.of<UploadEventBloc>(context).state;
                  if (state is UploadEventStateUploading) {
                    if (!state.complete) {
                      showModalBottomSheet<void>(
                          context: context,
                          builder: (BuildContext context) {
                            return ModalConfirmation(
                              prompt:
                                  'An event is already currently being upload. Please wait for, or cancel, that event!',
                              cancelText: 'CANCEL CURRENT UPLOAD',
                              cancelColor: Colors.redAccent,
                              onCancel: () {
                                showModalBottomSheet(
                                    context: context,
                                    builder: (context) {
                                      return ModalConfirmation(
                                        cancelText: 'CANCEL CURRENT UPLOAD',
                                        cancelColor: Colors.redAccent,
                                        onCancel: () {
                                          BlocProvider.of<UploadEventBloc>(
                                                  context)
                                              .add(UploadEventCancel());

                                          Navigator.popUntil(context,
                                              (route) => route.isFirst);
                                        },
                                        confirmText: "NEVERMIND",
                                        confirmColor: Colors.blueAccent,
                                        onConfirm: () => Navigator.popUntil(
                                            context, (route) => route.isFirst),
                                      );
                                    });
                              },
                              confirmText: 'I CAN WAIT',
                              confirmColor: Colors.blueAccent,
                              onConfirm: () => Navigator.pop(context),
                            );
                          });
                    } // if
                    else {
                      // Reset the upload event bloc
                      BlocProvider.of<UploadEventBloc>(context)
                          .add(UploadEventReset());

                      // Open panel and reset the upload progress bloc
                      BlocProvider.of<SlidingUpPanelCubit>(context).openPanel();
                    } // else
                  } // if
                  else {
                    BlocProvider.of<SlidingUpPanelCubit>(context).openPanel();
                  } // else
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
