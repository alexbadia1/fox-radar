import 'package:communitytabs/Screens/eventDetails.dart';
import 'package:communitytabs/auth.dart';
import 'package:flutter/material.dart';
import 'package:communitytabs/Screens/index.dart';
import 'package:communitytabs/Screens/loading.dart';
import 'package:communitytabs/Screens/wrapper.dart';
import 'package:communitytabs/Screens/error.dart';
import 'package:communitytabs/Screens/login.dart';
import 'package:provider/provider.dart';
import 'package:communitytabs/user.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamProvider<User>.value(
      value: AuthService().user,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        initialRoute: '/',
        routes: <String, WidgetBuilder>{
          '/': (context) => Wrapper(),
          '/home' : (context) => HomePage(),
          '/eventDetails' : (context) => EventDetails(),
          '/login': (context) => Login(),
          '/error': (context) => Error(),
          '/loading': (context) => Loading(),
        }
      ),
    );
  }
}