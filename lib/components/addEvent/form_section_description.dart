import 'package:communitytabs/data/club_event_data.dart';
import 'package:flutter/material.dart';
import 'package:communitytabs/constants/marist_color_scheme.dart';
import 'package:provider/provider.dart';

class FormSectionDescription extends StatefulWidget {
  @override
  _FormSectionDescriptionState createState() => _FormSectionDescriptionState();
}

class _FormSectionDescriptionState extends State<FormSectionDescription> {
  FocusNode focusNodeDescription;
  String tempDescription = '';
  @override
  void initState() {
    super.initState();
    focusNodeDescription = new FocusNode();
    final newEvent = Provider.of<ClubEventData>(context, listen: false);
    focusNodeDescription.addListener((){
      if (!focusNodeDescription.hasFocus) {
        tempDescription.trim().isEmpty
            ? newEvent.setSummary('')
            : newEvent.setSummary(tempDescription);
        //newEvent.applyChanges();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    double _formSectionDescriptionWidth = MediaQuery.of(context).size.width;
    double _formSectionDescriptionHeight = MediaQuery.of(context).size.height * .2;
    ClubEventData newEvent = Provider.of<ClubEventData>(context);
    TextEditingController _controllerDescription = new TextEditingController(text: newEvent.getSummary);
    tempDescription = newEvent.getSummary;
    return Container(
      width: _formSectionDescriptionWidth,
      height: _formSectionDescriptionHeight,
      decoration:
      BoxDecoration(color: cCard, border: Border(top: cBorder, bottom: cBorder)),
      child: Row(
        children: <Widget>[
          cLeftMarginSmall(context),
          Expanded(
            child: TextFormField(
              controller: _controllerDescription,
              focusNode: focusNodeDescription,
              style: TextStyle(color: Colors.white),
              textInputAction: TextInputAction.done,
              maxLines: 5,
              decoration: cAddEventTextFormFieldDecoration.copyWith(hintText: 'Description'),
              onEditingComplete: () {
                _controllerDescription.text.trim().isEmpty
                    ? newEvent.setSummary('')
                    : newEvent.setSummary(_controllerDescription.text);
                newEvent.applyChanges();
                focusNodeDescription.unfocus();
              },
              onChanged: (value) {
                tempDescription = value;
              },

            ),
          ),
          cRightMarginSmall(context),
        ],
      ),
    );
  }
}