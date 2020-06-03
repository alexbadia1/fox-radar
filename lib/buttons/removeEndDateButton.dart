import 'package:communitytabs/data/expansionTileMetadata.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RemoveEndDateButton extends StatelessWidget {
  final int index;
  RemoveEndDateButton({this.index});
  @override
  Widget build(BuildContext context) {
    return Consumer<ExpansionTiles>(
        builder: (context, expansionPanelState, child) {
          return expansionPanelState.data[index].getHeaderActionValue() == 'End' ? IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {
              print('Clearing Header Date and Time Values');
              print('This is where I call update to notify listeners');
            },
          ) : Container();
        });
  }
}