import 'package:flutter/material.dart';
import 'package:loading/indicator/ball_spin_fade_loader_indicator.dart';
import 'package:loading/loading.dart';

//Color Palette
//Dark Mode
const Color cBackground = Color.fromRGBO(32, 32, 32, 1);
const Color cCard = Color.fromRGBO(48, 48, 48, 1);

//Washed
const Color cWashedRed = Color.fromRGBO(255, 77, 77, .8);
const Color cWashedGreen = Color.fromRGBO(121, 255, 77, 1.0);
//Full Red
const Color cFullRed = Color.fromRGBO(230, 0, 0, .8);
const Color cFullGreen = Color.fromRGBO(57, 230, 0, 1.0);

const Color cWashedRedFaded = Color.fromRGBO(255, 77, 77, .725);
//Full Red
const Color cFullRedFaded = Color.fromRGBO(230, 0, 0, .725);

//iLearn Green
const Color cIlearnGreen = Color.fromRGBO(0, 110, 122, 1.0);

//Modern Gray
const Color kHavenLightGray = Color.fromRGBO(50, 50, 50, 1.0);
const Color kActiveHavenLightGray = Color.fromRGBO(77, 77, 77, 1.0);

//Components
const Color cBackgroundColor = Color.fromRGBO(255, 255, 255, 1.0);

//Fully solid gradients
LinearGradient cGreedGradient = LinearGradient(
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
  colors: <Color>[
    cWashedGreen,
    cFullGreen,
  ],
);

//Gradients
LinearGradient cMaristGradient = LinearGradient(
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
  colors: <Color>[
    cWashedRed,
    cFullRed,
  ],
);

LinearGradient cMaristGradientWashed = LinearGradient(
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
  colors: <Color>[
    cWashedRedFaded,
    cFullRedFaded,
  ],
);

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
