import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

typedef OnDateTimeChangedCallback = void Function(DateTime dateTime);

class TimePicker extends StatelessWidget {
  final DateTime initialDateTime;
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
          backgroundColor: Color.fromRGBO(24, 24, 24, 1.0),
          mode: CupertinoDatePickerMode.time,
          initialDateTime: initialDateTime,
          onDateTimeChanged: onDateTimeChangedCallback,
        ),
      ),
    );
  } // build
} // TimePicker