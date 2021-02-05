import 'package:communitytabs/constants/marist_color_scheme.dart';
import 'package:communitytabs/data/club_event_data.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// Form Section One:
///   First section of the form grouping the Title, Host, Location,
///   and Room together.
class FormSectionEvent extends StatefulWidget {
  @override
  _FormSectionEventState createState() => _FormSectionEventState();
}

class _FormSectionEventState extends State<FormSectionEvent> {
  FocusNode focusNodeTitle;
  FocusNode focusNodeHost;
  FocusNode focusNodeLocation;
  FocusNode focusNodeRoom;
  String tempTitle = '';
  String tempHost = '';
  String tempLocation = '';
  String tempRoom = '';

  @override
  void initState(){
    super.initState();
    //final newEvent = Provider.of<ClubEventData>(context, listen: false);
    focusNodeTitle = new FocusNode();
    focusNodeTitle.addListener((){
      if(!focusNodeTitle.hasFocus){
       // tempTitle.trim().isEmpty
           // ? newEvent.setTitle('')
            //: newEvent.setTitle(tempTitle);
        //newEvent.applyChanges();
      }
    });

    focusNodeHost = new FocusNode();
    focusNodeHost.addListener((){
      if(!focusNodeHost.hasFocus){
        //tempHost.trim().isEmpty
            //? newEvent.setHost('')
           // : newEvent.setHost(tempHost);
        //newEvent.applyChanges();
      }
    });

    focusNodeLocation = new FocusNode();
    focusNodeLocation.addListener((){
      if(!focusNodeLocation.hasFocus){
        //tempLocation.trim().isEmpty
           // ? newEvent.setLocation('')
            //: newEvent.setLocation(tempLocation);
        //newEvent.applyChanges();
      }
    });

    focusNodeRoom = new FocusNode();
    focusNodeRoom.addListener((){
      if(!focusNodeRoom.hasFocus){
       // tempRoom.trim().isEmpty
           // ? newEvent.setRoom('')
            //: newEvent.setRoom(tempRoom);
        //newEvent.applyChanges();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    double _formSectionOneWidth = MediaQuery.of(context).size.width;
    double _textFormFieldWidth = MediaQuery.of(context).size.width;
    double _textFormFieldHeight = MediaQuery.of(context).size.height * .07;
    //ClubEventData newEvent = Provider.of<ClubEventData>(context);
    // TextEditingController _controllerTitle = new TextEditingController(text:newEvent.getTitle);
    // TextEditingController _controllerHost = new TextEditingController(text:newEvent.getHost);
    // TextEditingController _controllerLocation = new TextEditingController(text:newEvent.getLocation);
    // TextEditingController _controllerRoom = new TextEditingController(text:newEvent.getRoom);

     //tempTitle = newEvent.getTitle;
     //tempHost = newEvent.getHost;
     //tempLocation = newEvent.getLocation;
     //tempRoom = newEvent.getRoom;

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
                    // controller: _controllerTitle,
                    focusNode: focusNodeTitle,
                    style: TextStyle(color: cWhite100),
                    textInputAction: TextInputAction.done,
                    decoration: cAddEventTextFormFieldDecoration.copyWith(
                        hintText: 'Title (Required)'),
                    onEditingComplete: () {
                      //_controllerTitle.text.trim().isEmpty
                      //     ? newEvent.setTitle('')
                      //     : newEvent.setTitle(_controllerTitle.text);
                      // newEvent.applyChanges();
                      focusNodeTitle.unfocus();
                    },
                    onChanged: (value) {
                      tempTitle = value;
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
                    // controller: _controllerHost,
                    focusNode: focusNodeHost,
                    style: TextStyle(color: cWhite100),
                    textInputAction: TextInputAction.done,
                    decoration: cAddEventTextFormFieldDecoration.copyWith(
                        hintText: 'Host (Required)'),
                    onEditingComplete: () {
                      // _controllerHost.text.trim().isEmpty
                      //     ? newEvent.setHost('')
                      //     : newEvent.setHost(_controllerHost.text);
                      // newEvent.applyChanges();
                      // focusNodeHost.unfocus();
                    },
                    onChanged: (value) {
                      tempHost = value;
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
                    // controller: _controllerLocation,
                    focusNode: focusNodeLocation,
                    style: TextStyle(color: cWhite100),
                    textInputAction: TextInputAction.done,
                    decoration: cAddEventTextFormFieldDecoration.copyWith(
                        hintText: 'Location (Required)'),
                    onEditingComplete: () {
                      // _controllerLocation.text.trim().isEmpty
                      //     ? newEvent.setLocation('')
                      //     : newEvent.setLocation(_controllerLocation.text);
                      // newEvent.applyChanges();
                      // focusNodeLocation.unfocus();
                    },
                    onChanged: (value) {
                      tempLocation = value;
                    },
                  ),
                ),
                Expanded(child: Container()),
                Expanded(
                  flex: 3,
                  child: TextFormField(
                    // controller: _controllerRoom,
                    focusNode: focusNodeRoom,
                    style: TextStyle(color: cWhite100),
                    textInputAction: TextInputAction.done,
                    decoration: cAddEventTextFormFieldDecoration.copyWith(
                        hintText: 'Room'),
                    onEditingComplete: () {
                      // _controllerRoom.text.trim().isEmpty
                      //     ? newEvent.setRoom('')
                      //     : newEvent.setRoom(_controllerRoom.text);
                      // newEvent.applyChanges();
                      focusNodeRoom.unfocus();
                    },
                    onChanged: (value) {
                      tempRoom = value;
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
