import 'package:flutter/material.dart';
import 'package:fox_radar/presentation/presentation.dart';

typedef OnTapCallbackBackButton = void Function ();

class CustomBackButton extends StatelessWidget {

  final OnTapCallbackBackButton onBack;

  const CustomBackButton({Key? key, required this.onBack}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        SizedBox(
          width: MediaQuery.of(context).size.width * .03,
        ),
        GestureDetector(
          child: Icon(Icons.chevron_left, color: kHavenLightGray),
          onTap: onBack,
        ),
      ],
    );
  }// build
}
