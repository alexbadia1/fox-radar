import 'package:flutter/material.dart';
import 'package:communitytabs/presentation/presentation.dart';

class AccountDrawerButton extends StatelessWidget {
  final openDrawerCallback;
  AccountDrawerButton({this.openDrawerCallback});
  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        return openDrawerCallback(2);
      },
      color: kHavenLightGray,
      icon: Icon(Icons.menu, color: kHavenLightGray),
    );
  }
}
