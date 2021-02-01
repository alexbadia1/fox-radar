import 'package:authentication_repository/authentication_repository.dart';
import 'package:communitytabs/presentation/routes/navigation_arguments.dart';
import 'package:communitytabs/presentation/screens/screens.dart';
import 'package:flutter/material.dart';
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
        return PageRouteBuilder(
            pageBuilder: (context, animation1,
                animation2) => HomeScreen(),
            maintainState: true
        );
        // return MaterialPageRoute(builder: (_) => HomeScreen());
        break;
      case "/account":
        return PageRouteBuilder(
            pageBuilder: (context, animation1,
                animation2) =>
                BlocProvider.value(
                  value: loginBloc,
                  child: AccountScreen(),
                ),
            maintainState: true
        );
        break;
      case "/event":
        final EventScreenArguments args = settings.arguments;
        return PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>
              EventScreen(eventId: args.documentId, imageBytes: args.imageBytes),
          transitionsBuilder:
              (context, animation, secondaryAnimation, child) {
            var begin = Offset(1.0, 0.0);
            var end = Offset.zero;
            var curve = Curves.ease;

            var tween = Tween(begin: begin, end: end)
                .chain(CurveTween(curve: curve));

            return SlideTransition(
              position: animation.drive(tween),
              child: child,
            );
          },
        );
        // return MaterialPageRoute(builder: (_) => EventScreen());
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
