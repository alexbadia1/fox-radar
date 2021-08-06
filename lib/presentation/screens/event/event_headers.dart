import 'package:flutter/material.dart';
import 'package:communitytabs/presentation/presentation.dart';

class HeaderLevelOne extends StatelessWidget {
  final String text;
  const HeaderLevelOne({this.text});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: <Widget>[
          SizedBox(
            width: MediaQuery.of(context).size.width * .0175,
          ),
          Expanded(
            child: Text(
              this.text,
              style: TextStyle(
                color: cWhite100,
                fontSize: 28.0,
                fontWeight: FontWeight.bold,
                fontFamily: 'Lato',
              ),
            ),
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width * .125,
          ),
        ],
      ),
    );
  } // build
} // HeaderLevelOne

class HeaderLevelTwo extends StatelessWidget {
  final String text;
  const HeaderLevelTwo({this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: <Widget>[
          SizedBox(
            width: MediaQuery.of(context).size.width * .042,
          ),
          Expanded(
            child: Text(
              this.text ?? '',
              style: TextStyle(
                color: cWhite100,
                fontSize: 22.0,
                fontWeight: FontWeight.bold,
                fontFamily: 'Lato',
              ),
            ),
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width * .125,
          ),
        ],
      ),
    );
  } // build
} // HeaderLevelTwo
