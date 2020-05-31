import 'package:communitytabs/components/eventForm.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AddEventWrapper extends StatelessWidget {
  final String route;

  AddEventWrapper({this.route});

  @override
  Widget build(BuildContext context) {
    if (this.route == '/home' || this.route == '/account')
      return AddEventContent(hasHeader: false);
    //If the route was to the Home or Account Page show the Form without the header
    else
      return AddEventContent(hasHeader: true);
  }
}