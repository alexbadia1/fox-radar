import 'package:flutter/material.dart';

class LonelyPandaImage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _width = MediaQuery.of(context).size.width;
    final _height = MediaQuery.of(context).size.height;

    return Image(
      image: AssetImage(
        'images/lonely_panda.png',
      ),
      height: _height * .25,
      width: _width * .25,
    );
  }// build
}// lonelyPandaImage
