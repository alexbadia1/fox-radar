import 'package:communitytabs/Screens/eventDetails.dart';
import 'package:communitytabs/Screens/sportsList.dart';
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
        Provider<PanelController>(create: (context) => pc ,),
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
