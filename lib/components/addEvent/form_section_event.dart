import 'package:communitytabs/constants/marist_color_scheme.dart';
import 'package:communitytabs/data/club_event_data.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// Form Section One:
///   First section of the form grouping the Title, Host, Location,
///   and Room together.
class FormSectionEvent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double _formSectionOneWidth = MediaQuery.of(context).size.width;
    double _textFormFieldWidth = MediaQuery.of(context).size.width;
    double _textFormFieldHeight = MediaQuery.of(context).size.height * .07;
    ClubEventData newEvent = Provider.of<ClubEventData>(context);
    return Container(
      width: _formSectionOneWidth,
      decoration: BoxDecoration(color: cCard, border: Border(bottom: cBorder)),
      child: Column(
        children: <Widget>[
          /// Title TextFormField
          Container(
            height: _textFormFieldHeight,
            width: _textFormFieldWidth,
            decoration:
                BoxDecoration(border: Border(top: cBorder, bottom: cBorder)),
            child: Row(
              children: <Widget>[
                cLeftMarginSmall(context),
                Expanded(
                  child: TextFormField(
                    initialValue: newEvent.getTitle,
                    style: TextStyle(color: cWhite100),
                    textInputAction: TextInputAction.done,
                    decoration: cAddEventTextFormFieldDecoration.copyWith(
                        hintText: 'Title (Required)'),
                    onChanged: (value) {
                      value.trim().isEmpty
                          ? newEvent.setTitle('')
                          : newEvent.setTitle(value);
                    },
                    validator: (String value) {
                      value = value.trim();
                      return value.isEmpty
                          ? '\u26A0 Don\'t forget the event of the Title!'
                          : null;
                    },
                  ),
                ),
                cRightMarginSmall(context)
              ],
            ),
          ),

          /// Host TextFormField
          Container(
            height: _textFormFieldHeight,
            width: _textFormFieldWidth,
            decoration: cAddEventBottomBorder,
            child: Row(
              children: <Widget>[
                cLeftMarginSmall(context),
                Expanded(
                  child: TextFormField(
                    initialValue: newEvent.getHost,
                    style: TextStyle(color: cWhite100),
                    textInputAction: TextInputAction.done,
                    decoration: cAddEventTextFormFieldDecoration.copyWith(
                        hintText: 'Host (Required)'),
                    onChanged: (value) {
                      value.trim().isEmpty
                          ? newEvent.setHost('')
                          : newEvent.setHost(value);
                    },
                  ),
                ),
                cRightMarginSmall(context),
              ],
            ),
          ),

          /// Location TextFormField and Room TextFormField
          Container(
            height: _textFormFieldHeight,
            width: _textFormFieldWidth,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                cLeftMarginSmall(context),
                Expanded(
                  flex: 7,
                  child: TextFormField(
                    initialValue: newEvent.getLocation,
                    style: TextStyle(color: cWhite100),
                    textInputAction: TextInputAction.done,
                    decoration: cAddEventTextFormFieldDecoration.copyWith(
                        hintText: 'Location (Required)'),
                    onChanged: (value) {
                      value.trim().isEmpty
                          ? newEvent.setLocation('')
                          : newEvent.setLocation(value);
                    },
                  ),
                ),
                Expanded(child: Container()),
                Expanded(
                  flex: 3,
                  child: TextFormField(
                    initialValue: newEvent.getRoom,
                    style: TextStyle(color: cWhite100),
                    textInputAction: TextInputAction.done,
                    decoration: cAddEventTextFormFieldDecoration.copyWith(
                        hintText: 'Room'),
                    onChanged: (value) {
                      value.trim().isEmpty
                          ? newEvent.setRoom('')
                          : newEvent.setRoom(value);
                    },
                  ),
                ),
                cRightMarginSmall(context),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
