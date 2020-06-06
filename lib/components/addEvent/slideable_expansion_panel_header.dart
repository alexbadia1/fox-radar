import 'package:communitytabs/buttons/removeEndDateButton.dart';
import 'package:communitytabs/constants/marist_color_scheme.dart';
import 'package:communitytabs/data/expansionTileMetadata.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';
import 'package:communitytabs/components/addEvent/form_section_time_labels.dart';

class SlidableExpansionPanelHeader extends StatelessWidget {
  final int index;
  SlidableExpansionPanelHeader({this.index});
  var _mySlidableKey = UniqueKey();

  @override
  Widget build(BuildContext context) {
    double _textFormFieldHeight = MediaQuery.of(context).size.height * .07;
    ExpansionTiles exPanelState = Provider.of<ExpansionTiles>(context);
    return Slidable(
      key: _mySlidableKey,
      enabled: this.index == 1
          ? exPanelState.data[this.index].getHeaderActionValue() == 'End'
              ? !exPanelState.data[this.index].getIsExpanded()
              : false
          : false,
      direction: Axis.horizontal,
      actionPane: SlidableStrechActionPane(),
      actionExtentRatio: 0.25,
      child: Container(
        height: _textFormFieldHeight,
        decoration: BoxDecoration(
            color: cCard,
            border: Border(
                top: this.index == 0 ? cBorder : BorderSide(),
                bottom: cBorder)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            cLeftMarginSmall(context),
            Container(child: AddStartOrEndTimeLabel(index: this.index)),
            Expanded(child: SizedBox()),
            Row(
              children: <Widget>[
                Container(child: DateLabel(index: this.index)),
                Container(width: MediaQuery.of(context).size.width * .03225),
                Container(child: TimeOfDayLabel(index: this.index)),
              ],
            ),
            cRightMarginSmall(context),
          ],
        ),
      ),
      secondaryActions: <Widget>[RemoveEndDateButton(index: this.index)],
    );
  }
}
