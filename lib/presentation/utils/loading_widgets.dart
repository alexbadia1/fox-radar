import 'package:flutter/material.dart';
import 'package:loading_fixed/loading.dart';
import 'package:loading_fixed/indicators/indicators.dart';
import 'package:fox_radar/presentation/presentation.dart';

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
  } // build
} // LoadingWidget

class CustomCircularProgressIndicator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final screenPaddingBottom = MediaQuery.of(context).padding.bottom;
    final screenInsetsBottom = MediaQuery.of(context).viewInsets.bottom;
    final screenPaddingTop = MediaQuery.of(context).padding.top;

    final _realHeight = screenHeight - screenPaddingTop - screenPaddingBottom + screenInsetsBottom;

    return SizedBox(
      height: _realHeight * .03,
      width: screenWidth * .05,
      child: CircularProgressIndicator(
        backgroundColor: Colors.transparent,
        valueColor: AlwaysStoppedAnimation<Color>(cWhite70),
        strokeWidth: 2.25,
      ),
    );
  }// build
}// CustomCircularProgressIndicator
