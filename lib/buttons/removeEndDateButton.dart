import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:communitytabs/data/expansionTileMetadata.dart';

///START COMMENT
///
/// RemoveEndDateButton:
///   This is the button that appears when you SWIPE LEFT on the End Date
///   and Time section of the form. Allows the user to delete the current
///   End Date and Time chosen, since some events don't  always have a
///   specified End Time.
///
/// Used by:
///   [secondaryActions] property of the [SlidableExpansionPanelHeader] Widget,
///   See [slideableExpansionHeader.dart].
///
/// Implements:
///   [ExpansionTiles] class in a [Consumer] widget,
///   see [expansionTileMetadata.dart].
///
///END COMMENT
class RemoveEndDateButton extends StatelessWidget {
  ///START COMMENT
  ///
  /// Drilling the index down...
  /// not to much boiler plate code involved
  ///
  /// Remember:
  /// Start Date/Time index == 0.
  /// End Date/Time: index == 1.
  ///
  ///END COMMENT
  final int index;
  RemoveEndDateButton({this.index});

  @override
  Widget build(BuildContext context) {
    return Consumer<ExpansionTiles>(
      builder: (context, expansionPanelState, child) {
        ///START COMMENT
        ///
        /// Only show the DELETE if the Expansion Panel is CLOSED and
        /// there is a Date Set, else just show a container.
        ///
        ///END COMMENT
        return expansionPanelState.data[index].getHeaderActionValue() ==
                    'End' &&
                !expansionPanelState.data[index].getIsExpanded()
            ? Container(
                color: Colors.red,
                child: Center(
                  child: IconButton(
                    icon: Icon(
                      Icons.delete,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      ///START COMMENT
                      ///
                      /// Closing the "Slidable".
                      ///
                      /// In order for Slidable.of(context) != null, the 'context' being referenced
                      /// must be the 'context' of the widget (or in this case the button) that is
                      /// closing the Slidable, NOT the PARENT widget's context.
                      ///
                      /// You can ensure the correct 'context' is being referenced by abstracting
                      /// the widget that will call a function of the Slidable (functions include but
                      /// are not limited to: open(), close(), dismiss(), etc.)
                      ///
                      ///END COMMENT
                      Slidable.of(context).close();

                      ///START COMMENT
                      ///
                      /// Delete the values ONLY from the End Date and End Time,
                      /// AND update the HeaderActionValue to 'Add End Time'
                      ///
                      /// Remember:
                      /// Start Date/Time index == 0
                      /// End Date/Time: index == 1
                      ///
                      /// ONLY remove the END Date/Time
                      ///
                      ///END COMMENT
                      if (index == 1) {
                        expansionPanelState.data[index].setHeaderDateValue('');
                        expansionPanelState.data[index].setHeaderTimeValue('');
                        expansionPanelState.data[index]
                            .setHeaderActionValue('Add End Time');
                      }

                      ///Notify the listeners to visually apply the change in date and time.
                      expansionPanelState.updateExpansionPanels();
                    },
                  ),
                ),
              )
            : Container();
      },
    );
  }
}
