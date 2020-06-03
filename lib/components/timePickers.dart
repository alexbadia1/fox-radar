import 'package:flutter/material.dart';

class StartTimePicker extends StatefulWidget {
  @override
  _StartTimePickerState createState() => _StartTimePickerState();
}

class _StartTimePickerState extends State<StartTimePicker> {
  String _startTime = '7:00 PM';
  Future<Null> _pickTime(BuildContext context) async {
    final MaterialLocalizations localizations =
        MaterialLocalizations.of(context);
    final _time =
        await showTimePicker(context: context, initialTime: TimeOfDay.now());
    final String formattedTimeOfDay = localizations.formatTimeOfDay(_time);
    setState(() {
      if (_time != null) {
        _startTime = formattedTimeOfDay;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * .45,
      child: Column(
        children: [
          ExpansionTile(
            title: Text('Start Time'),
            children: <Widget>[
              Container(
                height: MediaQuery.of(context).size.height * .0525,
                width: MediaQuery.of(context).size.width * .45,
                child: GestureDetector(
                  onTap: () {
                    _pickTime(context);
                  },
                  child: Row(
                    children: <Widget>[
                      Expanded(flex: 2, child: Icon(Icons.access_time)),
                      Expanded(
                        flex: 5,
                        child: InkWell(
                          child: RichText(
                            text: TextSpan(
                              style: TextStyle(color: Colors.black),
                              children: [
                                TextSpan(text: 'End: ', style: TextStyle(fontWeight: FontWeight.bold)),
                                TextSpan(text: _startTime) ]
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}

class EndTimePicker extends StatefulWidget {
  @override
  _EndTimePickerState createState() => _EndTimePickerState();
}

class _EndTimePickerState extends State<EndTimePicker> {
  String _endTime = '7:00 PM';

  Future<Null> _pickTime(BuildContext context) async {
    final MaterialLocalizations localizations =
        MaterialLocalizations.of(context);
    final _time =
        await showTimePicker(context: context, initialTime: TimeOfDay.now());
    final String formattedTimeOfDay = localizations.formatTimeOfDay(_time);
    setState(() {
      if (_time != null) {
        _endTime = formattedTimeOfDay;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.blueAccent,
          borderRadius: BorderRadius.all(Radius.circular(20))),
//      height: MediaQuery.of(context).size.height * .0525,
      width: MediaQuery.of(context).size.width * .45,
      child: GestureDetector(
        onTap: () {
          print('Catgeory Pressed');
        },
        child: Row(
          children: <Widget>[
            Expanded(flex: 2, child: Icon(Icons.access_time)),
            Expanded(
              flex: 5,
              child: InkWell(
                child: RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                          text: 'End: ',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      TextSpan(text: _endTime)
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
