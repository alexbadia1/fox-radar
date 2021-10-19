import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fox_radar/logic/logic.dart';
import 'package:fox_radar/presentation/presentation.dart';
import 'package:authentication_repository/authentication_repository.dart';

/// This is the route generator for authentication screens:
///   - Login
///   - Sign Up
class RouteGeneratorAuthentication {
  final AuthenticationRepository authenticationRepository;
  final AuthenticationBloc authenticationBloc;
  final LoginBloc loginBloc;
  final SignUpBloc signUpBloc;

  RouteGeneratorAuthentication(
      {@required this.authenticationRepository, @required this.authenticationBloc, @required this.loginBloc, @required this.signUpBloc})
      : assert(authenticationRepository != null),
        assert(authenticationBloc != null),
        assert(loginBloc != null),
        assert(signUpBloc != null);

  /// Maps each named route to a page route
  /// builder during each navigation, route
  /// settings can be used  to pass data between routes.
  Route onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {

      // Don't care about saving login screen state, so its ok to use navigator
      case "/login":
        return PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) => BlocProvider.value(value: loginBloc, child: LoginScreen()),
          transitionDuration: Duration(milliseconds: 0),
        );
        return MaterialPageRoute(
          builder: (context) => BlocProvider.value(value: signUpBloc, child: LoginScreen()),
        );

        // // Custom slide transition
        // return PageRouteBuilder(
        //   pageBuilder: (context, animation, secondaryAnimation) => BlocProvider.value(value: loginBloc, child: LoginScreen()),
        //   transitionsBuilder: (context, animation, secondaryAnimation, child) {
        //     var begin = Offset(-1, 0.0);
        //     var end = Offset.zero;
        //     var curve = Curves.easeIn;
        //
        //     var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        //
        //     return SlideTransition(
        //       position: animation.drive(tween),
        //       child: child,
        //     );
        //   },
        // );
        break;

      // Don't care about saving sign up screen state, so its ok to use navigator
      case "/sign_up":
        return PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) => BlocProvider.value(value: loginBloc, child: SignUpScreen()),
          transitionDuration: Duration(milliseconds: 0),
        );

        // // Custom slide transition
        // return PageRouteBuilder(
        //   pageBuilder: (context, animation, secondaryAnimation) =>
        //       BlocProvider.value(value: signUpBloc, child: SignUpScreen()),
        //   transitionsBuilder: (context, animation, secondaryAnimation, child) {
        //     var begin = Offset(1.0, 0.0);
        //     var end = Offset.zero;
        //     var curve = Curves.easeo;
        //
        //     var tween =
        //         Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        //
        //     return SlideTransition(
        //       position: animation.drive(tween),
        //       child: child,
        //     );
        //   },
        // );
        break;

      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
              appBar: AppBar(
                title: Text('Error'),
              ),
              body: Center(
                child: Text('ERROR'),
              )),
        );
        break;
    } // switch
  } // onGenerateRoute

  Future<void> close() async {
    signUpBloc.close();
  } // close
} // RouteGeneratorAuthentication
