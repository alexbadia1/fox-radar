import 'package:communitytabs/components/addEvent/slideable_expansion_panel_header.dart';
import 'package:communitytabs/data/expansionTileMetadata.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:communitytabs/wrappers.dart';
import 'form_section_time_buttons.dart';

class FormSectionTime extends StatefulWidget {
  @override
  _FormSectionTimeState createState() => _FormSectionTimeState();
}

class _FormSectionTimeState extends State<FormSectionTime> {
  var _formSectionTimeStateKey = UniqueKey();

  @override
  Widget build(BuildContext context) {
    double _formSectionTimeWidth = MediaQuery.of(context).size.width;

    /// Getting Model and Controller for the START time and END time expansion panels.
    ExpansionTiles exPanelState = Provider.of<ExpansionTiles>(context);

    /// Resetting the list of expansion panels every time the widget is rebuilt
    /// avoids infinite stacking of expansion panels.
    List<ExpansionPanel> _expansionPanels = [];

    /// Generating the Start Time and End Time expansion Panels.
    ///
    /// For-loop index differentiates which between the Start Time
    /// and End Time expansion panels
    ///
    /// START Time expansion panel: index == 0,
    /// END Time expansion panel: index == 1.
    for (int index = 0; index < exPanelState.data.length; ++index) {
      _expansionPanels.add(
        ExpansionPanel(
          headerBuilder: (BuildContext context, bool isExpanded) {
            return Container();
            // return SlidableExpansionPanelHeader(index: index);
          },
          body: Column(
            children: <Widget>[
              CustomCalenderStripWrapper(
                isExpanded: exPanelState.data[index].getIsExpanded(),
                index: index,
              ),
              DateAndTimeButtons(index: index),
            ],
          ),
          isExpanded: exPanelState.data[index].getIsExpanded(),
          canTapOnHeader: !exPanelState.data[index].getIsExpanded(),
        ),
      );
    }
    return Container(
      width: _formSectionTimeWidth,
      child: ExpansionPanelList(
        key: _formSectionTimeStateKey,
        expansionCallback: (int index, bool isExpanded) {
          setState(() {
            exPanelState.data[index]
                .setIsExpanded(!exPanelState.data[index].getIsExpanded());
          });
        },
        children: _expansionPanels,
      ),
    );
  }
}
