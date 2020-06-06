import 'package:communitytabs/data/club_event_data.dart';
import 'package:flutter/material.dart';
import 'package:communitytabs/constants/marist_color_scheme.dart';
import 'package:provider/provider.dart';

class FormSectionDescription extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double _formSectionDescriptionWidth = MediaQuery.of(context).size.width;
    double _formSectionDescriptionHeight = MediaQuery.of(context).size.height * .2;
    ClubEventData newEvent = Provider.of<ClubEventData>(context);
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
              style: TextStyle(color: Colors.white),
              textInputAction: TextInputAction.done,
              maxLines: 5,
              decoration: cAddEventTextFormFieldDecoration.copyWith(hintText: 'Description'),
              onChanged: (value) {
                value.trim().isEmpty
                    ? newEvent.setSummary('')
                    : newEvent.setSummary(value);
              },
            ),
          ),
          cRightMarginSmall(context),
        ],
      ),
    );
  }
}