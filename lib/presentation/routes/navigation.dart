import 'package:authentication_repository/authentication_repository.dart';
import 'package:database_repository/database_repository.dart';
import 'package:flutter/material.dart';
import 'package:communitytabs/wrappers.dart';
import 'package:communitytabs/screens/screens.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:communitytabs/logic/blocs/blocs.dart';

class RouteGenerator {
  // final AuthenticationRepository authenticationRepository;
  // final DatabaseRepository databaseRepository;
  // AuthenticationBloc _authenticationBloc;

  // RouteGenerator(
  //     {@required this.authenticationRepository,
  //     @required this.databaseRepository})
  //     : assert(authenticationRepository != null),
  //       assert(databaseRepository != null)
  // {
  //   _authenticationBloc = AuthenticationBloc(authenticationRepository);
  // }

  Route onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case "/login":
        return MaterialPageRoute(builder: (_) => Login());
        break;
      case "/signUp":
        return MaterialPageRoute(builder: (_) => SignUp());
        break;
      case "/home":
        return MaterialPageRoute(builder: (_) => HomePage());
        break;
      case "/account":
        return MaterialPageRoute(builder: (_) => Account());
        break;
      case "/event":
        return MaterialPageRoute(builder: (_) => EventDetails());
        break;
      case "/loading":
        return MaterialPageRoute(builder: (_) => LoadingScreen());
        break;
      case "/error":
        return MaterialPageRoute(builder: (_) => Error());
        break;

      default:
        return null;
        break;
    } // switch
  }// onGenerateRoute

  // Future<void> close() async {
  //     _authenticationBloc.close();
  // }// close
}
