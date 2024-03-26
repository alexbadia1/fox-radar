import 'preload_image.dart';
import 'package:flutter/material.dart';
import 'package:fox_radar/logic/logic.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:fox_radar/presentation/presentation.dart';
import 'package:database_repository/database_repository.dart';
import 'package:authentication_repository/authentication_repository.dart';

void main() async {
  final widgetsBinding = WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();

  // Global singleton instances of Database Repo and Authentication Repo
  final DatabaseRepository databaseRepository = new DatabaseRepository();
  final AuthenticationRepository authenticationRepository =
      new AuthenticationRepository();

  // Resolve image assets
  await loadImage(
    imageProvider: AssetImage('images/image1.jpg'),
    devicePixelRatio: widgetsBinding.window.devicePixelRatio,
  );
  await loadImage(
    imageProvider: AssetImage('images/everlasting_banner.png'),
    devicePixelRatio: widgetsBinding.window.devicePixelRatio,
  );
  await loadImage(
    imageProvider: AssetImage('images/fresh_milk_banner.png'),
    devicePixelRatio: widgetsBinding.window.devicePixelRatio,
  );
  await loadImage(
    imageProvider: AssetImage('images/sharp_blue_banner.png'),
    devicePixelRatio: widgetsBinding.window.devicePixelRatio,
  );
  await loadImage(
    imageProvider: AssetImage('images/soft_green_banner.png'),
    devicePixelRatio: widgetsBinding.window.devicePixelRatio,
  );
  await loadImage(
    imageProvider: AssetImage('images/soft_red_banner.jpg'),
    devicePixelRatio: widgetsBinding.window.devicePixelRatio,
  );
  await loadImage(
    imageProvider: AssetImage('images/soft_yellow_banner.jpg'),
    devicePixelRatio: widgetsBinding.window.devicePixelRatio,
  );
  await loadImage(
    imageProvider: AssetImage('images/lonely_panda.png'),
    devicePixelRatio: widgetsBinding.window.devicePixelRatio,
  );

  return runApp(
    MultiRepositoryProvider(
      providers: [
        RepositoryProvider<AuthenticationRepository>.value(
            value: authenticationRepository),
        RepositoryProvider<DatabaseRepository>.value(value: databaseRepository),
      ],

      // Weird, but shows explicitly that these blocs are reliant on the repositories (above)
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => AuthenticationBloc(authenticationRepository)
              ..add(AuthStarted()),
          ),
          BlocProvider(
            create: (context) =>
                DeviceNetworkBloc()..add(DeviceNetworkEventListen()),
          ),
          BlocProvider(
            create: (context) =>
                LoginBloc(authenticationRepository: authenticationRepository),
          ),
        ],
        child: ViewsWrapper(),
      ),
    ),
  );
}
