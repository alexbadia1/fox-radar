import 'preload_image.dart';
import 'package:flutter/material.dart';
import 'package:fox_radar/logic/logic.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:fox_radar/presentation/presentation.dart';
import 'package:database_repository/database_repository.dart';
import 'package:authentication_repository/authentication_repository.dart';

// Hack: https://github.com/firebase/flutterfire/issues/10306
// options: FirebaseOptions(
//     apiKey: dotenv.env['API_KEY'] as String,
//     appId: dotenv.env['APP_ID'] as String,
//     messagingSenderId: dotenv.env['MESSAGE_SENDER_ID'] as String,
//     projectId: dotenv.env['PROJECT_ID'] as String
// ),
// options: const FirebaseOptions(
//     apiKey: 'AIzaSyBDhbOrV4VcsnoxmkGG5AL0zxgN4JzmnOQ',
//     appId: '1:53662614301:android:5b6608e9da8b312eb317f4',
//     messagingSenderId: '53662614301',
//     projectId: 'fox-radar-f8810'
// ),

void main() async {
  // await dotenv.load();

  final widgetsBinding = WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();

  // Global singleton instances of Database Repo and Authentication Repo
  final DatabaseRepository databaseRepository = new DatabaseRepository();
  final AuthenticationRepository authenticationRepository = new AuthenticationRepository();

  // Resolve image assets
  await loadImage(
      imageProvider: AssetImage('images/image1.jpg'),
      devicePixelRatio:  widgetsBinding.window.devicePixelRatio,
  );
  await loadImage(
    imageProvider: AssetImage('images/everlasting_banner.png'),
    devicePixelRatio:  widgetsBinding.window.devicePixelRatio,
  );
  await loadImage(
    imageProvider: AssetImage('images/fresh_milk_banner.png'),
    devicePixelRatio:  widgetsBinding.window.devicePixelRatio,
  );
  await loadImage(
    imageProvider: AssetImage('images/sharp_blue_banner.png'),
    devicePixelRatio:  widgetsBinding.window.devicePixelRatio,
  );
  await loadImage(
    imageProvider: AssetImage('images/soft_green_banner.png'),
    devicePixelRatio:  widgetsBinding.window.devicePixelRatio,
  );
  await loadImage(
    imageProvider: AssetImage('images/soft_red_banner.jpg'),
    devicePixelRatio:  widgetsBinding.window.devicePixelRatio,
  );
  await loadImage(
    imageProvider: AssetImage('images/soft_yellow_banner.jpg'),
    devicePixelRatio:  widgetsBinding.window.devicePixelRatio,
  );
  await loadImage(
      imageProvider: AssetImage('images/lonely_panda.png'),
      devicePixelRatio:  widgetsBinding.window.devicePixelRatio,
  );

  return runApp(
    MultiRepositoryProvider(
      providers: [
        RepositoryProvider<AuthenticationRepository>.value(value: authenticationRepository),
        RepositoryProvider<DatabaseRepository>.value(value: databaseRepository),
      ],

      // Weird, but shows explicitly that these blocs are reliant on the repositories (above)
      child: MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => AuthenticationBloc(authenticationRepository)),
          BlocProvider(create: (context) => DeviceNetworkBloc()..add(DeviceNetworkEventListen())),
          BlocProvider(create: (context) => LoginBloc(authenticationRepository: authenticationRepository)),
        ],
          child: ViewsWrapper(),
      )
    ),
  );
}
