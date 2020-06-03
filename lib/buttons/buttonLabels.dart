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
        ? Text('Cancel')
        : Text('Back')
        : expansionTileState.getShowAddEndTimeCalenderStrip()
        ? Text('Cancel')
        : Text('Back');
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
        ? Text('Continue')
        : Text('Confirm')
        : expansionTileState.getShowAddEndTimeCalenderStrip()
        ? Text('Continue')
        : Text('Confirm');
  }
}
