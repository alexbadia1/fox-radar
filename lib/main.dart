import 'package:communitytabs/Screens/eventDetails.dart';
import 'package:communitytabs/Screens/sportsList.dart';
import 'package:communitytabs/data/IconsStateProvider.dart';
import 'package:communitytabs/data/club_event_data.dart';
import 'package:communitytabs/services/auth.dart';
import 'package:communitytabs/services/database.dart';
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
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'Screens/account.dart';

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

  PanelController pc = new PanelController();

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    return MultiProvider(
      providers: [
        StreamProvider<User>.value(value: AuthService().user),
        StreamProvider<List<ClubEventData>>.value(
            value: DatabaseService().getEvents),
        Provider<PanelController>(create: (context) => pc,),
        ChangeNotifierProvider<IconStateProvider>(create: (context) => IconStateProvider(),),
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
            '/sports': (context) => SportsList(),
            '/account' : (context) => Account(),
          }),
    );
  }
}
