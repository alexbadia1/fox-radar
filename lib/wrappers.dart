import 'package:communitytabs/components/slidingUpNavigationBar.dart';
import 'package:communitytabs/data/expansionTileMetadata.dart';
import 'package:communitytabs/screens/account.dart';
import 'package:communitytabs/screens/category.dart';
import 'package:communitytabs/screens/home.dart';
import 'package:communitytabs/screens/login.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'components/customCalenderStrip.dart';
import 'data/user.dart';

class Account extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Material(
        child: SlidingUpNavigationBar(namedRoute: '/account'),
      ),
    );
  }
}

class CategoryWrapper extends StatelessWidget {
  final String namedRoute;
  CategoryWrapper({@required this.namedRoute});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Material(
        child: SlidingUpNavigationBar(namedRoute: this.namedRoute),
      ),
    );
  }
}

class CustomCalenderStripWrapper extends StatefulWidget {
  final int index;
  final bool isExpanded;
  CustomCalenderStripWrapper({this.isExpanded, this.index});
  @override
  _CustomCalenderStripWrapperState createState() =>
      _CustomCalenderStripWrapperState();
}

class _CustomCalenderStripWrapperState
    extends State<CustomCalenderStripWrapper> {
  @override
  Widget build(BuildContext context) {
    return this.widget.isExpanded
        ? DateOrTimePicker(index: this.widget.index)
        : Container();
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Material(child: SlidingUpNavigationBar(namedRoute: '/home')),
    );
  }
}

class AuthWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    User _user = Provider.of<User>(context);

    //Depending on what we pick up from the stream show the home or login page
    if (_user == null) {
      return Login();
    } else {
      return HomePage();
    }
    //Either return the authentication screen or home screen
  }
}

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
        return CategoryContent(
          title: 'Sports',
          tabNamesFromLtoR: ['Intramural', 'College', 'Club'],
        );
        break;
      case '/arts':
        return CategoryContent(
          title: 'Arts',
          tabNamesFromLtoR: ['Music & Dance', 'Movies & Theatre'],
        );
        break;
      case '/diversity':
        return CategoryContent(
          title: 'Diversity',
          tabNamesFromLtoR: ['Culture', 'Religion', 'Spiritual'],
        );
        break;
      case '/clubs':
        return CategoryContent(
          title: 'Student Interest',
          tabNamesFromLtoR: ['Academic', 'Political', 'Media'],
        );
        break;
      case '/food':
        return CategoryContent(
          title: 'Marist Food',
          tabNamesFromLtoR: ['Marist Dining', 'Occasions', 'Free Food'],
        );
        break;
      case '/greek':
        return CategoryContent(
          title: 'Greek Life',
          tabNamesFromLtoR: ['Fraterntiy', 'Sorority', 'Rushes'],
        );
      default:
        return Center(
          child: Text('Oops!'),
        );
    }
  }
}

class DateOrTimePicker extends StatelessWidget {
  var _key = UniqueKey();
  final int index;
  DateOrTimePicker({this.index});
  @override
  Widget build(BuildContext context) {
    return Consumer<ExpansionTiles>(
      builder: (context, calenderPickerState, child) {
        if(index == 0) {
          if(calenderPickerState.getTempStartTime() == null)
            calenderPickerState.setTempStartTime(calenderPickerState.data[index].getHeaderTimeValue() ?? DateTime.now());
        } else {
          if (calenderPickerState.getTempEndTime() == null)
            calenderPickerState.setTempEndTime(calenderPickerState.data[index].getHeaderTimeValue() ?? DateTime.now());
        }
        return index == 0
            ? calenderPickerState.getShowAddStartTimeCalenderStrip()
                ? CustomCalenderStrip(index: index, key: this._key)
                : Container(
                    height: MediaQuery.of(context).size.height * .175,
                    child: CupertinoTheme(
                      data: CupertinoThemeData(
                          textTheme: CupertinoTextThemeData(
                              dateTimePickerTextStyle: TextStyle(
                                  color: Colors.white))),
                      child: CupertinoDatePicker(
                        backgroundColor: Color.fromRGBO(0, 0, 0, .85),
                        mode: CupertinoDatePickerMode.time,
                        initialDateTime: calenderPickerState.getTempStartTime(),
                        onDateTimeChanged: (value) {
                          ///Set the temp start date
                          ///
                          /// Later to be used by the Confirm Button
                          calenderPickerState.setTempStartTime(value);
                        },
                      ),
                    ),
                  )
            : calenderPickerState.getShowAddEndTimeCalenderStrip()
                ? CustomCalenderStrip(index: index, key: this._key)
                : Container(
                    height: MediaQuery.of(context).size.height * .175,
                    child: CupertinoTheme(
                      data: CupertinoThemeData(
                          textTheme: CupertinoTextThemeData(
                              dateTimePickerTextStyle: TextStyle(
                                  color: Colors.white))),
                      child: CupertinoDatePicker(
                        backgroundColor: Color.fromRGBO(0, 0, 0, .85),
                        mode: CupertinoDatePickerMode.time,
                        initialDateTime: calenderPickerState.getTempEndTime(),
                        onDateTimeChanged: (value) {
                          ///Set the temp end date
                          ///
                          /// Later to be used by the Confirm Button
                          calenderPickerState.setTempEndTime(value);
                        },
                      ),
                    ),
                  );
      },
    );
  }
}
