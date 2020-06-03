import 'package:communitytabs/components/addTime.dart';
import 'package:communitytabs/components/timePickers.dart';
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
    return Container(
      color: Colors.white,
      child: Form(
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
            SizedBox(height: MediaQuery.of(context).size.height * .0035),
            Container(
              width: pWidth * .9,
              child: TextFormField(
                initialValue: this.widget.newEvent.getTitle,
                textInputAction: TextInputAction.done,
                decoration: customTextField.copyWith(labelText: 'Title'),
                onChanged: (value) {
                  this.widget.newEvent.setTitle(value);
                },
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
              child: TextFormField(
                initialValue: this.widget.newEvent.getTitle,
                textInputAction: TextInputAction.done,
                decoration: customTextField.copyWith(labelText: 'Host'),
                onChanged: (value) {
                  this.widget.newEvent.setHost(value);
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
                      decoration: customTextField.copyWith(labelText: 'Room'),
                      onChanged: (value) {
                        this.widget.newEvent.setRoom(value);
                      },
                    ),
                  ),
                  Expanded(child: SizedBox()),
                  Expanded(
                    flex: 7,
                    child: TextFormField(
                      initialValue: this.widget.newEvent.getLocation,
                      textInputAction: TextInputAction.done,
                      decoration: customTextField.copyWith(labelText: 'Location'),
                      onChanged: (value) {
                        this.widget.newEvent.setLocation(value);
                      },
                      validator: (value) {
                        value = value.trim();
                        return value.isEmpty ? 'Please enter a location' : null;
                      },
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * .02),
            AddTime(),
            SizedBox(height: MediaQuery.of(context).size.height * .075),
          ],
        ),
      ),
    );
  }
}
