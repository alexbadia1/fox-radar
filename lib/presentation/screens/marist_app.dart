import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';
import 'package:communitytabs/data/slidingUpPanelMetadata.dart';
import 'package:communitytabs/data/addHighlightButtonController.dart';
import 'package:communitytabs/data/expansionTileMetadata.dart';
import 'package:communitytabs/data/homePageViewModel.dart';
import 'package:communitytabs/data/pageViewMetadata.dart';
import 'package:communitytabs/data/selectedImageModel.dart';
import 'package:communitytabs/data/categoryPanels.dart';
import 'package:communitytabs/presentation/routes/navigation.dart';

class MaristApp extends StatefulWidget {
  final RouteGenerator routeGenerator;
  final String initialRoute;

  MaristApp({@required this.routeGenerator, @required this.initialRoute})
      : assert(routeGenerator != null),
        assert(initialRoute != null);

  @override
  _MaristAppState createState() => _MaristAppState();
}

class _MaristAppState extends State<MaristApp> {
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
          initialRoute: this.widget.initialRoute,
          onGenerateRoute: this.widget.routeGenerator.onGenerateRoute),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }// dispose
}