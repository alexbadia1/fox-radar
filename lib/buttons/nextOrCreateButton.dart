import 'package:communitytabs/constants/marist_color_scheme.dart';
import 'package:communitytabs/data/categoryPanels.dart';
import 'package:communitytabs/data/club_event_data.dart';
import 'package:communitytabs/data/expansionTileMetadata.dart';
import 'package:communitytabs/data/slidingUpPanelMetadata.dart';
import 'package:communitytabs/services/database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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
    CategoryPanels _categoryPanelsModelAndController =
        Provider.of<CategoryPanels>(context);
    SlidingUpPanelMetaData slidingUpPanelMetaData =
        Provider.of<SlidingUpPanelMetaData>(context);
    DatabaseService _db = new DatabaseService();

    int militaryStartTime = 0;
    int militaryEndTime = 0;

    int _convertToTwentyFourHour({String time}) {
      int militaryTime;
      if (time.contains('PM')) {
        militaryTime = 1200 +
            int.parse(time
                .replaceAll(':', '')
                .replaceAll('PM', '')
                .replaceAll(' ', ''));
      } else
        militaryTime = int.parse(
            time.replaceAll(':', '').replaceAll('AM', '').replaceAll(' ', ''));

      return militaryTime;
    }

    militaryStartTime = _convertToTwentyFourHour(
        time: DateFormat.jm()
            .format(expansionTiles.data[0].getHeaderTimeValue()));
    if(expansionTiles.data[1].getHeaderTimeValue() != null)
    militaryEndTime = _convertToTwentyFourHour(
        time: DateFormat.jm()
            .format(expansionTiles.data[1].getHeaderTimeValue()));
    else militaryEndTime = -1;

    return Consumer<PageViewMetaData>(builder: (context, pageViewState, child) {
      return Container(
        child: pageViewState.formStepNum < 3
            ? Row(
                children: <Widget>[
                  GestureDetector(
                    child: Text(
                      'Next',
                      style: TextStyle(
                          fontSize: 16.0,
                          color: clubEventData.getTitle.isEmpty ||
                                  clubEventData.getHost.isEmpty ||
                                  clubEventData.getLocation.isEmpty ||
                                  (expansionTiles.data[1]
                                              .getHeaderTimeValue() ==
                                          null &&
                                      expansionTiles.data[1]
                                              .getHeaderDateValue() !=
                                          null) ||
                                  (expansionTiles.data[1]
                                              .getHeaderTimeValue() !=
                                          null &&
                                      expansionTiles.data[1]
                                              .getHeaderDateValue() ==
                                          null)
                              ? Colors.grey
                              : Colors.blueAccent),
                    ),
                    onTap: clubEventData.getTitle.isEmpty ||
                            clubEventData.getHost.isEmpty ||
                            clubEventData.getLocation.isEmpty ||
                            (expansionTiles.data[1].getHeaderTimeValue() ==
                                    null &&
                                expansionTiles.data[1].getHeaderDateValue() !=
                                    null) ||
                            (expansionTiles.data[1].getHeaderTimeValue() !=
                                    null &&
                                expansionTiles.data[1].getHeaderDateValue() ==
                                    null)
                        ? null
                        : () {
                            bool validData = true;

                            /// Check for a valid end date
                            if (expansionTiles.data[1].getHeaderDateValue() !=
                                    null &&
                                expansionTiles.data[1].getHeaderTimeValue() !=
                                    null) {
                              if (expansionTiles.data[1]
                                          .getHeaderDateValue()
                                          .difference(expansionTiles.data[0]
                                              .getHeaderDateValue())
                                          .inDays <
                                      0 &&
                                  expansionTiles.data[1]
                                          .getHeaderDateValue()
                                          .day !=
                                      expansionTiles.data[0]
                                          .getHeaderDateValue()
                                          .day) {
                                /// INVALID End Date is BEFORE the Start Date.
                                validData = false;

                                /// Show snack with text saying the END date is BEFORE the START date and is invalid.
                                final snackBar = formErrorSnackBar(context,
                                    'The end date can\'t come before the start date');
                                Scaffold.of(context).showSnackBar(snackBar);
                              } else if (expansionTiles.data[1]
                                          .getHeaderDateValue()
                                          .difference(expansionTiles.data[0]
                                              .getHeaderDateValue())
                                          .inDays ==
                                      0 &&
                                  expansionTiles.data[1]
                                          .getHeaderDateValue()
                                          .day ==
                                      expansionTiles.data[0]
                                          .getHeaderDateValue()
                                          .day) {
                                /// Same Dates, now check the times.
                                if (militaryEndTime <= militaryStartTime) {
                                  /// INVALID End Time HOUR is BEFORE the Start Time HOUR.
                                  validData = false;

                                  /// Show snack bar with text saying the END Time is BEFORE the START time and is invalid.
                                  final snackBar = formErrorSnackBar(context,
                                      'The event end time must be after event start time.');
                                  Scaffold.of(context).showSnackBar(snackBar);
                                }
                              }
                            }

                            if (validData) {
                              DateTime formattedEndDateAndTime;
                              DateTime formattedStartDateAndTime;

                              formattedStartDateAndTime = new DateTime(
                                  expansionTiles.data[0].getHeaderDateValue().year,
                                  expansionTiles.data[0].getHeaderDateValue().month,
                                  expansionTiles.data[0].getHeaderDateValue().day,
                                  expansionTiles.data[0].getHeaderTimeValue().hour,
                                  expansionTiles.data[0].getHeaderTimeValue().minute,
                                0, 0, 0
                              );

                              if(expansionTiles.data[1].getHeaderDateValue() != null) {
                                formattedEndDateAndTime = new DateTime(
                                    expansionTiles.data[1].getHeaderDateValue().year,
                                    expansionTiles.data[1].getHeaderDateValue().month,
                                    expansionTiles.data[1].getHeaderDateValue().day,
                                    expansionTiles.data[1].getHeaderTimeValue().hour,
                                    expansionTiles.data[1].getHeaderTimeValue().minute,
                                    0, 0, 0
                                );
                              }

                              /// Get the Start Date
                              clubEventData.setRawStartDateAndTime(formattedStartDateAndTime);

                              /// Get the End Date
                              if (expansionTiles.data[1].getHeaderDateValue() !=
                                  null) {
                                clubEventData.setRawEndDateAndTime(formattedEndDateAndTime);
                              } else clubEventData.setRawEndDateAndTime(null);


                              /// Avoid empty highlights in the list
                              List<String> tempList = [];
                              for (int i = 0;
                                  i < clubEventData.getHighlights.length;
                                  ++i) {
                                if (clubEventData.getHighlights[i]
                                    .trim()
                                    .isNotEmpty)
                                  tempList.add(clubEventData.getHighlights[i]);
                              }
                              clubEventData.setHighlights(tempList);

                              /// Get the category
                              clubEventData.setCategory(
                                  _categoryPanelsModelAndController
                                      .getCategoryPanels()[0]
                                      .categoryPicked);

                              print(clubEventData.toString());

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
                            }
                          },
                  ),
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
                    onTap: () async {
                      ///Close Keyboard
                      FocusScope.of(context).unfocus();

                      /// Submitting the form
                      print(clubEventData.toString());

                      var result = await _db.addEvent(newEvent: clubEventData);
                      print(result);

                      /// CLOSING THE EXPANSION PANELS
                      /// Resetting the cupertino time pickers' initial selected time.
                      expansionTiles.setTempStartTime(null);
                      expansionTiles.setTempEndTime(null);

                      /// Resetting the calender strip initial selected date.
                      expansionTiles.setTempStartDate(null);
                      expansionTiles.setTempEndDate(null);
                      expansionTiles.data[1].setHeaderDateValue(null);
                      expansionTiles.data[1].setHeaderTimeValue(null);
                      expansionTiles.data[1]
                          .setHeaderActionValue('Add End Time');

                      _categoryPanelsModelAndController
                          .getCategoryPanels()[0]
                          .categoryPicked = 'Academic';

                      /// Closing all expansion tiles
                      expansionTiles.data[0].setIsExpanded(false);
                      expansionTiles.data[1].setIsExpanded(false);
                      _categoryPanelsModelAndController
                          .getCategoryPanels()[0]
                          .isExpanded = false;
                      _categoryPanelsModelAndController
                          .updateCategoryPanelState();
                      expansionTiles.updateExpansionPanels();

                      /// Close sliding up panel and Reset the form step number
                      pageViewState.setFormStepNum(1);

                      /// Close the Sliding Up Panel.
                      slidingUpPanelMetaData.setPanelIsClosed(true);
                      slidingUpPanelMetaData.getPanelController.close();
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
