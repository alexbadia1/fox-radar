import 'package:flutter/material.dart';
import 'package:fox_radar/logic/logic.dart';
import 'package:fox_radar/presentation/presentation.dart';
import 'package:authentication_repository/authentication_repository.dart';

class ViewsWrapper extends StatefulWidget {
  @override
  _ViewsWrapperState createState() => _ViewsWrapperState();
}

class _ViewsWrapperState extends State<ViewsWrapper> {
  @override
  Widget build(BuildContext context) {
    final _authRepo = RepositoryProvider.of<AuthenticationRepository>(context);
    return Builder(
      builder: (context) {
        final _authBlocState = context.watch<AuthenticationBloc>().state;

        /// Authenticated
        ///
        /// Returns the main content/views of the app,
        /// which may vary depending on the type of user.
        if (_authBlocState is AuthStateAuthenticated) {
          return MainView(routeGeneratorMain: RouteGeneratorMain());
        }

        /// Unauthenticated
        ///
        /// Returns the authentication screens. For
        /// now just a basic login and sign up screen.
        else if (_authBlocState is AuthStateUnauthenticated) {
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
        }

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
  }

  @override
  void dispose() {
    BlocProvider.of<LoginBloc>(context).close();
    BlocProvider.of<AuthenticationBloc>(context).close();
    super.dispose();
  }
}
