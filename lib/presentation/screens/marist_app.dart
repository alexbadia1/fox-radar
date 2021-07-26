import 'package:communitytabs/logic/logic.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/services.dart';
import 'package:communitytabs/presentation/presentation.dart';

class MaristApp extends StatelessWidget {
  final RouteGeneratorMain routeGeneratorMain;

  MaristApp({@required this.routeGeneratorMain})
      : assert(routeGeneratorMain != null);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    return MultiBlocProvider(
      providers: [
        BlocProvider<AppPageViewCubit>(create: (context) => AppPageViewCubit()),
      ],
      child: MaterialApp(
          debugShowCheckedModeBanner: true,
          initialRoute: '/',
          onGenerateRoute: this.routeGeneratorMain.onGenerateRoute),
    );
  }
}
