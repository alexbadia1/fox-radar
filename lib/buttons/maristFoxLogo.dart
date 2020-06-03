import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class MaristFoxLogo extends StatelessWidget {
  _launchURL() async {
    const url = 'https://my.marist.edu/';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  } //_launchURL

  @override
  Widget build(BuildContext context) {
    return RawMaterialButton(
      onPressed: () {
        _launchURL();
      },
      child: Center(
        child: Image(
          width: MediaQuery.of(context).size.width * .1,
          image: AssetImage('images/fox.png'),
          fit: BoxFit.fill,
        ),
      ),
    );
  }
}
