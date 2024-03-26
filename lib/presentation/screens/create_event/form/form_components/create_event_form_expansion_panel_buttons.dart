import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fox_radar/logic/logic.dart';
import 'package:fox_radar/presentation/presentation.dart';


/// A void callback that triggers from the Flutter defined Button onPressed() property.
///
/// The argument passed back during the callback is the current temporary DateTime stored in the ExpansionPanelCubit.
typedef OnPressedCallback = void Function();

class ExpansionPanelCancelButton extends StatelessWidget {

  /// A void callback that triggers from the Flutter defined Button onPressed() property.
  final OnPressedCallback onPressedCallback;
  const ExpansionPanelCancelButton({Key? key, required this.onPressedCallback}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      child: Text('Cancel', style: TextStyle(color: cWhite100)),
      onPressed: onPressedCallback,
    );
  }
}

class ExpansionPanelBackButton extends StatelessWidget {
  /// A void callback that triggers from the Flutter defined Button onPressed() property.
  final OnPressedCallback? onPressedCallback;
  const ExpansionPanelBackButton({Key? key, this.onPressedCallback}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      child: Text('Back', style: TextStyle(color: cWhite100)),
      onPressed: () {
        BlocProvider.of<DateTimePickerCubit>(context).openExpansionPanelToDatePicker();
      },
    );
  }
}


class ExpansionPanelContinueButton extends StatelessWidget {
  /// A void callback that triggers from the Flutter defined Button onPressed() property.
  final OnPressedCallback? onPressedCallback;
  const ExpansionPanelContinueButton({Key? key, this.onPressedCallback}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      child: Text('Continue', style: TextStyle(color: cBlue)),
      onPressed: () {
        BlocProvider.of<DateTimePickerCubit>(context).openExpansionPanelToTimePicker();
      },
    );
  }
}

class ExpansionPanelConfirmButton extends StatelessWidget {

  /// A void callback that triggers from the Flutter defined Button onPressed() property.
  ///
  /// The argument passed back during the callback is the current temporary DateTime stored in the ExpansionPanelCubit.
  final OnPressedCallback onPressedCallback;
  const ExpansionPanelConfirmButton({Key? key, required this.onPressedCallback}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return TextButton(
      child: Text('Confirm', style: TextStyle(color: cBlue)),
      onPressed: onPressedCallback,
    );
  }
}