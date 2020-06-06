import 'package:communitytabs/constants/marist_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:communitytabs/data/expansionTileMetadata.dart';

class AddStartOrEndTimeLabel extends StatelessWidget {
  final int index;
  AddStartOrEndTimeLabel({this.index});
  @override
  Widget build(BuildContext context) {
    return Consumer<ExpansionTiles>(
        builder: (context, expansionPanelState, child) {
          return Text(expansionPanelState.data[this.index].getHeaderActionValue(),
            style: TextStyle(
                fontSize: expansionPanelState.data[index].getHeaderActionValue() == 'Add End Time' ? 12.0 : 16.0,
                color: expansionPanelState.data[index].getHeaderActionValue() == 'Add End Time' ? cWhite65 : cWhite100),
          );
        });
  }
}

class TimeOfDayLabel extends StatelessWidget {
  final int index;
  TimeOfDayLabel({this.index});
  @override
  Widget build(BuildContext context) {
    return Consumer<ExpansionTiles>(
        builder: (context, expansionPanelState, child) {
          return Text(expansionPanelState.data[this.index].getHeaderTimeValue(), style: TextStyle(color: cWhite100));
        });
  }
}

class DateLabel extends StatelessWidget {
  final int index;
  DateLabel({this.index});
  @override
  Widget build(BuildContext context) {
    return Consumer<ExpansionTiles>(
        builder: (context, expansionPanelState, child) {
          return Text(expansionPanelState.data[this.index].getHeaderDateValue(), style: TextStyle(color: cWhite100));
        });
  }
}