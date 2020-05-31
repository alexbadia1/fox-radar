import 'package:communitytabs/colors/marist_color_scheme.dart';
import 'package:communitytabs/data/IconsStateProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CoverContainer extends StatelessWidget {
  final openDrawerCallback;
  CoverContainer({this.openDrawerCallback});
  @override
  Widget build(BuildContext context) {
    return Consumer<IconStateProvider>(builder: (context, iconState, child) {
      return iconState.showDrawer
          ? Container(
              child: IconButton(
                onPressed: () {
                  return openDrawerCallback(2);
                },
                color: kHavenLightGray,
                icon: Icon(Icons.dehaze),
              ),
            )
          : Container(
              child: iconState.formStepNum < 3
                  ? FlatButton(
                      textColor: Colors.blueAccent,
                      child: Text(
                        'Next',
                        style: TextStyle(fontSize: 16.0),
                      ),
                      onPressed: () {
                        ///TODO: Advance to the next step
                        iconState.setFormStepNum(iconState.formStepNum + 1);
                        iconState.pageViewController.animateToPage(iconState.formStepNum - 1, duration: const Duration(milliseconds: 400), curve: Curves.easeInOut);
                      },
                    )
                  : FlatButton(
                      textColor: Colors.blueAccent,
                      child: Text(
                        'Create',
                        style: TextStyle(fontSize: 16.0),
                      ),
                      onPressed: () {
                        ///TODO: Submit the Event Form
                      },
                    ),
            );
    });
  }
}
