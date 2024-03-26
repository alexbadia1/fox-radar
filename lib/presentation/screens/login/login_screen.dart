import 'package:flutter/material.dart';
import 'package:fox_radar/logic/logic.dart';
import 'package:fox_radar/presentation/presentation.dart';
import 'package:authentication_repository/authentication_repository.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    final screenInsetsBottom = MediaQuery.of(context).viewInsets.bottom;
    final height =
        MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top - MediaQuery.of(context).padding.bottom + screenInsetsBottom;

    return SafeArea(
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image(
            image: AssetImage("images/image1.jpg"),
            fit: BoxFit.cover,
          ),
          FullScreenGradient(
            gradient: cMaristGradientWashed,
            height: double.infinity,
          ),
          Scaffold(
            backgroundColor: Colors.transparent,
            body: Container(
              height: double.infinity,
              child: SingleChildScrollView(
                physics: const ScrollPhysics(),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Listener(
                      onPointerDown: (_) => FocusScope.of(context).unfocus(),
                      behavior: HitTestBehavior.opaque,
                      child: SizedBox(height: height * .12),
                    ),

                    /// Title
                    Listener(
                      onPointerDown: (_) => FocusScope.of(context).unfocus(),
                      behavior: HitTestBehavior.opaque,
                      child: Container(
                        width: double.infinity,
                        child: Text(
                          'MARIST',
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontFamily: 'Lato',
                            fontWeight: FontWeight.w400,
                            fontSize: 72.0,
                            letterSpacing: 1.25,
                            color: kHavenLightGray,
                          ),
                        ),
                      ),
                    ),

                    /// Subtitle
                    Listener(
                      onPointerDown: (_) => FocusScope.of(context).unfocus(),
                      behavior: HitTestBehavior.opaque,
                      child: Container(
                        width: double.infinity,
                        child: Text(
                          'See What\'s Going On',
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontFamily: 'Lato',
                            fontWeight: FontWeight.w400,
                            fontSize: 18.0,
                            color: kHavenLightGray,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ),
                    ),

                    Listener(
                      onPointerDown: (_) => FocusScope.of(context).unfocus(),
                      behavior: HitTestBehavior.opaque,
                      child: cVerticalMarginSmall(context),
                    ),

                    /// Show the login form, or loading widget
                    /// Depending on the [LoginBlocState]
                    BlocProvider(
                      create: (BuildContext context) => LoginBloc(
                        authenticationRepository: RepositoryProvider.of<AuthenticationRepository>(context),
                      ),
                      child: Builder(
                        builder: (context) {
                          final LoginState _loginState = context.watch<LoginBloc>().state;

                          /// If login was submitted, show a loading
                          /// widget, while user waits for authentication.
                          if (_loginState is LoginStateLoginSubmitted) {
                            return Column(
                              children: [
                                cVerticalMarginSmall(context),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: LoadingWidget(
                                    size: 90.0,
                                    color: kHavenLightGray,
                                  ),
                                ),
                              ],
                            );
                          } // if

                          /// Login form wasn't submitted, show the form itself.
                          return Column(
                            children: [
                              LoginForm(),
                              Listener(
                                onPointerDown: (_) => FocusScope.of(context).unfocus(),
                                behavior: HitTestBehavior.opaque,
                                child: SizedBox(
                                  height: MediaQuery.of(context).size.height * .02,
                                ),
                              ),
                              Listener(
                                onPointerDown: (_) => FocusScope.of(context).unfocus(),
                                behavior: HitTestBehavior.opaque,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Text(
                                      'Don\'t have an account? ',
                                      style: TextStyle(
                                        fontSize: 15.0,
                                        fontWeight: FontWeight.w400,
                                        color: kHavenLightGray,
                                      ),
                                    ),
                                    TextButton(
                                      child: Text(
                                        'Sign Up',
                                        style: TextStyle(
                                          color: Colors.blueAccent,
                                          fontSize: 15.0,
                                        ),
                                      ),
                                      onPressed: () {
                                        FocusScope.of(context).unfocus();
                                        Navigator.of(context).pushNamed('/sign_up');
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
