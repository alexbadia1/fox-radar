import 'package:flutter/material.dart';
import 'package:fox_radar/presentation/presentation.dart';

class Subtitle extends StatelessWidget {

  final IconData? icon;
  final String? text;

  const Subtitle({this.icon, this.text});

  @override
  Widget build(BuildContext context) {
    return  Row(
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        SizedBox(
          width: MediaQuery.of(context).size.width * .022,
        ),
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Expanded(
                flex: 1,
                child: Icon(
                  icon,
                  color: cWhite70,
                  size: 16.0,
                ),
              ),
              Expanded(
                flex: 10,
                child: Text(
                  text ?? '',
                  style: TextStyle(
                    color: cWhite70,
                    fontSize: 12.0,
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
        )
      ],
    );
  }
}