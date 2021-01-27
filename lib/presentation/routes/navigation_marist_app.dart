import 'package:authentication_repository/authentication_repository.dart';
import 'package:database_repository/database_repository.dart';
import 'package:flutter/material.dart';
import 'package:communitytabs/wrappers.dart';
import 'package:communitytabs/screens/screens.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:communitytabs/logic/blocs/blocs.dart';

class RouteGenerator {
  final AuthenticationRepository authenticationRepository;
  final AuthenticationBloc authenticationBloc;
  final LoginBloc loginBloc;

  RouteGenerator(
      {@required this.authenticationRepository,
      @required this.authenticationBloc,
      @required this.loginBloc})
      : assert(authenticationRepository != null),
        assert(authenticationBloc != null),
        assert(loginBloc != null);

  Route onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case "/":
        return MaterialPageRoute(builder: (_) => HomePage());
        break;
      case "/account":
        return PageRouteBuilder(
            pageBuilder: (context, animation1,
                animation2) =>
                BlocProvider.value(
                  value: loginBloc,
                  child: Account(),
                ),
            maintainState: true
        );
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
  } // onGenerateRoute
}
