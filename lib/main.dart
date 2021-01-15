import 'package:communitytabs/Screens/event.dart';
import 'package:communitytabs/constants/marist_color_scheme.dart';
import 'package:communitytabs/data/addHighlightButtonController.dart';
import 'package:communitytabs/data/expansionTileMetadata.dart';
import 'package:communitytabs/data/homePageViewModel.dart';
import 'package:communitytabs/data/pageViewMetadata.dart';
import 'package:communitytabs/data/selectedImageModel.dart';
import 'package:communitytabs/wrappers.dart';
import 'package:flutter/material.dart';
import 'package:communitytabs/Screens/error.dart';
import 'package:communitytabs/Screens/login.dart';
import 'package:communitytabs/Screens/signUp.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';
import 'package:communitytabs/data/slidingUpPanelMetadata.dart';
import 'data/categoryPanels.dart';

import 'package:authentication_repository/authentication_repository.dart';
import 'package:database_repository/database_repository.dart';
import 'package:firebase_core/firebase_core.dart';

/*
Author: Alex Badia
Purpose: To learn Flutter Development
Observations:
 1.) Flutter recommends Algolia for more advanced search functions and queries
 2.) Implement an sql lite db as a cache
 3.) Implement state management and architecture... perhaps bloc/cubits?
 */
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  return runApp(
    MyApp(
      authenticationRepository: new AuthenticationRepository(),
      databaseRepository: new DatabaseRepository(),
    ),
  );
}

class MyApp extends StatefulWidget {
  final AuthenticationRepository authenticationRepository;
  final DatabaseRepository databaseRepository;

  MyApp(
      {@required this.authenticationRepository,
      @required this.databaseRepository});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    return MultiProvider(
      providers: [
        //FutureProvider<Directory>.value(value: _newCacheDir()),
        //Provider<FirebaseStorage>.value(value: FirebaseStorage(storageBucket: 'gs://maristcommunitytabs.appspot.com')),
        // StreamProvider<User>.value(value: AuthService().user),
        // ChangeNotifierProvider<DatabaseService>(create: (context) => DatabaseService()),
        ChangeNotifierProvider<SlidingUpPanelMetaData>(
            create: (context) => SlidingUpPanelMetaData()),
        ChangeNotifierProvider<PageViewMetaData>(
          create: (context) => PageViewMetaData(),
        ),
        ChangeNotifierProvider<HomePageViewModel>(
            create: (context) => HomePageViewModel()),
        ChangeNotifierProvider<ExpansionTiles>(
          create: (context) => ExpansionTiles(),
        ),
        ChangeNotifierProvider<CategoryPanels>(
          create: (context) => CategoryPanels(),
        ),
        ChangeNotifierProvider<AddHighlightButtonController>(
          create: (context) => AddHighlightButtonController(),
        ),
        ChangeNotifierProvider<SelectedImageModel>(
          create: (context) => SelectedImageModel(),
        ),
        ChangeNotifierProvider<CategoryContentModel>(
          create: (context) => CategoryContentModel(),
        ),
      ],
      child: MaterialApp(
          debugShowCheckedModeBanner: false,
          initialRoute: '/',
          routes: <String, WidgetBuilder>{
            '/': (context) => Login(),
            '/home': (context) => HomePage(),
            '/login': (context) => Login(),
            '/signUp': (context) => SignUp(),
            '/eventDetails': (context) => EventDetails(),
            '/error': (context) => Error(),
            '/loading': (context) => LoadingWidget(),
            '/account': (context) => Account(),
          }),
    );
  }
}

// return MaterialApp(
// theme: theme,
// navigatorKey: _navigatorKey,
// builder: (context, child) {
// return BlocListener<AuthenticationBloc, AuthenticationState>(
// listener: (context, state) {
// switch (state.status) {
// case AuthenticationStatus.authenticated:
// _navigator.pushAndRemoveUntil<void>(
// HomePage.route(),
// (route) => false,
// );
// break;
// case AuthenticationStatus.unauthenticated:
// _navigator.pushAndRemoveUntil<void>(
// LoginPage.route(),
// (route) => false,
// );
// break;
// default:
// break;
// }
// },
// child: child,
// );
// },
// onGenerateRoute: (_) => SplashPage.route(),
// );
//StreamProvider<List<ArtsEventsData>>.value(value: DatabaseService().cachedArts),
//StreamProvider<List<FoodEventsData>>.value(value: DatabaseService().cachedFood),
//StreamProvider<List<GreekEventsData>>.value(value: DatabaseService().cachedGreek),
//StreamProvider<List<DiversityEventsData>>.value(value: DatabaseService().cachedDiversity),
//StreamProvider<List<SportsEventsData>>.value(value: DatabaseService().cachedSports),
//StreamProvider<List<StudentEventsData>>.value(value: DatabaseService().cachedStudent),
//StreamProvider<List<SuggestedEventsData>>.value(value: DatabaseService().cachedSuggested),
