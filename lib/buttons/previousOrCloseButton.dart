import 'package:communitytabs/data/expansionTileMetadata.dart';
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
    ExpansionTiles expansionTiles = Provider.of<ExpansionTiles>(context);
    return Consumer<PageViewMetaData>(
      builder: (context, pageViewState, child) {
        return Container(
          child: pageViewState.formStepNum > 1
              ? Row(
                children: <Widget>[
                  SizedBox(width: MediaQuery.of(context).size.width * .03,),
                  GestureDetector(
                      child: Icon(Icons.chevron_left, color: kHavenLightGray),
                      onTap: () {
                        ///Close Keyboard
                        FocusScope.of(context).unfocus();

                        ///Update what form step number We're on
                        pageViewState.setFormStepNum(pageViewState.formStepNum - 1);

                        ///"Navigate" to the next PageView based on the form step number
                        pageViewState.pageViewController.animateToPage(
                            pageViewState.formStepNum - 1,
                            duration: const Duration(milliseconds: 400),
                            curve: Curves.easeIn);
                      },
                    ),
                ],
              )
              : Row(
                children: <Widget>[
                  SizedBox(width: MediaQuery.of(context).size.width * .03,),
                  GestureDetector(
                      child: Icon(Icons.close, color: kHavenLightGray),
                      onTap: () {
                        ///Close Keyboard
                        FocusScope.of(context).unfocus();

                        ///TODO: Close all Expansion Panels by setting isExpanded to false. Hint use ChangeNotifier for the data and Consumer around the ExpansionPanelList
                        expansionTiles.data[0].setIsExpanded(false);
                        expansionTiles.data[1].setIsExpanded(false);
                        expansionTiles.updateExpansionPanels();
                        ///Close the Sliding Up Panel
                        slidingUpPanelMetaData.setPanelIsClosed(true);
                        slidingUpPanelMetaData.getPanelController.close();
                      },
                    ),
                ],
              ),
        );
      },
    );
  }
}
