import 'package:communitytabs/data/expansionTileMetadata.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'buttonLabels.dart';

class DateAndTimeActions extends StatelessWidget {
  /// Index used to track which expansion panel is being called.
  ///
  /// Start Time Expansion Panel: Index == 0.
  /// End Time Expansion Panel: Index == 1.
  final int index;

  DateAndTimeActions({this.index});

  @override
  Widget build(BuildContext context) {
    ExpansionTiles expansionTileState = Provider.of<ExpansionTiles>(context);

    void _closeExpansionPanel(int index) {
      ///Set expansionPanel's isExpanded variable to false.
      expansionTileState.data[index].setIsExpanded(false);
      index == 0
          ? expansionTileState.setShowAddStartTimeCalenderStrip(true)
          : expansionTileState.setShowAddEndTimeCalenderStrip(true);
      expansionTileState.updateExpansionPanels();
    }

    void _backToShowCalender(int index) {
      ///Set expansionPanel's showCalender variable to true.
      index == 0
          ? expansionTileState.setShowAddStartTimeCalenderStrip(true)
          : expansionTileState.setShowAddEndTimeCalenderStrip(true);
      expansionTileState.updateExpansionPanels();
    }

    void _continue(int index) {
      ///Set expansionPanel's showCalender variable to false.
      String newHeaderDateValue = '[Date Value]';
      if (index == 0) {
        ///Set the START TIME
        newHeaderDateValue = expansionTileState.getTempStartDate().toString();
        expansionTileState.setShowAddStartTimeCalenderStrip(false);
      } else {
        newHeaderDateValue = expansionTileState.getTempEndDate().toString();
        expansionTileState.setShowAddEndTimeCalenderStrip(false);
      }

      ///Update date label
      expansionTileState.data[index].setHeaderDateValue(newHeaderDateValue);
      expansionTileState.updateExpansionPanels();
    }

    /// Method will only be called when the cupertino Time Picker is showing.
    ///
    /// Should Submit the chosen time and close expansion panel.
    void _confirm({@required int index}) {
      String newHeaderTimeValue = '[Time Value]';

      /// Index used to track which expansion panel is being called.
      ///
      /// Start Time Expansion Panel: Index == 0.
      /// End Time Expansion Panel: Index == 1.
      ///
      /// Must set showCalenderStrip boolean to TRUE, so the calender strip will
      /// appear when the user tries to open the expansion panel again. If
      /// showCalenderStrip boolean is FALSE, the cupertino time picker will show.
      if (index == 0) {
        expansionTileState.setShowAddStartTimeCalenderStrip(true);
        newHeaderTimeValue = expansionTileState.getTempStartTime().toString();
      } else {
        expansionTileState.setShowAddEndTimeCalenderStrip(true);
        newHeaderTimeValue = expansionTileState.getTempEndTime().toString();
      }

      /// HeaderTimeValue is used to set the expansion panel's time label.
      ///
      /// Updating the HeaderTimeValue with the time picked by the user.
      /// Note the time picked by the user is stored as a temp variable in
      /// the ExpansionTiles class.
      expansionTileState.data[index].setHeaderTimeValue(newHeaderTimeValue);

      /// IsExpanded is an instance variable of the item used to generate the
      /// Expansion Panel from the expansion panel list.
      ///
      /// Is Expanded is used to control whether the expansion panel should be
      /// open or not with a boolean value.
      ///
      /// Expansion Panel is OPEN when IsExpanded == true.
      /// Expansion Panel is CLOSED when IsExpanded == false.
      ///
      /// Setting the IsExpanded property to false in order to close the
      /// expansion panel upon a notifyListeners() call.
      expansionTileState.data[index].setIsExpanded(false);

      ///Actually implements the changes in data to effect the view of each widget
      ///effectively updating the widget with these changes.
      ///
      ///This step should be last as it is a notifyListeners() call.
      expansionTileState.updateExpansionPanels();
    } //confirm

    return Row(
      children: <Widget>[
        FlatButton(
          child: CancelOrBackButtonLabel(index: this.index),
          onPressed: () {
            bool tempBool = this.index == 0
                ? expansionTileState.getShowAddStartTimeCalenderStrip()
                : expansionTileState.getShowAddEndTimeCalenderStrip();
            tempBool
                ? _closeExpansionPanel(this.index)
                : _backToShowCalender(this.index);
          },
        ),
        FlatButton(
          child: ContinueOrConfirmButtonLabel(index: this.index),
          onPressed: () {
            bool tempBool = this.index == 0
                ? expansionTileState.getShowAddStartTimeCalenderStrip()
                : expansionTileState.getShowAddEndTimeCalenderStrip();
            tempBool ? _continue(this.index) : _confirm(index: this.index);
          },
        ),
      ],
    );
  }
}
