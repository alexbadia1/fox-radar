import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fox_radar/logic/logic.dart';
import 'package:fox_radar/presentation/presentation.dart';
import 'package:database_repository/database_repository.dart';
import 'package:authentication_repository/authentication_repository.dart';

class MainView extends StatelessWidget {
  final RouteGeneratorMain routeGeneratorMain;

  const MainView({@required this.routeGeneratorMain}) : assert(routeGeneratorMain != null);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

    /// Top level screens are implemented in a single top level page view:
    ///   - Home Screen
    ///   - Account Screen
    return MultiBlocProvider(
      providers: [
        BlocProvider<UpdateProfileBloc>(
          create: (context) => UpdateProfileBloc(
            RepositoryProvider.of<AuthenticationRepository>(context).getUserModel(),
          ),
        ),
        BlocProvider<AppPageViewCubit>(
        create: (context) => AppPageViewCubit()
        ),
        BlocProvider<PinnedEventsBloc>(
            create: (context) => PinnedEventsBloc(
              db: RepositoryProvider.of<DatabaseRepository>(context),
              accountID: RepositoryProvider.of<AuthenticationRepository>(context).getUserModel().userID,
            )..add(PinnedEventsEventFetch())
        ),
      ],
      child: MaterialApp(
        initialRoute: '/',
        onGenerateRoute: this.routeGeneratorMain.onGenerateRoute,
      ),
    );
  } // build
} // MainView
