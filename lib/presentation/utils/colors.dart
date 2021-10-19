import 'package:flutter/material.dart';

//Dark Mode
const Color cBackground = Color.fromRGBO(0, 0, 0, .935);
const Color cDialogueBackground = Color.fromRGBO(10, 10, 10, .935);
const Color cCard = Color.fromRGBO(35, 35, 35, 1);
const Color cWhite70 = Color.fromRGBO(255, 255, 255, .7);
const Color cWhite65 = Color.fromRGBO(255, 255, 255, .625);
const Color cWhite25 = Color.fromRGBO(255, 255, 255, .25);
const Color cWhite12 = Colors.white12;
const Color cWhite100 = Color.fromRGBO(255, 255, 255, 1);
const Color cBlue = Colors.blueAccent;

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
const cBorder = BorderSide(width: .275, color: cWhite70);

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

//Gradients
LinearGradient cShadowGradient = LinearGradient(
  begin: Alignment.centerLeft,
  end: Alignment.centerRight,
  colors: <Color>[
    Color.fromRGBO(31, 31, 31, .35),
    Color.fromRGBO(61, 61, 61, .25),
  ],
);

class FullScreenGradient extends StatelessWidget {
  final gradient;
  final height;

  FullScreenGradient({@required this.gradient, @required this.height});
  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: double.infinity,
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
    );
  }
}