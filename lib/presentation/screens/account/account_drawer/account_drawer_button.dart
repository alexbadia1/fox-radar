import 'package:flutter/material.dart';
import 'package:communitytabs/presentation/presentation.dart';

typedef OpenDrawerCallback = void Function();

class AccountDrawerButton extends StatelessWidget {
  final OpenDrawerCallback openDrawerCallback;

  const AccountDrawerButton({Key key, @required this.openDrawerCallback})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: this.openDrawerCallback,
      color: kHavenLightGray,
      icon: Icon(Icons.menu, color: kHavenLightGray),
    );
  } // build
} // AccountDrawerButton
