import 'package:flutter/material.dart';
import 'package:loading_fixed/loading.dart';
import 'package:loading_fixed/indicators/indicators.dart';

class LoadingWidget extends StatelessWidget {
  final double size;
  final Color color;
  LoadingWidget({this.size, this.color});
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * .65,
      child: Center(
        child: FixedLoadingWidget(
          indicator: BallSpinFadeLoaderIndicator(),
          size: size ?? 55.0,
          color: color ?? Color.fromRGBO(255, 255, 255, .50),
        ),
      ),
    );
  }// build
}// LoadingWidget