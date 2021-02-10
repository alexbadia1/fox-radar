import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:communitytabs/logic/cubits/cubits.dart';
import 'package:communitytabs/constants/marist_color_scheme.dart';

/// A void callback that triggers from the Flutter defined Button onPressed() property.
///
/// The argument passed back during the callback is the current temporary DateTime stored in the ExpansionPanelCubit.
typedef OnPressedCallback = void Function(DateTime dateTime);

class ExpansionPanelCancelButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FlatButton(
      child: Text('Cancel', style: TextStyle(color: cWhite100)),
      onPressed: () {
        BlocProvider.of<ExpansionPanelCubit>(context).closeExpansionPanel();
      },
    );
  }// build
}// ExpansionPanelCancelButton

class ExpansionPanelBackButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FlatButton(
      child: Text('Back', style: TextStyle(color: cWhite100)),
      onPressed: () {
        BlocProvider.of<ExpansionPanelCubit>(context).openExpansionPanelToDatePicker();
      },
    );
  }// build
}// ExpansionPanelPreviousButton


class ExpansionPanelContinueButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FlatButton(
      child: Text('Continue', style: TextStyle(color: cBlue)),
      onPressed: () {
        BlocProvider.of<ExpansionPanelCubit>(context).openExpansionPanelToTimePicker();
      },
    );
  }// build
}// ExpansionPanelPreviousButton

class ExpansionPanelConfirmButton extends StatelessWidget {

  /// A void callback that triggers from the Flutter defined Button onPressed() property.
  ///
  /// The argument passed back during the callback is the current temporary DateTime stored in the ExpansionPanelCubit.
  final OnPressedCallback onPressedCallback;
  const ExpansionPanelConfirmButton({Key key, @required this.onPressedCallback}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return FlatButton(
      child: Text('Confirm', style: TextStyle(color: cBlue)),
      onPressed: () {
        BlocProvider.of<ExpansionPanelCubit>(context).closeExpansionPanel();
        onPressedCallback(BlocProvider.of<ExpansionPanelCubit>(context).state.tempDateTime);
      },
    );
  }// build
}// ExpansionPanelConfirmButton