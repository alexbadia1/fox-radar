import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:communitytabs/logic/blocs/blocs.dart';
import 'package:communitytabs/screens/screens.dart';
import 'package:communitytabs/presentation/screens/screens.dart';
import 'package:communitytabs/presentation/routes/navigation.dart';
import 'package:authentication_repository/authentication_repository.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}// SplashScreen

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    final _authenticationRepository = RepositoryProvider.of<AuthenticationRepository>(context);

    return Builder(
      builder: (context) {
      final _authenticationBlocState = context.watch<AuthenticationBloc>().state;

      /// Authenticated
      if (_authenticationBlocState is AuthenticationStateAuthenticated) {
        print('Showing Marist App');
        return MaristApp(
          routeGenerator: RouteGenerator(
            authenticationRepository: _authenticationRepository,
            authenticationBloc: BlocProvider.of<AuthenticationBloc>(context),
            loginBloc: BlocProvider.of<LoginBloc>(context),
          ),
        );
      } // if

      /// UnAuthenticated
      else if (_authenticationBlocState is AuthenticationStateUnauthenticated) {
        print('User is now unauthenticated, showing login');
        return MaristAppAuthentication(
          routeGeneratorAuthentication: RouteGeneratorAuthentication(
            authenticationRepository: _authenticationRepository,
            authenticationBloc: BlocProvider.of<AuthenticationBloc>(context),
            loginBloc: BlocProvider.of<LoginBloc>(context),
            signUpBloc: SignUpBloc(
                authenticationRepository: _authenticationRepository),
          ),
        );
      } // else if

      /// Authenticating
      else if (_authenticationBlocState is AuthenticationStateAuthenticating) {
        return MaterialApp(home: LoadingScreen());
      } // else if
      else {
        return MaterialApp(
          home: Error(),
        );
      } // else
    },);
  }

  @override
  void dispose() {
    BlocProvider.of<LoginBloc>(context).close();
    BlocProvider.of<AuthenticationBloc>(context).close();
    super.dispose();
  }// dispose
} // _SplashScreenState
