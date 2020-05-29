import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';


class AddEvent extends StatefulWidget {
  @override
  _AddEventState createState() => _AddEventState();
}

class _AddEventState extends State<AddEvent> {
  @override
  Widget build(BuildContext context) {
    PanelController pc = Provider.of<PanelController>(context);
    return Center(
      child: RaisedButton(
        child: Text('Cancel Button'),
        onPressed: () {
          print('Button Was Pressed');
          pc.close();
        },
      ),
    );
  }
}

