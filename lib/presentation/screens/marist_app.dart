import 'package:communitytabs/logic/logic.dart';
import 'package:database_repository/database_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/services.dart';
import 'package:communitytabs/presentation/presentation.dart';
import 'package:provider/provider.dart';

class MaristApp extends StatelessWidget {
  final RouteGeneratorMain routeGeneratorMain;

  MaristApp({@required this.routeGeneratorMain})
      : assert(routeGeneratorMain != null);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    return MultiProvider(
      providers: [
        BlocProvider<UploadEventBloc>(
          create: (context) => UploadEventBloc(
              db: RepositoryProvider.of<DatabaseRepository>(context)),
        ),
        BlocProvider<AppPageViewCubit>(create: (context) => AppPageViewCubit()),
      ],
      child: MaterialApp(
          debugShowCheckedModeBanner: true,
          initialRoute: '/',
          onGenerateRoute: this.routeGeneratorMain.onGenerateRoute),
    );
  }
}
