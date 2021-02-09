import 'package:communitytabs/data/categoryPanels.dart';
import 'package:communitytabs/data/expansionTileMetadata.dart';
import 'package:flutter/cupertino.dart';
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
    // SlidingUpPanelMetaData slidingUpPanelMetaData =
    //     Provider.of<SlidingUpPanelMetaData>(context);
    ExpansionTiles expansionTiles = Provider.of<ExpansionTiles>(context);
    CategoryPanels categoryPanels = Provider.of<CategoryPanels>(context);
    // ClubEventData clubEventData = Provider.of<ClubEventData>(context);

    return Consumer<PageViewMetaData>(
      builder: (context, pageViewState, child) {
        return Container(
          child: pageViewState.formStepNum > 1
              ? Row(
                  children: <Widget>[
                    SizedBox(
                      width: MediaQuery.of(context).size.width * .03,
                    ),
                    GestureDetector(
                      child: Icon(Icons.chevron_left, color: kHavenLightGray),
                      onTap: () async {
                        ///Close Keyboard
                        FocusScope.of(context).unfocus();

                        ///Update what form step number We're on
                        pageViewState
                            .setFormStepNum(pageViewState.formStepNum - 1);

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
                    SizedBox(
                      width: MediaQuery.of(context).size.width * .03,
                    ),
                    GestureDetector(
                        child: Icon(Icons.close, color: kHavenLightGray),
                        onTap: () {
                          /// Close Keyboard
                          FocusScope.of(context).unfocus();

                          /// Check if the Start Date was changed

                          /// Check if there are any highlights
                          int i = 0;
                          bool hasHighlights = false;
                          // while (i < clubEventData.getHighlights.length &&
                          //     !hasHighlights) {
                          //   if (clubEventData.getHighlights[i]
                          //       .trim()
                          //       .isNotEmpty)
                          //     hasHighlights = true;
                          //   else
                          //     i++;
                          // }

                          bool diffDay = expansionTiles.originalStartDateAndTime
                                      .difference(expansionTiles.data[0]
                                          .getHeaderDateValue())
                                      .inDays !=
                                  0 ||
                              expansionTiles.originalStartDateAndTime.day !=
                                  expansionTiles.data[0]
                                      .getHeaderDateValue()
                                      .day;
                          bool diffMin = (expansionTiles
                                      .originalStartDateAndTime
                                      .difference(expansionTiles.data[0]
                                          .getHeaderTimeValue())
                                      .inMinutes !=
                                  0 ||
                              expansionTiles.originalStartDateAndTime.minute !=
                                  expansionTiles.data[0]
                                      .getHeaderTimeValue()
                                      .minute ||
                              expansionTiles.originalStartDateAndTime.hour !=
                                  expansionTiles.data[0]
                                      .getHeaderTimeValue()
                                      .hour);
                          bool dateAndTimeEdited = (diffDay || diffMin);

                          // if (clubEventData.getTitle.trim().isNotEmpty ||
                          //     clubEventData.getHost.trim().isNotEmpty ||
                          //     clubEventData.getLocation.trim().isNotEmpty ||
                          //     clubEventData.getRoom.trim().isNotEmpty ||
                          //     clubEventData.getSummary.trim().isNotEmpty ||
                          //     expansionTiles.data[1].getHeaderDateValue() !=
                          //         null ||
                          //     expansionTiles.data[1].getHeaderTimeValue() !=
                          //         null ||
                          //     hasHighlights ||
                          //     categoryPanels
                          //             .getCategoryPanels()[0]
                          //             .categoryPicked !=
                          //         categoryPanels
                          //             .getCategoryPanels()[0]
                          //             .defaultCategoryPicked ||
                          //     dateAndTimeEdited) {
                          //   /// Show bottom sheet to confirm discarding the form
                          //   showModalBottomSheet(
                          //     context: context,
                          //     builder: (context) => Container(
                          //       color: cDialogueBackground,
                          //       height:
                          //           MediaQuery.of(context).size.height * .275,
                          //       child: Row(
                          //         children: <Widget>[
                          //           Expanded(
                          //             flex: 1,
                          //             child: SizedBox(),
                          //           ),
                          //           Expanded(
                          //             flex: 30,
                          //             child: Container(
                          //               child: Column(
                          //                 mainAxisAlignment:
                          //                     MainAxisAlignment.spaceAround,
                          //                 children: <Widget>[
                          //                   Container(
                          //                     child: Text(
                          //                         'Are you sure you want to discard this event?',
                          //                         style: TextStyle(
                          //                             color: cWhite100)),
                          //                     alignment: Alignment.centerLeft,
                          //                   ),
                          //                   Container(
                          //                     alignment: Alignment.centerLeft,
                          //                     child: InkWell(
                          //                       child: Text('Discard',
                          //                           style: TextStyle(
                          //                               color: cWhite100)),
                          //                       onTap: () {
                          //                         /// Resetting the cupertino time pickers' initial selected time.
                          //                         expansionTiles
                          //                             .setTempStartTime(null);
                          //                         expansionTiles
                          //                             .setTempEndTime(null);
                          //
                          //                         /// Resetting the calender strip initial selected date.
                          //                         expansionTiles
                          //                             .setTempStartDate(null);
                          //                         expansionTiles
                          //                             .setTempEndDate(null);
                          //                         expansionTiles.data[1]
                          //                             .setHeaderDateValue(null);
                          //                         expansionTiles.data[1]
                          //                             .setHeaderTimeValue(null);
                          //                         expansionTiles.data[1]
                          //                             .setHeaderActionValue(
                          //                                 'Add End Time');
                          //                         categoryPanels
                          //                                 .getCategoryPanels()[0]
                          //                                 .categoryPicked =
                          //                             'Academic';
                          //
                          //                         /// Closing all expansion tiles
                          //                         expansionTiles.data[0]
                          //                             .setIsExpanded(false);
                          //                         expansionTiles.data[1]
                          //                             .setIsExpanded(false);
                          //                         categoryPanels
                          //                             .getCategoryPanels()[0]
                          //                             .isExpanded = false;
                          //                         categoryPanels
                          //                             .updateCategoryPanelState();
                          //                         expansionTiles
                          //                             .updateExpansionPanels();
                          //
                          //                         /// Dismiss the dialogue
                          //                         Navigator.of(context).pop();
                          //
                          //                         /// Close the Sliding Up Panel.
                          //                         slidingUpPanelMetaData
                          //                             .setPanelIsClosed(true);
                          //                         slidingUpPanelMetaData
                          //                             .getPanelController
                          //                             .close();
                          //                       },
                          //                     ),
                          //                   ),
                          //                   Container(
                          //                     alignment: Alignment.centerLeft,
                          //                     child: InkWell(
                          //                       child: Text(
                          //                         'Keep Editing',
                          //                         style: TextStyle(
                          //                             color: cWhite100),
                          //                       ),
                          //                       onTap: () {
                          //                         /// Dismiss the dialogue
                          //                         Navigator.of(context).pop();
                          //                       },
                          //                     ),
                          //                   ),
                          //                 ],
                          //               ),
                          //             ),
                          //           ),
                          //         ],
                          //       ),
                          //     ),
                          //   );
                          // } else {
                          //   /// Resetting the cupertino time pickers' initial selected time.
                          //   expansionTiles.setTempStartTime(null);
                          //   expansionTiles.setTempEndTime(null);
                          //
                          //   /// Resetting the calender strip initial selected date.
                          //   expansionTiles.setTempStartDate(null);
                          //   expansionTiles.setTempEndDate(null);
                          //   expansionTiles.data[1].setHeaderDateValue(null);
                          //   expansionTiles.data[1].setHeaderTimeValue(null);
                          //   expansionTiles.data[1]
                          //       .setHeaderActionValue('Add End Time');
                          //
                          //   categoryPanels
                          //       .getCategoryPanels()[0]
                          //       .categoryPicked = 'Academic';
                          //
                          //   /// Closing all expansion tiles
                          //   expansionTiles.data[0].setIsExpanded(false);
                          //   expansionTiles.data[1].setIsExpanded(false);
                          //   categoryPanels.getCategoryPanels()[0].isExpanded =
                          //       false;
                          //   categoryPanels.updateCategoryPanelState();
                          //   expansionTiles.updateExpansionPanels();
                          //
                          //   /// Close the Sliding Up Panel.
                          //   slidingUpPanelMetaData.setPanelIsClosed(true);
                          //   slidingUpPanelMetaData.getPanelController.close();
                          // }
                        }),
                  ],
                ),
        );
      },
    );
  }
}
