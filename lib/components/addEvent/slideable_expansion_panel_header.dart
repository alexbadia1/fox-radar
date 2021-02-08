import 'package:communitytabs/buttons/removeEndDateButton.dart';
import 'package:communitytabs/constants/marist_color_scheme.dart';
import 'package:communitytabs/data/expansionTileMetadata.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:communitytabs/logic/blocs/blocs.dart';

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
            //Container(child: AddStartOrEndTimeLabel(index: this.index)),
            Expanded(child: SizedBox()),
            Row(
              children: <Widget>[
                BlocListener<CreateEventBloc, CreateEventState>(
                  /// Only rebuild when the event date changes
                  listenWhen: (previousState, currentState) {

                    /// Null check on previous state, since the End Date is optional
                    if (previousState.eventModel.getRawStartDateAndTime == null &&
                        currentState.eventModel.getRawStartDateAndTime != null) {
                      return true;
                    }// if

                    /// Null check on current state, since the End Date is optional
                    else if (previousState.eventModel.getRawStartDateAndTime != null &&
                        currentState.eventModel.getRawStartDateAndTime == null) {
                      return true;
                    }// else-if

                    return DateFormat('E, MMMM d, y').format(previousState.eventModel.getRawStartDateAndTime) !=
                        DateFormat('E, MMMM d, y').format(currentState.eventModel.getRawStartDateAndTime);
                  }, // ListenWhen
                  listener: (BuildContext context, state) {
                    //return DateLabel(rawDate: state.eventModel.getRawStartDateAndTime,);
                  },
                ),
                Container(width: MediaQuery.of(context).size.width * .03225),
                //Container(child: TimeOfDayLabel(index: this.index)),
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
