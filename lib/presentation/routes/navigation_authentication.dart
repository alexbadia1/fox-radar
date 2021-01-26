import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:communitytabs/logic/blocs/blocs.dart';
import 'package:communitytabs/presentation/screens/screens.dart';
import 'package:authentication_repository/authentication_repository.dart';

class RouteGeneratorAuthentication {
  final AuthenticationRepository authenticationRepository;
  final AuthenticationBloc authenticationBloc;
  final LoginBloc loginBloc;
  final SignUpBloc signUpBloc;

  RouteGeneratorAuthentication(
      {@required this.authenticationRepository,
      @required this.authenticationBloc,
      @required this.loginBloc,
      @required this.signUpBloc})
      : assert(authenticationRepository != null),
        assert(authenticationBloc != null),
        assert(loginBloc != null),
        assert(signUpBloc != null);

  Route onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case "/login":
        return MaterialPageRoute(builder: (context) => BlocProvider.value(value: loginBloc, child: LoginScreen()));
        break;
      case "/sign_up":
        return PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>
              BlocProvider.value(value: signUpBloc, child: SignUpScreen()),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            var begin = Offset(1.0, 0.0);
            var end = Offset.zero;
            var curve = Curves.ease;

            var tween =
                Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

            return SlideTransition(
              position: animation.drive(tween),
              child: child,
            );
          },
        );
        break;
      default:
        return null;
        break;
    } // switch
  } // onGenerateRoute

  Future<void> close() async {
    loginBloc.close();
  } // close
} // RouteGeneratorAuthentication
