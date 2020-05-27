import 'package:communitytabs/Screens/eventDetails.dart';
import 'package:communitytabs/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:communitytabs/Screens/index.dart';
import 'package:communitytabs/Screens/loading.dart';
import 'package:communitytabs/Screens/wrapper.dart';
import 'package:communitytabs/Screens/error.dart';
import 'package:communitytabs/Screens/login.dart';
import 'package:communitytabs/Screens/signUp.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';
import 'package:communitytabs/data/user.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    return StreamProvider<User>.value(
      value: AuthService().user,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        initialRoute: '/',
        routes: <String, WidgetBuilder>{
          '/': (context) => Wrapper(),
          '/home' : (context) => HomePage(),
          '/login': (context) => Login(),
          '/signUp': (context) => SignUp(),
          '/eventDetails' : (context) => EventDetails(),
          '/error': (context) => Error(),
          '/loading': (context) => LoadingScreen(),
        }
      ),
    );
  }
}