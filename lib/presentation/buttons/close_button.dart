import 'package:flutter/material.dart';
import 'package:communitytabs/presentation/presentation.dart';

typedef OnTapCallback = void Function ();

class CustomCloseButton extends StatelessWidget {

  final OnTapCallback onClose;

  const CustomCloseButton({Key key, @required this.onClose}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        SizedBox(
          width: MediaQuery.of(context).size.width * .03,
        ),
        GestureDetector(
            child: Icon(Icons.close, color: kHavenLightGray),
            onTap: onClose,
        ),
      ],
    );
  }// build
}
