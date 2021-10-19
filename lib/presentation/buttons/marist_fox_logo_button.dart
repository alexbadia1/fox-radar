import 'package:flutter/material.dart';

class MaristFoxLogo extends StatelessWidget {
  final _url = 'https://my.marist.edu/';

  _launchURL() async {
    // TODO: Add URL launcher to dependencies
  } //_launchURL

  @override
  Widget build(BuildContext context) {
    return RawMaterialButton(
      onPressed: () {
        // _launchURL();
      },
      child: Center(
        child: Image(
          width: MediaQuery.of(context).size.width * .1,
          image: AssetImage('images/fox.png'),
          fit: BoxFit.fill,
        ),
      ),
    );
  }// build
}// MaristFoxLogo
