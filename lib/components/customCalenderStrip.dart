import 'package:calendar_strip/calendar_strip.dart';
import 'package:communitytabs/constants/marist_color_scheme.dart';
import 'package:communitytabs/data/expansionTileMetadata.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CustomCalenderStrip extends StatefulWidget {
  final int index;
  CustomCalenderStrip({this.index, Key key}) : super(key: key);

  @override
  _CustomCalenderStripState createState() => _CustomCalenderStripState();
}

class _CustomCalenderStripState extends State<CustomCalenderStrip> {
  DateTime startDate = DateTime.now();
  DateTime endDate = DateTime.now().add(Duration(days: 365));
  DateTime selectedDate = DateTime.now();
  List<DateTime> markedDates = [];

  _monthNameWidget(monthName) {
    return Container(
      child: Text(
        monthName,
        style: TextStyle(
          fontSize: 17,
          fontWeight: FontWeight.w600,
          color: Colors.white,
          fontStyle: FontStyle.italic,
        ),
      ),
      padding: EdgeInsets.only(top: 8, bottom: 4),
    );
  }

  getMarkedIndicatorWidget() {
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      Container(
        margin: EdgeInsets.only(left: 1, right: 1),
        width: 7,
        height: 7,
        decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.red),
      ),
      Container(
        width: 7,
        height: 7,
        decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.blue),
      )
    ]);
  }

  dateTileBuilder(
      date, selectedDate, rowIndex, dayName, isDateMarked, isDateOutOfRange) {
    bool isSelectedDate = date.compareTo(selectedDate) == 0;
    Color fontColor = isDateOutOfRange ? cWhite25 : Colors.white;
    TextStyle normalStyle =
        TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: fontColor);
    TextStyle selectedStyle = TextStyle(
        fontSize: 16, fontWeight: FontWeight.w800, color: Colors.white);
    TextStyle dayNameStyle = TextStyle(fontSize: 13.5, color: fontColor);
    List<Widget> _children = [
      Text(dayName, style: dayNameStyle),
      Text(date.day.toString(),
          style: !isSelectedDate ? normalStyle : selectedStyle),
    ];

    if (isDateMarked == true) {
      _children.add(getMarkedIndicatorWidget());
    }

    return AnimatedContainer(
      duration: Duration(milliseconds: 150),
      alignment: Alignment.center,
      padding: EdgeInsets.only(top: 8, left: 5, right: 5, bottom: 5),
      decoration: BoxDecoration(
        color: !isSelectedDate ? Colors.transparent : Colors.white10,
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      child: Column(
        children: _children,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    ExpansionTiles _expansionTileState = Provider.of<ExpansionTiles>(context);

    if (this.widget.index == 0) {
      if (_expansionTileState.getTempStartDate() == null)
        _expansionTileState.setTempStartDate(
            _expansionTileState.data[this.widget.index].getHeaderDateValue() ??
                DateTime.now());
    } else {
      if (_expansionTileState.getTempEndDate() == null)
        _expansionTileState.setTempEndDate(
            _expansionTileState.data[this.widget.index].getHeaderDateValue() ??
                DateTime.now());
    }

    return Column(
      children: <Widget>[
        CalendarStrip(
          containerHeight: MediaQuery.of(context).size.height * .175,
          /// Depending on the Start Time make sure the start date is equal to t
          startDate: startDate,
          endDate: endDate,
          selectedDate: this.widget.index == 0
              ? _expansionTileState.getTempStartDate()
              : _expansionTileState.getTempEndDate(),
          onDateSelected: (data) {
            ///Set the temp Date to the selected date
            this.widget.index == 0
                ? _expansionTileState.setTempStartDate(data)
                : _expansionTileState.setTempEndDate(data);
          },
          dateTileBuilder: dateTileBuilder,
          iconColor: cWhite70,
          monthNameWidget: _monthNameWidget,
          markedDates: markedDates,
          containerDecoration: BoxDecoration(color: cBackground),
          addSwipeGesture: true,
        ),
      ],
    );
  }
}
