import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fox_radar/logic/blocs/blocs.dart';
import 'package:fox_radar/presentation/presentation.dart';
import 'package:authentication_repository/authentication_repository.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
} // SignUpScreen

class _SignUpScreenState extends State<SignUpScreen> {
  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final screenPaddingBottom = MediaQuery.of(context).padding.bottom;
    final screenInsetsBottom = MediaQuery.of(context).viewInsets.bottom;
    final screenPaddingTop = MediaQuery.of(context).padding.top;

    final height = screenHeight - screenPaddingTop - screenPaddingBottom + screenInsetsBottom;

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

                /// Instantiate the [SignUpBloc] here, so the
                /// Back Icon Button can watch the [SignUpBlocState]
                child: BlocProvider<SignUpBloc>(
                  create: (BuildContext context) => SignUpBloc(
                    authenticationRepository: RepositoryProvider.of<AuthenticationRepository>(context),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Listener(
                        onPointerDown: (_) => FocusScope.of(context).unfocus(),
                        behavior: HitTestBehavior.opaque,
                        /// Container is used to match the top margin on the login screen
                        child: Container(
                          height: height * .12,
                        ),
                      ),

                      /// Back Button
                      /// Depending on whether the user just tried to
                      /// sign up, show or remove the [Back Button Icon].
                      Builder(
                        builder: (context) {
                          final SignUpState _signUpState = context.watch<SignUpBloc>().state;

                          if (_signUpState is SignUpStateSubmitted) {
                            return Container();
                          } // if

                          return GestureDetector(
                            onTap: () {
                              FocusScope.of(context).unfocus();
                              Navigator.pushReplacementNamed(context, '/login');
                            },
                            behavior: HitTestBehavior.opaque,
                            child: Padding(
                              padding: EdgeInsets.only(top: 2.0, left: screenWidth * .03),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: <Widget>[
                                  Icon(
                                    Icons.chevron_left,
                                    size: 28.0,
                                    color: kHavenLightGray,
                                  ),
                                  Text(
                                    'Back',
                                    textAlign: TextAlign.start,
                                    style: TextStyle(fontSize: 23.5, color: kHavenLightGray),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),

                      /// Title
                      Listener(
                        onPointerDown: (_) => FocusScope.of(context).unfocus(),
                        behavior: HitTestBehavior.opaque,
                        child: Container(
                          alignment: Alignment.centerLeft,
                          width: double.infinity,
                          child: Padding(
                            /// Padding should be the difference of font size between the Login Screen Title and Sign Up Screen Title
                            padding: EdgeInsets.only(left: screenWidth * .1),
                            child: Text(
                              'Sign Up',
                              textAlign: TextAlign.center,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontFamily: 'Lato',
                                fontWeight: FontWeight.w400,
                                fontSize: 44.0,
                                color: kHavenLightGray,
                              ),
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
                          child: Padding(
                            /// Padding should be the difference of font size between the Login Screen Subtitle and Sign Up Screen Subtitle
                            padding: EdgeInsets.only(left: screenWidth * .1),
                            child: Text(
                              'See the latest events!',
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                fontFamily: 'Lato',
                                fontWeight: FontWeight.w400,
                                fontSize: 16.0,
                                color: kHavenLightGray,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ),
                        ),
                      ),

                      Listener(
                        onPointerDown: (_) => FocusScope.of(context).unfocus(),
                        behavior: HitTestBehavior.opaque,
                        child: cVerticalMarginSmall(context),
                      ),

                      /// Show the sign up form, or loading widget
                      /// Depending on the [SignUpBlocState]
                      Builder(
                        builder: (context) {
                          final SignUpState _signUpState = context.watch<SignUpBloc>().state;

                          /// If login was submitted, show a loading
                          /// widget, while user waits for authentication.
                          if (_signUpState is SignUpStateSubmitted) {
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
                              SignUpForm(),
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
                                      'Already have an account? ',
                                      style: TextStyle(
                                        fontSize: 15.0,
                                        fontWeight: FontWeight.w400,
                                        color: kHavenLightGray,
                                      ),
                                    ),
                                    TextButton(
                                      child: Text(
                                        'Sign In',
                                        style: TextStyle(
                                          color: Colors.blueAccent,
                                          fontSize: 15.0,
                                        ),
                                      ),
                                      onPressed: () {
                                        FocusScope.of(context).unfocus();
                                        Navigator.of(context).pushReplacementNamed('/login');
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  } // build
} // _SignUpScreenState
