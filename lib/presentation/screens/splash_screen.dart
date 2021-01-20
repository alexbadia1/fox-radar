import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:communitytabs/logic/blocs/blocs.dart';
import 'package:communitytabs/screens/screens.dart';
import 'package:communitytabs/presentation/routes/navigation.dart';
import 'package:communitytabs/presentation/screens/screens.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      final AuthenticationState authenticationBlocState =
          context.watch<AuthenticationBloc>().state;

      /// Unauthenticated, show login screen
      if (authenticationBlocState is AuthenticationStateUnauthenticated) {
        return MaristApp(
          initialRoute: '/login',
          routeGenerator: RouteGenerator(),
        );
      }// if

      /// Authenticated, show home screen
      else if (authenticationBlocState is AuthenticationStateAuthenticated) {
        return MaristApp(
          initialRoute: '/signUp',
          routeGenerator: RouteGenerator(),
        );
      }// else-if

      /// Authenticating
      else if (authenticationBlocState is AuthenticationStateAuthenticating) {
        BlocProvider.of<AuthenticationBloc>(context)
            .add(AuthenticationStarted());
        return MaterialApp(
          home: LoadingScreen(),
        );
      } // else-if

      /// Error in authentication states, dummy
      return MaristApp(
        initialRoute: '/error',
        routeGenerator: RouteGenerator(),
      );
    });
  }// build
}// SplashScreen