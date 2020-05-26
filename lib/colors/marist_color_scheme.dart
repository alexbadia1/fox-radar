import 'package:flutter/material.dart';
import 'package:loading/indicator/ball_spin_fade_loader_indicator.dart';
import 'package:loading/loading.dart';

//Color Palette
//Washed Red
const Color cWashedRed = Color.fromRGBO(255, 77, 77, .8);
//Full Red
const Color cFullRed = Color.fromRGBO(230, 0, 0, .8);

//iLearn Green
const Color cIlearnGreen = Color.fromRGBO(0, 110, 122, 1.0);

//Modern Gray
const Color kHavenLightGray = Color.fromRGBO(50, 50, 50, 1.0);
const Color kActiveHavenLightGray = Color.fromRGBO(77, 77, 77, 1.0);

//Components
const Color cBackgroundColor = Color.fromRGBO(255, 255, 255, 1.0);

//Form Text Field Decoration
const InputDecoration customTextField = InputDecoration(
  errorStyle: TextStyle(color: Colors.black),
  errorBorder: UnderlineInputBorder(
    borderSide: BorderSide(
      color: Color.fromRGBO(255, 255, 255, .5),
    ),
  ),
);

//Loading Widget
class LoadingWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * .65,
      child: Center(
        child: Loading(
          indicator: BallSpinFadeLoaderIndicator(),
          size: 55.0,
          color: Color.fromRGBO(255, 255, 255, .50),
        ),
      ),
    );
  }
}
