import 'package:calendar_strip/calendar_strip.dart';
import 'package:communitytabs/data/expansionTileMetadata.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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
  List<DateTime> markedDates = [DateTime.now().add(Duration(days: 4))];

  _monthNameWidget(monthName) {
    return Container(
      child: Text(
        monthName,
        style: TextStyle(
          fontSize: 17,
          fontWeight: FontWeight.w600,
          color: Colors.black87,
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
    Color fontColor = isDateOutOfRange ? Colors.black26 : Colors.black87;
    TextStyle normalStyle =
        TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: fontColor);
    TextStyle selectedStyle = TextStyle(
        fontSize: 16, fontWeight: FontWeight.w800, color: Colors.black87);
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
        color: !isSelectedDate ? Colors.transparent : Colors.black12,
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
    DateFormat _formatter = new DateFormat('E, MMMM d, y');
    this.widget.index == 0
        ? _expansionTileState
            .setTempStartDate(_formatter.format(DateTime.now()).toString())
        : _expansionTileState
            .setTempEndDate(_formatter.format(DateTime.now()).toString());
    return Column(
      children: <Widget>[
        CalendarStrip(
          containerHeight: MediaQuery.of(context).size.height * .175,
          startDate: startDate,
          endDate: endDate,
          onDateSelected: (data) {
            ///Set the temp Date to the selected date
            this.widget.index == 0
                ? _expansionTileState
                    .setTempStartDate(_formatter.format(data).toString())
                : _expansionTileState
                    .setTempEndDate(_formatter.format(data).toString());
          },
          dateTileBuilder: dateTileBuilder,
          iconColor: Colors.black87,
          monthNameWidget: _monthNameWidget,
          markedDates: markedDates,
          containerDecoration: BoxDecoration(color: Colors.white),
          addSwipeGesture: true,
        ),
      ],
    );
  }
}
