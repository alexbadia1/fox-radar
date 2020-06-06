import 'package:communitytabs/constants/marist_color_scheme.dart';
import 'package:communitytabs/data/expansionTileMetadata.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class CancelOrBackButtonLabel extends StatelessWidget {
  final int index;
  CancelOrBackButtonLabel({this.index});
  @override
  Widget build(BuildContext context) {
    ExpansionTiles expansionTileState = Provider.of<ExpansionTiles>(context);
    return this.index == 0
        ? expansionTileState.getShowAddStartTimeCalenderStrip()
        ? Text('Cancel', style: TextStyle(color: cWhite100))
        : Text('Back', style: TextStyle(color: cWhite100))
        : expansionTileState.getShowAddEndTimeCalenderStrip()
        ? Text('Cancel', style: TextStyle(color: cWhite100))
        : Text('Back', style: TextStyle(color: cWhite100));
  }
}

class ContinueOrConfirmButtonLabel extends StatelessWidget {
  final int index;
  ContinueOrConfirmButtonLabel({this.index});
  @override
  Widget build(BuildContext context) {
    ExpansionTiles expansionTileState = Provider.of<ExpansionTiles>(context);
    return this.index == 0
        ? expansionTileState.getShowAddStartTimeCalenderStrip()
        ? Text('Continue', style: TextStyle(color: cBlue))
        : Text('Confirm', style: TextStyle(color: cBlue))
        : expansionTileState.getShowAddEndTimeCalenderStrip()
        ? Text('Continue', style: TextStyle(color: cBlue))
        : Text('Confirm', style: TextStyle(color: cBlue));
  }
}
