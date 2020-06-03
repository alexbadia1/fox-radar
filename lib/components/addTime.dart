import 'package:communitytabs/buttons/dateTimeButtons.dart';
import 'package:communitytabs/data/expansionTileMetadata.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'addEvent/dateLabel.dart';
import 'addEvent/timeLabel.dart';
import 'package:communitytabs/wrappers.dart';

class AddTime extends StatefulWidget {
  @override
  _AddTimeState createState() => _AddTimeState();
}

class _AddTimeState extends State<AddTime> {
  var _key1 = UniqueKey();

  @override
  Widget build(BuildContext context) {
    ExpansionTiles exPanelState = Provider.of<ExpansionTiles>(context);
    List<ExpansionPanel> tiles = [];

    ///Generate the Expansions Tiles, went with for loop to use the index to differentiate
    ///between tiles
    for (int index = 0; index < exPanelState.data.length; ++index) {
      tiles.add(
        ExpansionPanel(
          headerBuilder: (BuildContext context, bool isExpanded) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(child: DateLabel(index: index)),
                Expanded(child: SizedBox()),
                Container(child: TimeOfDayLabel(index: index)),
              ],
            );
          },
          body: Column(
            children: <Widget>[
              CustomCalenderStripWrapper(
                isExpanded: exPanelState.data[index].getIsExpanded(),
                index: index,
              ),
              DateAndTimeActions(index: index),
            ],
          ),
          isExpanded: exPanelState.data[index].getIsExpanded(),
          canTapOnHeader: !exPanelState.data[index].getIsExpanded(),
        ),
      );
    }
    return Container(
      width: MediaQuery.of(context).size.width * .9,
      child: ExpansionPanelList(
        key: this._key1,
        expansionCallback: (int index, bool isExpanded) {
          setState(() {
            exPanelState.data[index]
                .setIsExpanded(!exPanelState.data[index].getIsExpanded());
          });
        },
        children: tiles,
      ),
    );
  }
}
