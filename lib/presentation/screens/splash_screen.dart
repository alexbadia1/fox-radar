import 'package:authentication_repository/authentication_repository.dart';
import 'package:communitytabs/presentation/routes/navigation_authentication.dart';
import 'package:communitytabs/presentation/screens/marist_app_authentication.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:communitytabs/logic/blocs/blocs.dart';
import 'package:communitytabs/screens/screens.dart';
import 'package:communitytabs/presentation/routes/navigation_marist_app.dart';
import 'package:communitytabs/presentation/screens/screens.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _authenticationRepository =
        RepositoryProvider.of<AuthenticationRepository>(context);

    return MultiBlocProvider(
      providers: [
        BlocProvider(
            create: (context) => AuthenticationBloc(_authenticationRepository)),
        BlocProvider(
            create: (context) =>
                LoginBloc(authenticationRepository: _authenticationRepository)),
      ],
      child: Builder(builder: (context) {
        final _authenticationBlocState =
            context.watch<AuthenticationBloc>().state;

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
        else if (_authenticationBlocState
            is AuthenticationStateAuthenticating) {
          return MaterialApp(home: LoadingScreen());
        } // else if
        else {
          return MaterialApp(
            home: Error(),
          );
        } // else
      }),
    );
  }
} // SplashScreen
