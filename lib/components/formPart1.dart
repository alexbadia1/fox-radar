import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:communitytabs/constants/marist_color_scheme.dart';
import 'package:communitytabs/data/club_event_data.dart';

class FormPart1 extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  final ClubEventData newEvent;
  FormPart1({@required this.formKey, @required this.newEvent});

  @override
  _FormPart1State createState() => _FormPart1State();
}

class _FormPart1State extends State<FormPart1> {
  @override
  Widget build(BuildContext context) {
    double pWidth = MediaQuery.of(context).size.width;
    return Form(
      key: this.widget.formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          SizedBox(height: MediaQuery.of(context).size.height * .02),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              StartTimePicker(),
              EndTimePicker(),
            ],
          ),
          SizedBox(height: MediaQuery.of(context).size.height * .02),
          Container(
            width: pWidth * .9,
            child: TextFormField(
              initialValue: this.widget.newEvent.getTitle,
              textInputAction: TextInputAction.done,
              decoration: customTextField.copyWith(
                  labelText: 'Event Title'),
              onChanged: (value){this.widget.newEvent.setTitle(value);},
              validator: (String value) {
                value = value.trim();
                return value.isEmpty
                    ? '\u26A0 Don\'t forget the event of the Title!'
                    : null;
              },
            ),
          ),

          Container(
            width: pWidth * .9,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Expanded(
                  flex: 3,
                  child: TextFormField(
                    initialValue: this.widget.newEvent.getRoom,
                    textInputAction: TextInputAction.done,
                    decoration: customTextField.copyWith(
                        labelText: 'Room'),
                    onChanged: (value){this.widget.newEvent.setRoom(value);},
                  ),
                ),
                Expanded(child: SizedBox()),
                Expanded(
                  flex: 7,
                  child: TextFormField(
                    initialValue: this.widget.newEvent.getLocation,
                    textInputAction: TextInputAction.done,
                    decoration: customTextField.copyWith(
                        labelText: 'Location'),
                    onChanged: (value){this.widget.newEvent.setLocation(value);},
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class StartTimePicker extends StatefulWidget {
  @override
  _StartTimePickerState createState() => _StartTimePickerState();
}

class _StartTimePickerState extends State<StartTimePicker> {
  @override
  Widget build(BuildContext context) {
    String _startTime = '7:00 PM';
    return Container(
      height: MediaQuery.of(context).size.height * .0525,
      width: MediaQuery.of(context).size.width * .45,
      decoration: BoxDecoration(
          color: Colors.blueAccent,
          borderRadius: BorderRadius.all(Radius.circular(20))),
      child: GestureDetector(
        onTap: () {
          print('Location Pressed');
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
                          text: 'Start: ',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      TextSpan(text: _startTime)
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

class EndTimePicker extends StatefulWidget {
  @override
  _EndTimePickerState createState() => _EndTimePickerState();
}

class _EndTimePickerState extends State<EndTimePicker> {
  @override
  Widget build(BuildContext context) {
    String _endTime = '10:00 PM';
    return Container(
      decoration: BoxDecoration(
          color: Colors.blueAccent,
          borderRadius: BorderRadius.all(Radius.circular(20))),
      height: MediaQuery.of(context).size.height * .0525,
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

