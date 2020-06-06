import 'package:communitytabs/components/addEvent/slidable_highlight_text_form_field.dart';
import 'package:communitytabs/constants/marist_color_scheme.dart';
import 'package:communitytabs/data/club_event_data.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FormSectionHighlights extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double _formSectionHighlightsWidth = MediaQuery.of(context).size.width;
    double _textFormFieldHeight = MediaQuery.of(context).size.height * .07;
    ClubEventData newEvent = Provider.of<ClubEventData>(context);
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[

        /// Highlights Header
        Container(
          height: _textFormFieldHeight,
          width: _formSectionHighlightsWidth,
          decoration: BoxDecoration(
              color: cCard, border: Border(top: cBorder, bottom: cBorder)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                children: <Widget>[
                  cLeftMarginSmall(context),
                  Text(
                    'Hightlights',
                    style: TextStyle(color: cWhite100, fontSize: 16.0),
                  ),
                ],
              ),
              newEvent.getHighlights.length < 6
                  ? IconButton(
                icon: Icon(
                  Icons.add,
                  color: Colors.blueAccent,
                ),
                onPressed: () {
                  List<String> tempList = newEvent.getHighlights;
                  if (tempList.length < 6) {
                    tempList.add('');
                    newEvent.setHighlights(tempList);
                    newEvent.applyChanges();
                    print('Highlight List After Blue + Button Presed: ' +
                        newEvent.getHighlights.toString());
                  }
                },
              )
                  : Container(),
            ],
          ),
        ),

        /// Highlight TextFormFields
        Container(
          width: _formSectionHighlightsWidth,
          child: SlidableHighlightList(),
        ),
      ],
    );
  }
}