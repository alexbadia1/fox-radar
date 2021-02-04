import 'package:flutter/material.dart';
import 'package:communitytabs/constants/marist_color_scheme.dart';

class BottomLoadingWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final screenPaddingBottom = MediaQuery.of(context).padding.bottom;
    final screenInsetsBottom = MediaQuery.of(context).viewInsets.bottom;
    final screenPaddingTop = MediaQuery.of(context).padding.top;

    final _realHeight = screenHeight -
        screenPaddingTop -
        screenPaddingBottom +
        screenInsetsBottom;

    return Builder(builder: (context) {
      return Container(
        height: screenHeight * .65,
        width: double.infinity,
        child: Column(
          children: [
            Expanded(flex: 1, child: SizedBox()),
            SizedBox(
              height: _realHeight * .03,
              width: screenWidth * .05,
              child: CircularProgressIndicator(
                backgroundColor: Colors.transparent,
                valueColor: AlwaysStoppedAnimation<Color>(cWhite70),
                strokeWidth: 2.25,
              ),
            ),
            Expanded(flex: 3, child: SizedBox()),
          ],
        ),
      );
    });
  } // build
} // BottomLoadingWidget
