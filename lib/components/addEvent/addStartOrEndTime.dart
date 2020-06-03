import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:communitytabs/data/expansionTileMetadata.dart';

class AddStartOrEndTime extends StatelessWidget {
  final int index;
  AddStartOrEndTime({this.index});
  @override
  Widget build(BuildContext context) {
    return Consumer<ExpansionTiles>(
        builder: (context, expansionPanelState, child) {
      return Text(expansionPanelState.data[this.index].getHeaderActionValue());
    });
  }
}
