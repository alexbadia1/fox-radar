import 'package:communitytabs/data/club_event_data.dart';
import 'package:communitytabs/data/expansionTileMetadata.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:communitytabs/data/pageViewMetadata.dart';

class NextOrCreateButton extends StatefulWidget {
  @override
  _NextOrCreateButtonState createState() => _NextOrCreateButtonState();
}

class _NextOrCreateButtonState extends State<NextOrCreateButton> {
  @override
  Widget build(BuildContext context) {
    ExpansionTiles expansionTiles = Provider.of<ExpansionTiles>(context);
    ClubEventData clubEventData = Provider.of<ClubEventData>(context);
    return Consumer<PageViewMetaData>(builder: (context, pageViewState, child) {
      return Container(
        child: pageViewState.formStepNum < 3
            ? Row(
                children: <Widget>[
                  GestureDetector(
                      child: Text(
                        'Next',
                        style:
                            TextStyle(fontSize: 16.0, color: clubEventData.getTitle.isEmpty || clubEventData.getHost.isEmpty || clubEventData.getLocation.isEmpty ||
                                (expansionTiles.data[1].getHeaderTimeValue() == '' && expansionTiles.data[1].getHeaderDateValue() != '') ||
                                (expansionTiles.data[1].getHeaderTimeValue() != '' && expansionTiles.data[1].getHeaderDateValue() == '')
                                ? Colors.grey
                                : Colors.blueAccent),
                      ),
                      onTap: clubEventData.getTitle.isEmpty || clubEventData.getHost.isEmpty || clubEventData.getLocation.isEmpty ||
                          (expansionTiles.data[1].getHeaderTimeValue() == '' && expansionTiles.data[1].getHeaderDateValue() != '') ||
                          (expansionTiles.data[1].getHeaderTimeValue() != '' && expansionTiles.data[1].getHeaderDateValue() == '')
                          ? null
                          : () {
                              ///Close Keyboard
                              FocusScope.of(context).unfocus();

                              ///Close Expansion Panels
                              expansionTiles.data[0].setIsExpanded(false);
                              expansionTiles.data[1].setIsExpanded(false);
                              expansionTiles.updateExpansionPanels();

                              ///Update what form step number we're on
                              pageViewState.setFormStepNum(
                                  pageViewState.formStepNum + 1);

                              ///"Navigate" to the next Page View
                              pageViewState.pageViewController.animateToPage(
                                  pageViewState.formStepNum - 1,
                                  duration: const Duration(milliseconds: 400),
                                  curve: Curves.easeIn);
                            }),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * .04,
                  )
                ],
              )
            : Row(
                children: <Widget>[
                  GestureDetector(
                    child: Text(
                      'Create',
                      style:
                          TextStyle(fontSize: 16.0, color: Colors.blueAccent),
                    ),
                    onTap: () {
                      ///Close Keyboard
                      FocusScope.of(context).unfocus();

                      ///TODO: Submit the Event Form
                    },
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * .04,
                  )
                ],
              ),
      );
    });
  }
}
