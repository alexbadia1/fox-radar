import 'package:communitytabs/components/addEvent/slidable_highlight_text_form_field.dart';
import 'package:communitytabs/constants/marist_color_scheme.dart';
import 'package:communitytabs/data/addHighlightButtonController.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FormSectionHighlights extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double _formSectionHighlightsWidth = MediaQuery.of(context).size.width;
    double _textFormFieldHeight = MediaQuery.of(context).size.height * .07;
    // ClubEventData newEvent = Provider.of<ClubEventData>(context);
    AddHighlightButtonController highlightButton = Provider.of<AddHighlightButtonController>(context);
    // List<String> tempList = newEvent.getHighlights;
    bool hasAnEmptyHighlight = false;
    int i = 0;
    // while (i < tempList.length && !hasAnEmptyHighlight) {
    //   if(tempList[i].trim().isEmpty) {
    //     hasAnEmptyHighlight = true;
    //   } else i++;
    // }
    highlightButton.setAddHighlightButtonEnabled(!hasAnEmptyHighlight);
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
                    'Highlights',
                    style: TextStyle(color: cWhite100, fontSize: 16.0),
                  ),
                ],
              ),
              // newEvent.getHighlights.length < 6
              //     ? Consumer<AddHighlightButtonController>(
              //         builder: (context, highlightButton, child) {
              //           return IconButton(
              //             icon: Icon(
              //               Icons.add,
              //               color: highlightButton.getAddHighlightButtonEnabled() ? Colors.blueAccent : Colors.grey,
              //             ),
              //             onPressed: highlightButton.getAddHighlightButtonEnabled() ? () {
              //               if (tempList.length < 6) {
              //                 tempList.add('');
              //                 newEvent.setHighlights(tempList);
              //                 newEvent.applyChanges();
              //               }
              //             } : () => null,
              //           );
              //         },
              //       )
              //     : Container(),
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
