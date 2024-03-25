import 'package:flutter/material.dart';
import 'package:fox_radar/presentation/presentation.dart';

class BorderTop extends StatelessWidget {
  final Widget child;

  const BorderTop({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            width: 1.25,
            color: Color.fromRGBO(61, 61, 61, 1.0),
          ),
        ),
      ),
      child: child,
    );
  }// build
}// BorderTop

class BorderLeft extends StatelessWidget {
  final Widget child;

  const BorderLeft({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          left: BorderSide(
            width: 1.25,
            color: Color.fromRGBO(61, 61, 61, 1.0),
          ),
        ),
      ),
      child: child,
    );
  }// build
}// BorderTop

class BorderBottom extends StatelessWidget {
  final Widget child;

  const BorderBottom({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            width: 1.25,
            color: Color.fromRGBO(61, 61, 61, 1.0),
          ),
        ),
      ),
      child: child,
    );
  }// build
}// BorderTop

class BorderTopBottom extends StatelessWidget {
  final Widget? child;
  final double? width;
  final double? height;

  const BorderTopBottom({Key? key, required this.child, this.width, this.height}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: this.height,
      width: this.width,
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            width: 1.25,
            color: Color.fromRGBO(61, 61, 61, 1.0),
          ),
          bottom: BorderSide(
            width: 1.25,
            color: Color.fromRGBO(61, 61, 61, 1.0),
          ),
        ),
      ),
      child: child,
    );
  }// build
}// BorderTop


const Decoration cAddEventBottomBorder =
BoxDecoration(border: Border(bottom: cBorder));