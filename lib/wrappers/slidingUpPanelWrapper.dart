import 'package:communitytabs/screens/account.dart';
import 'package:communitytabs/Screens/home.dart';
import 'package:communitytabs/Screens/category.dart';
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
        return CategoryContent(title: 'Sports', tabNamesFromLtoR: ['Intramural', 'College', 'Club'],);
        break;
      case '/arts':
        return CategoryContent(title: 'Arts', tabNamesFromLtoR: ['Music & Dance', 'Movies & Theatre'],);
        break;
      case '/diversity':
        return CategoryContent(title: 'Diversity', tabNamesFromLtoR: ['Culture', 'Religion', 'Spiritual'],);
        break;
      case '/clubs':
        return CategoryContent(title: 'Student Interest', tabNamesFromLtoR: ['Academic', 'Political', 'Media'],);
        break;
      case '/food':
        return CategoryContent(title: 'Marist Food', tabNamesFromLtoR: ['Marist Dining', 'Occasions', 'Free Food'],);
        break;
      case '/greek':
        return CategoryContent(title: 'Greek Life', tabNamesFromLtoR: ['Fraterntiy', 'Sorority', 'Rushes'],);
      default:
        return Center(
          child: Text('Oops!'),
        );
    }
  }
}
