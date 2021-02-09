import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:communitytabs/logic/cubits/cubits.dart';
import 'package:communitytabs/constants/marist_color_scheme.dart';


typedef AddEventBlocCallBloc = void Function(DateTime dateTime);
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
  final AddEventBlocCallBloc addEventBlocCallBloc;
  const ExpansionPanelConfirmButton({Key key, @required this.addEventBlocCallBloc}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return FlatButton(
      child: Text('Confirm', style: TextStyle(color: cBlue)),
      onPressed: () {
        BlocProvider.of<ExpansionPanelCubit>(context).closeExpansionPanel();
        addEventBlocCallBloc(BlocProvider.of<ExpansionPanelCubit>(context).state.tempDateTime);
      },
    );
  }// build
}// ExpansionPanelConfirmButton