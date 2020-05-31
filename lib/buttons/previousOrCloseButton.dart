import 'package:communitytabs/data/slidingUpPanelMetadata.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:communitytabs/constants/marist_color_scheme.dart';
import 'package:communitytabs/data/pageViewMetadata.dart';

class PreviousOrCloseButton extends StatefulWidget {
  @override
  _PreviousOrCloseButtonState createState() => _PreviousOrCloseButtonState();
}

class _PreviousOrCloseButtonState extends State<PreviousOrCloseButton> {
  @override
  Widget build(BuildContext context) {
    SlidingUpPanelMetaData slidingUpPanelMetaData =
        Provider.of<SlidingUpPanelMetaData>(context);
    return Consumer<PageViewMetaData>(
      builder: (context, pageViewState, child) {
        return Container(
          child: pageViewState.formStepNum > 1
              ? IconButton(
                  icon: Icon(Icons.chevron_left),
                  color: kHavenLightGray,
                  onPressed: () {
                    pageViewState.setFormStepNum(pageViewState.formStepNum - 1);
                    FocusScope.of(context).unfocus();
                    pageViewState.pageViewController.animateToPage(
                        pageViewState.formStepNum - 1,
                        duration: const Duration(milliseconds: 400),
                        curve: Curves.easeInOut);
                  },
                )
              : IconButton(
                  icon: Icon(Icons.close),
                  color: kHavenLightGray,
                  onPressed: () {
                    //Close Keyboard
                    FocusScope.of(context).unfocus();
                    slidingUpPanelMetaData.setPanelIsClosed(true);
                    slidingUpPanelMetaData.getPanelController.close();
                  },
                ),
        );
      },
    );
  }
}
