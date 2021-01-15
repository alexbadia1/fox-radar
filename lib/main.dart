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
 1.) Full Text Search: firebase recommends using a third party solution such as
     'Algolia' to implement advanced search features like:
     ~ Order by closest match first
     ~ Geolocation searches
     ~ Search speed and efficiency optimizations like start the search after the
       user stopped typing for 300 milliseconds.
2.) Minimal Read and Writes to Firebase: firebase reads are not free! Depending
    on which service you are using writes may or may not be free.
    ~ Cache solutions
 */
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  return runApp(
    MyApp(
      authenticationRepository: new AuthenticationRepository(),
      databaseRepository: new DatabaseRepository(),
    ),
  );
}

class MyApp extends StatelessWidget {
  final AuthenticationRepository authenticationRepository;
  final DatabaseRepository databaseRepository;
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  MyApp(
      {@required this.authenticationRepository,
      @required this.databaseRepository});
  // Future<Directory> _newCacheDir() async {
  //   var cacheDir = await getTemporaryDirectory();
  //   if (cacheDir.existsSync()) {
  //     cacheDir.deleteSync(recursive: true);
  //   }
  //   return cacheDir = await getTemporaryDirectory();
  // }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    return FutureBuilder<FirebaseApp>(
        future: _initialization,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Container();
          }

          if (snapshot.connectionState == ConnectionState.done) {
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
          } // if

          return LoadingWidget();
        });
  }
}
//StreamProvider<List<ArtsEventsData>>.value(value: DatabaseService().cachedArts),
//StreamProvider<List<FoodEventsData>>.value(value: DatabaseService().cachedFood),
//StreamProvider<List<GreekEventsData>>.value(value: DatabaseService().cachedGreek),
//StreamProvider<List<DiversityEventsData>>.value(value: DatabaseService().cachedDiversity),
//StreamProvider<List<SportsEventsData>>.value(value: DatabaseService().cachedSports),
//StreamProvider<List<StudentEventsData>>.value(value: DatabaseService().cachedStudent),
//StreamProvider<List<SuggestedEventsData>>.value(value: DatabaseService().cachedSuggested),
