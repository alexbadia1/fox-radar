import 'package:communitytabs/wrappers.dart';
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
      final _authenticationBlocState = context.watch<AuthenticationBloc>().state;

      if (_authenticationBlocState is AuthenticationStateAuthenticated) {
        return HomePage();
      } // if
      else if (_authenticationBlocState is AuthenticationStateUnauthenticated) {
        print('User is now unauthenticated, showing login');
        return LoginScreen();
      } // else if
      else if (_authenticationBlocState is AuthenticationStateAuthenticating) {
        return LoadingScreen();
      } // else if
      else {
        return Error();
      } // else
    });
  } // build
} // SplashScreen
