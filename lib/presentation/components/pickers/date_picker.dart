import 'package:flutter/material.dart';
import 'package:communitytabs/presentation/presentation.dart';
import 'package:calender_strip_fixed/calendar_strip.dart';

typedef OnDateSelectedCallback = void Function(DateTime dateTime);
typedef UpdateBlocCallback = void Function(DateTime dateTime);

class DatePicker extends StatefulWidget {
  /// Sets the initial date the Date picker starts on.
  final DateTime initialSelectedDate;

  /// [Deprecated], replaced by "confirm"" and "cancel" buttons.
  ///
  /// This function is called every time a
  /// new Date is selected from the Date Picker.
  ///
  /// When this function is called, you should add an event
  /// to the Bloc managing the Date, to update it as the user chooses.
  final UpdateBlocCallback updateBlocCallback;

  /// General purpose function triggered whenever a new date is selected.
  final OnDateSelectedCallback onDateSelectedCallback;

  const DatePicker(
      {Key key,
      @required this.initialSelectedDate,
      @required this.onDateSelectedCallback,
      this.updateBlocCallback})
      : super(key: key);
  @override
  _DatePickerState createState() => _DatePickerState();
} // DatePicker

class _DatePickerState extends State<DatePicker> {
  /// Start date should be set when the user opens the panel. However, you
  /// are able to change the start date using add or subtract functions:
  ///   - DateTime.now().subtract(Duration(days: 365));
  DateTime startDate = DateTime.now();

  /// The latest end Date is a year from [DateTime.now]
  DateTime endDate = DateTime.now().add(Duration(days: 365));

  /// Default to todays date [DateTime.now]
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
      padding: EdgeInsets.only(top: 8, bottom: 24),
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
    // Remember to update the start date, every time the date picker is constructed,
    // Since a user can technically open this widget at 11:59pm and then open it again at 12:00am
    // and the day must update then.
    //
    // Or let the user choose a previous date, maybe the event started and they forgot to create it?
    // if (this.widget.initialSelectedDate != null) {
    //   this.widget?.updateBlocCallback(this.widget.initialSelectedDate);
    // }// if

    return Column(
      children: <Widget>[
        Container(
          color: Color.fromRGBO(33, 33, 33, 1.0),
          height: MediaQuery.of(context).size.height * .0225,
        ),
        CalendarStrip(
          containerHeight: MediaQuery.of(context).size.height * .175,
          startDate: startDate,
          endDate: endDate,
          selectedDate: this.widget.initialSelectedDate,
          onDateSelected: (dateTime) {
            this.widget.onDateSelectedCallback(dateTime);
          },
          dateTileBuilder: dateTileBuilder,
          iconColor: cWhite70,
          monthNameWidget: _monthNameWidget,
          markedDates: markedDates,
          containerDecoration: BoxDecoration(
            color: Color.fromRGBO(33, 33, 33, 1.0),
          ),
          addSwipeGesture: true,
        ),
      ],
    );
  }// build
}// _DatePickerState
