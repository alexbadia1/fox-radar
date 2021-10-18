import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:communitytabs/logic/logic.dart';
import 'package:communitytabs/presentation/presentation.dart';

typedef OpenDrawerCallback = void Function();

class AccountDrawerButton extends StatelessWidget {
  final OpenDrawerCallback openDrawerCallback;
  const AccountDrawerButton({Key key, @required this.openDrawerCallback}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _auth = context.watch<AuthenticationBloc>().state;

    if (_auth is AuthenticationStateAuthenticated) {
      final Uint8List _imageBytes = _auth.imageBytes;

      /// Try to show profile image
      if (_imageBytes != null) {
        return TextButton(
          child: CircleAvatar(
            backgroundImage: MemoryImage(_imageBytes),
          ),
          onPressed: this.openDrawerCallback,
          onLongPress: () {},
        );
      }// if

      /// Show initials, if no profile image
      final String firstInitial = _auth.user.firstName[0]?.toUpperCase() ?? '';
      final String lastInitial = _auth.user.lastName[0]?.toUpperCase() ?? '';
      return TextButton(
        child: CircleAvatar(
          child: Text('$firstInitial$lastInitial'),
        ),
        onPressed: this.openDrawerCallback,
        onLongPress: () {},
      );
    }// if
    return IconButton(
      color: kHavenLightGray,
      onPressed: this.openDrawerCallback,
      icon: Icon(Icons.account_circle_outlined, color: kHavenLightGray),
    );
  } // build
} // AccountDrawerButton
