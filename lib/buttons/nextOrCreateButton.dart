import 'package:communitytabs/constants/marist_color_scheme.dart';
import 'package:communitytabs/data/categoryPanels.dart';
import 'package:communitytabs/data/club_event_data.dart';
import 'package:communitytabs/data/expansionTileMetadata.dart';
import 'package:communitytabs/data/selectedImageModel.dart';
import 'package:communitytabs/data/slidingUpPanelMetadata.dart';
import 'package:communitytabs/services/database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:communitytabs/data/pageViewMetadata.dart';

class NextOrCreateButton extends StatefulWidget {
  final VoidCallback uploadImageCallback;
  NextOrCreateButton({this.uploadImageCallback});


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
    SelectedImageModel selectedImageModel = Provider.of<SelectedImageModel>(context);
    DatabaseService _db = new DatabaseService();

    return Consumer<PageViewMetaData>(builder: (context, pageViewState, child) {
      bool noSelectedAnImage = false;
      if (pageViewState.formStepNum == 2) {
        if (selectedImageModel.getImageBytes() == null) {
          noSelectedAnImage = true;
        }
      }

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
                                          null) || noSelectedAnImage
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
                                    null) || noSelectedAnImage
                        ? null
                        : () async {
                            bool validData = true;
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

                            /// Check for a valid end date
                            if (formattedEndDateAndTime != null){
                              if (formattedEndDateAndTime.isBefore(formattedStartDateAndTime)) {
                                validData = false;
                                final snackBar = formErrorSnackBar(context,
                                    'The event cannot end before the event starts');
                                Scaffold.of(context).showSnackBar(snackBar);
                              }
                            }

                            if (validData) {

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


                              /// Grab the image bytes and contain/cover
                              if(pageViewState.formStepNum == 2) {
                                clubEventData.setImagePath(clubEventData.getTitle+ clubEventData.getHost + clubEventData.getLocation);
                                clubEventData.setImageFitCover(selectedImageModel.getCover());
                              }

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
                      var result;
                      var otherResult;
                      try {
                        this.widget.uploadImageCallback();
                        result = await _db.addEvent(newEvent: clubEventData);
                        otherResult = await _db.addEventToSearchable(newEvent: clubEventData);
                      } catch (e) {
                        result = 10;
                        otherResult = 10;
                        print(e);
                      }

                      /// If creating the event was successful close the add event, else don't.
                      if (result == null|| otherResult == null) {
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
                      } else {
                        final snackBar = formErrorSnackBar(context,
                            'Failed to upload new event!');
                        Scaffold.of(context).showSnackBar(snackBar);
                      }
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
