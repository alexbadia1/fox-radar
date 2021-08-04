import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';


typedef OnDateTimeChangedCallback = void Function(DateTime dateTime);

class TimePicker extends StatelessWidget {
  /// Sets the initial time the TimePicker starts on.
  final DateTime initialDateTime;

  /// Function triggered every time a new time is selected.
  final OnDateTimeChangedCallback onDateTimeChangedCallback;

  const TimePicker({
    Key key,
    @required this.initialDateTime,
    @required this.onDateTimeChangedCallback,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * .175,
      child: CupertinoTheme(
        data: CupertinoThemeData(
          textTheme: CupertinoTextThemeData(
            dateTimePickerTextStyle: TextStyle(color: Colors.white),
          ),
        ),
        child: CupertinoDatePicker(
          backgroundColor: Colors.transparent,
          mode: CupertinoDatePickerMode.time,
          initialDateTime: initialDateTime,
          onDateTimeChanged: onDateTimeChangedCallback,
        ),
      ),
    );
  } // build
} // TimePicker
