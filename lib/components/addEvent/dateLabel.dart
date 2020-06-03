import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:communitytabs/data/expansionTileMetadata.dart';

class DateLabel extends StatelessWidget {
  final int index;
  DateLabel({this.index});
  @override
  Widget build(BuildContext context) {
    return Consumer<ExpansionTiles>(
        builder: (context, expansionPanelState, child) {
          return Text(expansionPanelState.data[this.index].getHeaderDateValue());
        });
  }
}