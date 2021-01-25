import 'package:communitytabs/logic/blocs/blocs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AccountDrawerContents extends StatefulWidget {
  @override
  _AccountDrawerContentsState createState() => _AccountDrawerContentsState();
}

class _AccountDrawerContentsState extends State<AccountDrawerContents> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: FlatButton(
        child: Text("Sign Out"),
        onPressed: () {
          BlocProvider.of<LoginBloc>(context).add(LoginEventLogout());
          Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
        },
      ),
    );
  }
}
