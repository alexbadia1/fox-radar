import 'package:communitytabs/Screens/event.dart';
import 'package:communitytabs/data/pageViewMetadata.dart';
import 'package:communitytabs/data/club_event_data.dart';
import 'package:communitytabs/services/auth.dart';
import 'package:communitytabs/services/database.dart';
import 'package:flutter/material.dart';
import 'package:communitytabs/wrappers/homeWrapper.dart';
import 'package:communitytabs/Screens/loading.dart';
import 'package:communitytabs/wrappers/loginWrapper.dart';
import 'package:communitytabs/Screens/error.dart';
import 'package:communitytabs/Screens/login.dart';
import 'package:communitytabs/Screens/signUp.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';
import 'package:communitytabs/data/user.dart';
import 'wrappers/accountWrapper.dart';
import 'package:communitytabs/data/slidingUpPanelMetadata.dart';
/*
Author: Alex Badia
Implemented MultiProvider for very basic state management
  1. User Stream:
    ~Contains Auth user data returned from the Firebase Authentication
    ~Allows for the app to 'remember' the user for login
     by passing the Auth User through a wrapper class.
  2. Events Stream:
  `~Contains class definitions of the events returned from Firebase database,
   ~In the services/database.dart,
  3. Panel Controller Stream:
 */
void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    return MultiProvider(
      providers: [
        StreamProvider<User>.value(value: AuthService().user),
        StreamProvider<List<ClubEventData>>.value(
            value: DatabaseService().getEvents),
        ChangeNotifierProvider<SlidingUpPanelMetaData>(create: (context) => SlidingUpPanelMetaData()),
        ChangeNotifierProvider<PageViewMetaData>(create: (context) => PageViewMetaData(),),
      ],
      child: MaterialApp(
          debugShowCheckedModeBanner: false,
          initialRoute: '/',
          routes: <String, WidgetBuilder>{
            '/': (context) => Wrapper(),
            '/home': (context) => HomePage(),
            '/login': (context) => Login(),
            '/signUp': (context) => SignUp(),
            '/eventDetails': (context) => EventDetails(),
            '/error': (context) => Error(),
            '/loading': (context) => LoadingScreen(),
            '/account' : (context) => Account(),
          }),
    );
  }
}
