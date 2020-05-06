import 'package:communitytabs/data_definitions/club_event_data.dart';
import 'package:flutter/material.dart';
import 'package:communitytabs/colors/marist_color_scheme.dart';

class Loading extends StatefulWidget {
  @override
  _LoadingState createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {

  void loading () async {
    List<ClubEventData> _eventList;
    ClubEventData defaultEvent = new ClubEventData.nullConstructor();
    _eventList = [defaultEvent];
    //5.) Pass the list to the home page
    Future.delayed(Duration(seconds: 2), (){
      Navigator.pushReplacementNamed(context, '/home', arguments: {
      'events': _eventList });
    });
  }

  @override
  void initState() {
    super.initState();
    loading();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration (
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: <Color> [
                cWashedRed,
                cFullRed,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
