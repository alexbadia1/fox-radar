import 'package:flutter/material.dart';
import 'package:communitytabs/constants/marist_color_scheme.dart';

class LoadingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: <Color>[
                cWashedRed,
                cFullRed,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
