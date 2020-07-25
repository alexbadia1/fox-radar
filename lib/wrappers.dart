import 'package:communitytabs/components/slidingUpNavigationBar.dart';
import 'package:communitytabs/constants/marist_color_scheme.dart';
import 'package:communitytabs/data/expansionTileMetadata.dart';
import 'package:communitytabs/data/homePageViewModel.dart';
import 'package:communitytabs/screens/account.dart';
import 'package:communitytabs/screens/category.dart';
import 'package:communitytabs/screens/home.dart';
import 'package:communitytabs/screens/login.dart';
import 'package:communitytabs/services/database.dart';
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

/// TODO: Change the implementation
class CategoryWrapper extends StatelessWidget {
  final String namedRoute;
  CategoryWrapper({@required this.namedRoute});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Material(
        child: SlidingUpPanelBodyWrapper(namedRoute: this.namedRoute),
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
        : Container(
            color: cBackground,
            height: MediaQuery.of(context).size.height * .175,
            width: double.infinity,
          );
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
    DatabaseService _db = Provider.of<DatabaseService>(context);
    HomePageViewModel _homePageViewModel =
        Provider.of<HomePageViewModel>(context);
    switch (namedRoute) {
      case '/home':
        if (_db.streamSuggested == null) {
          print(
              'Suggested Stream was null, so \'Suggested Stream\' was activated!');
          _db.activateSuggestedStream();
        } else
          print('\'Suggested Stream\' is already activated!');
        return PageView(
          controller: _homePageViewModel.homePageViewController,
          physics: NeverScrollableScrollPhysics(),
          children: [
            HomePageContent(),
            CategoryPageWrapper(),
          ],
        );
        break;
      case '/account':
        return AccountPageContent();
        break;
      default:
        return Center(
          child: Text('Oops!'),
        );
    }
  }
}

class CategoryPageWrapper extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    DatabaseService _db = Provider.of<DatabaseService>(context);
    return Consumer<CategoryContentModel>(
      builder: (context, _categoryContentModel, child) {
        switch (_categoryContentModel.getCategory()) {
          case '/sports':
            if (_db.streamIntramural == null || _db.streamCollegeSports == null || _db.streamClubSports == null) {
              print(
                  'A Sports Stream were null, so \'Sports Streams\' were activated!');
              _db.activateSportsStreams();
            } else
              print('\'All Sports Streams\' were already activated!');
            return CategoryContent(
              title: 'Sports',
              tabNamesFromLtoR: ['Intramural', 'College', 'Club'],
            );
            break;
          case '/arts':
            if (_db.streamMusicDance == null || _db.streamMoviesTheatre == null) {
              print('An Art Stream was null, so \'Arts Streams\' were activated!');
              _db.activateArtsStreams();
            } else
              print('\'All Arts Streams\' were already activated!');
            return CategoryContent(
              title: 'Arts',
              tabNamesFromLtoR: ['Music & Dance', 'Movies & Theatre'],
            );
            break;
          case '/diversity':
            if (_db.streamCulture == null || _db.streamSpiritual == null || _db.streamReligion == null) {
              print(
                  'A Diversity Stream was null, so \'Diversity Streams\' were activated!');
              _db.activateDiversityStreams();
            } else
              print('\'All Diversity Streams\' were already activated!');
            return CategoryContent(
              title: 'Diversity',
              tabNamesFromLtoR: ['Culture', 'Religion', 'Spiritual'],
            );
            break;
          case '/student':
            if (_db.streamAcademic == null || _db.streamPolitical == null || _db.streamMediaPublication == null) {
              print(
                  'A Student Interest Stream was null, so \'Student Interest Streams\' were activated!');
              _db.activateStudentStreams();
            } else
              print('\'All Student Interest Streams\' were already activated!');
            return CategoryContent(
              title: 'Student Interest',
              tabNamesFromLtoR: ['Academic', 'Political', 'Media'],
            );
            break;
          case '/food':
            if (_db.streamFreeFood == null || _db.streamMaristDining == null || _db.streamOccasions == null) {
              print('A Food Stream was null, so \'Food Streams\' wwere activated!');
              _db.activateFoodStreams();
            } else
              print('\'All Food Streams\' were already activated!');
            return CategoryContent(
              title: 'Marist Food',
              tabNamesFromLtoR: ['Marist Dining', 'Occasions', 'Free Food'],
            );
            break;
          case '/greek':
            if (_db.streamSorority == null || _db.streamFraternity == null || _db.streamRushes == null) {
              print(
                  'A Greek Stream was null, so \'Greek Streams\' were activated!');
              _db.activateGreekStreams();
            } else
              print('\'All Greek Streams\' were already activated!');
            return CategoryContent(
              title: 'Greek Life',
              tabNamesFromLtoR: ['Fraternity', 'Sorority', 'Rushes'],
            );
            break;
          default:
            return Center(
              child: Text('Oops!'),
            );
        }
      },
    );
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
        if (index == 0) {
          if (calenderPickerState.getTempStartTime() == null)
            calenderPickerState.setTempStartTime(
                calenderPickerState.data[index].getHeaderTimeValue() ??
                    DateTime.now());
        } else {
          if (calenderPickerState.getTempEndTime() == null)
            calenderPickerState.setTempEndTime(
                calenderPickerState.data[index].getHeaderTimeValue() ??
                    DateTime.now());
        }
        return index == 0
            ? calenderPickerState.getShowAddStartTimeCalenderStrip()
                ? CustomCalenderStrip(index: index, key: this._key)
                : Container(
                    height: MediaQuery.of(context).size.height * .175,
                    child: CupertinoTheme(
                      data: CupertinoThemeData(
                          textTheme: CupertinoTextThemeData(
                              dateTimePickerTextStyle:
                                  TextStyle(color: Colors.white))),
                      child: CupertinoDatePicker(
                        backgroundColor: Color.fromRGBO(0, 0, 0, .9325),
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
                              dateTimePickerTextStyle:
                                  TextStyle(color: Colors.white))),
                      child: CupertinoDatePicker(
                        backgroundColor: Color.fromRGBO(0, 0, 0, .9325),
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
