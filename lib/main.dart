import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:communitytabs/logic/logic.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:database_repository/database_repository.dart';
import 'package:communitytabs/presentation/presentation.dart';
import 'package:authentication_repository/authentication_repository.dart';

/*
 1.) Flutter recommends Algolia for more advanced search functions and queries
 2.) Implement an sql lite db as a cache
 */
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  final AuthenticationRepository authenticationRepository = new AuthenticationRepository();
  final DatabaseRepository databaseRepository = new DatabaseRepository();
  return runApp(
    MultiRepositoryProvider(
      providers: [
        RepositoryProvider<AuthenticationRepository>.value(value: authenticationRepository),
        RepositoryProvider<DatabaseRepository>.value(value: databaseRepository),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => AuthenticationBloc(authenticationRepository)),
          BlocProvider(create: (context) => LoginBloc(authenticationRepository: authenticationRepository)),
        ],
          child: SplashScreen(),
      )
    ),
  );
}// main
