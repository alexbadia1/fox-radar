import 'package:flutter/material.dart';
import 'package:communitytabs/services/auth.dart';

class AccountDrawerContents extends StatefulWidget {
  @override
  _AccountDrawerContentsState createState() => _AccountDrawerContentsState();
}

class _AccountDrawerContentsState extends State<AccountDrawerContents> {
  final AuthService _auth = new AuthService();
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: FlatButton(
        child: Text("Sign Out"),
        onPressed: () async {
          dynamic success = await _auth.signOut();
          success != -1
              ? Navigator.of(context).pushNamedAndRemoveUntil('/', (Route<dynamic> route) => false)
              : print("Error Signing Out");
        },
      ),
    );
  }
}
