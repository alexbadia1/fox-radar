import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:communitytabs/logic/logic.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:database_repository/database_repository.dart';
import 'package:communitytabs/presentation/presentation.dart';
import 'package:authentication_repository/authentication_repository.dart';

/// Some things to think about:
///   1.) Flutter recommends Algolia for more advanced search functions
///   2.) Perhaps implement sql lite for cache
void main() async {
  /// Usually called during [runApp], since firebase uses
  /// native code, retrieving an instance of the WidgetsBinding
  /// required to use platform  channels to call the native code.
  WidgetsFlutterBinding.ensureInitialized();

  /// Call this before using any firebase plugins
  await Firebase.initializeApp();

  /// Global singleton instances of Database Repo and Authentication Repo
  final DatabaseRepository databaseRepository = new DatabaseRepository();
  final AuthenticationRepository authenticationRepository = new AuthenticationRepository();

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
          BlocProvider(create: (context) => LoginBloc(authenticationRepository: authenticationRepository)),
        ],
          child: ViewsWrapper(),
      )
    ),
  );
}// main
