import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:communitytabs/logic/logic.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:communitytabs/presentation/presentation.dart';

class MainView extends StatelessWidget {
  final RouteGeneratorMain routeGeneratorMain;

  const MainView({@required this.routeGeneratorMain}) : assert(routeGeneratorMain != null);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

    /// Top level screens are implemented in a single top level page view:
    ///   - Home Screen
    ///   - Account Screen
    return BlocProvider<AppPageViewCubit>(
      create: (context) => AppPageViewCubit(),
      child: MaterialApp(
        initialRoute: '/',
        onGenerateRoute: this.routeGeneratorMain.onGenerateRoute,
      ),
    );
  } // build
} // MainView
