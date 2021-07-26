import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:communitytabs/logic/logic.dart';

class AccountDrawerContents extends StatefulWidget {
  @override
  _AccountDrawerContentsState createState() => _AccountDrawerContentsState();
}// AccountDrawerContents

class _AccountDrawerContentsState extends State<AccountDrawerContents> {

  // TODO: Add add preferences Arguments for Horizontal Lists for preferences.
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: TextButton(
        child: Text("Sign Out"),
        onPressed: () {
          BlocProvider.of<LoginBloc>(context).add(LoginEventLogout());
        },
      ),
    );
  }// build
}// _AccountDrawerContentsState
