import 'package:communitytabs/logic/cubits/cubits.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';
import 'package:communitytabs/presentation/routes/navigation_marist_app.dart';

class MaristApp extends StatelessWidget {
  final RouteGenerator routeGenerator;

  MaristApp({@required this.routeGenerator})
      : assert(routeGenerator != null);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    return MultiProvider(
      providers: [
        BlocProvider<SlidingUpPanelCubit>(create: (context) => SlidingUpPanelCubit()),
      ],
      child: MaterialApp(
          debugShowCheckedModeBanner: true,
          initialRoute: '/',
          onGenerateRoute: this.routeGenerator.onGenerateRoute),
    );
  }
}