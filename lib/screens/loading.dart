import 'package:communitytabs/logic/blocs/authentication_cubit.dart';
import 'package:communitytabs/logic/blocs/authentication_event.dart';
import 'package:flutter/material.dart';
import 'package:communitytabs/constants/marist_color_scheme.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoadingScreen extends StatefulWidget {
  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  @override
  void initState() {
    super.initState();
  }// initState

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
