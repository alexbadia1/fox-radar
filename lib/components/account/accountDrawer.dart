import 'package:communitytabs/services/auth.dart';
import 'package:flutter/material.dart';

class AccountDrawer extends StatefulWidget {
  @override
  _AccountDrawerState createState() => _AccountDrawerState();
}

class _AccountDrawerState extends State<AccountDrawer> {
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
