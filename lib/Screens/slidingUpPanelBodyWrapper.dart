import 'package:communitytabs/components/accountPageContent.dart';
import 'package:communitytabs/components/homePageContent.dart';
import 'package:flutter/material.dart';

class SlidingUpPanelBodyWrapper extends StatelessWidget {
  final String namedRoute;
  SlidingUpPanelBodyWrapper({this.namedRoute});
  @override
  Widget build(BuildContext context) {
    switch (namedRoute) {
      case '/home':
        return HomePageContent();
        break;
      case '/account':
        return AccountPageContent();
        break;
      case '/sports':
        return Container();
      default:
        return Center(
          child: Text('Oops!'),
        );
    }
  }
}
