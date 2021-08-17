import 'package:flutter/material.dart';
import 'package:communitytabs/logic/logic.dart';
import 'package:communitytabs/presentation/presentation.dart';
import 'package:authentication_repository/authentication_repository.dart';

class ViewsWrapper extends StatefulWidget {
  @override
  _ViewsWrapperState createState() => _ViewsWrapperState();
} // ViewsWrapper

class _ViewsWrapperState extends State<ViewsWrapper> {
  @override
  Widget build(BuildContext context) {
    final _authRepo = RepositoryProvider.of<AuthenticationRepository>(context);
    BlocProvider.of<DeviceNetworkBloc>(context).add(DeviceNetworkEventListen());
    return Builder(
      builder: (context) {
        final _authenticationBlocState = context.watch<AuthenticationBloc>().state;

        /// Authenticated
        ///
        /// Returns the main content/views of the app,
        /// which may vary depending on the type of user.
        if (_authenticationBlocState is AuthenticationStateAuthenticated) {
          return MainView(routeGeneratorMain: RouteGeneratorMain());
        } // if

        /// Unauthenticated
        ///
        /// Returns the authentication screens. For
        /// now just a basic login and sign up screen.
        else if (_authenticationBlocState is AuthenticationStateUnauthenticated) {
          return AuthView(
            /// Passing BloCs and Repositories to the
            /// RouteGenerator, so the RouteGenerator can wrap
            ///  MaterialPageRoutes with the appropriate logic/providers.
            routeGeneratorAuthentication: RouteGeneratorAuthentication(
              authenticationRepository: _authRepo,
              authenticationBloc: BlocProvider.of<AuthenticationBloc>(context),
              loginBloc: BlocProvider.of<LoginBloc>(context),
              signUpBloc: SignUpBloc(authenticationRepository: _authRepo),
            ),
          );
        } // else if

        /// Authenticating (Some Error Message)
        ///
        /// TODO: Show a splash screen while the app is authenticating the user
        /// along with any error messages (below the icon in the splash screen)
        return MaterialApp(
          home: SafeArea(
            child: Scaffold(
              body: Container(
                width: double.infinity,
                height: double.infinity,
                decoration: const BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: <Color>[
                      cWashedRed,
                      cFullRed,
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  } // builder

  @override
  void dispose() {
    BlocProvider.of<LoginBloc>(context).close();
    BlocProvider.of<AuthenticationBloc>(context).close();
    super.dispose();
  } // dispose
} // _ViewsWrapperState
