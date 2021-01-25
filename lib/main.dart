import 'package:communitytabs/presentation/routes/navigation.dart';

import 'logic/blocs/blocs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:communitytabs/presentation/screens/screens.dart';
import 'package:authentication_repository/authentication_repository.dart';

/*
Author: Alex Badia
Purpose: To learn Flutter Development
Observations:
 1.) Flutter recommends Algolia for more advanced search functions and queries
 2.) Implement an sql lite db as a cache
 3.) Implement state management and architecture... perhaps bloc/cubits?
 */
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  final AuthenticationRepository authenticationRepository = new AuthenticationRepository();
  return runApp(
      RepositoryProvider<AuthenticationRepository>.value(
      value: authenticationRepository,
      child: MaristApp(
          routeGenerator: RouteGenerator(
            authenticationRepository: authenticationRepository,
            authenticationBloc: AuthenticationBloc(authenticationRepository),
            loginBloc: LoginBloc(authenticationRepository: authenticationRepository),
            ),
          ),
    ),
  );
}
// StreamProvider<List<ArtsEventsData>>.value(value: DatabaseService().cachedArts),
//StreamProvider<List<FoodEventsData>>.value(value: DatabaseService().cachedFood),
//StreamProvider<List<GreekEventsData>>.value(value: DatabaseService().cachedGreek),
//StreamProvider<List<DiversityEventsData>>.value(value: DatabaseService().cachedDiversity),
//StreamProvider<List<SportsEventsData>>.value(value: DatabaseService().cachedSports),
//StreamProvider<List<StudentEventsData>>.value(value: DatabaseService().cachedStudent),
//StreamProvider<List<SuggestedEventsData>>.value(value: DatabaseService().cachedSuggested),
