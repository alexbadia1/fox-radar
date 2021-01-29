import 'package:communitytabs/constants/marist_color_scheme.dart';
import 'package:communitytabs/data/expansionTileMetadata.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'components/customCalenderStrip.dart';

class CustomCalenderStripWrapper extends StatefulWidget {
  final int index;
  final bool isExpanded;
  CustomCalenderStripWrapper({this.isExpanded, this.index});
  @override
  _CustomCalenderStripWrapperState createState() =>
      _CustomCalenderStripWrapperState();
}

class _CustomCalenderStripWrapperState
    extends State<CustomCalenderStripWrapper> {
  @override
  Widget build(BuildContext context) {
    return this.widget.isExpanded
        ? DateOrTimePicker(index: this.widget.index)
        : Container(
            color: cBackground,
            height: MediaQuery.of(context).size.height * .175,
            width: double.infinity,
          );
  }
}

class DateOrTimePicker extends StatelessWidget {
  var _key = UniqueKey();
  final int index;
  DateOrTimePicker({this.index});
  @override
  Widget build(BuildContext context) {
    return Consumer<ExpansionTiles>(
      builder: (context, calenderPickerState, child) {
        if (index == 0) {
          if (calenderPickerState.getTempStartTime() == null)
            calenderPickerState.setTempStartTime(
                calenderPickerState.data[index].getHeaderTimeValue() ??
                    DateTime.now());
        } else {
          if (calenderPickerState.getTempEndTime() == null)
            calenderPickerState.setTempEndTime(
                calenderPickerState.data[index].getHeaderTimeValue() ??
                    DateTime.now());
        }
        return index == 0
            ? calenderPickerState.getShowAddStartTimeCalenderStrip()
                ? CustomCalenderStrip(index: index, key: this._key)
                : Container(
                    height: MediaQuery.of(context).size.height * .175,
                    child: CupertinoTheme(
                      data: CupertinoThemeData(
                          textTheme: CupertinoTextThemeData(
                              dateTimePickerTextStyle:
                                  TextStyle(color: Colors.white))),
                      child: CupertinoDatePicker(
                        backgroundColor: Color.fromRGBO(0, 0, 0, .9325),
                        mode: CupertinoDatePickerMode.time,
                        initialDateTime: calenderPickerState.getTempStartTime(),
                        onDateTimeChanged: (value) {
                          ///Set the temp start date
                          ///
                          /// Later to be used by the Confirm Button
                          calenderPickerState.setTempStartTime(value);
                        },
                      ),
                    ),
                  )
            : calenderPickerState.getShowAddEndTimeCalenderStrip()
                ? CustomCalenderStrip(index: index, key: this._key)
                : Container(
                    height: MediaQuery.of(context).size.height * .175,
                    child: CupertinoTheme(
                      data: CupertinoThemeData(
                          textTheme: CupertinoTextThemeData(
                              dateTimePickerTextStyle:
                                  TextStyle(color: Colors.white))),
                      child: CupertinoDatePicker(
                        backgroundColor: Color.fromRGBO(0, 0, 0, .9325),
                        mode: CupertinoDatePickerMode.time,
                        initialDateTime: calenderPickerState.getTempEndTime(),
                        onDateTimeChanged: (value) {
                          ///Set the temp end date
                          ///
                          /// Later to be used by the Confirm Button
                          calenderPickerState.setTempEndTime(value);
                        },
                      ),
                    ),
                  );
      },
    );
  }
}
