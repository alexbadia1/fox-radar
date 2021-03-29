import 'dart:ui';
import 'login_form.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:communitytabs/logic/blocs/blocs.dart';
import 'package:communitytabs/constants/marist_color_scheme.dart';
import 'package:authentication_repository/authentication_repository.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
} // LoginScreen

class _LoginScreenState extends State<LoginScreen> {
  Image backgroundImage;

  @override
  void initState() {
    super.initState();
    backgroundImage = new Image.asset("images/image1.jpg");
  } // initState

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    precacheImage(backgroundImage.image, context);
  } // didChangeDependencies

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final screenPaddingBottom = MediaQuery.of(context).padding.bottom;
    final screenInsetsBottom = MediaQuery.of(context).viewInsets.bottom;
    final screenPaddingTop = MediaQuery.of(context).padding.top;

    final height = screenHeight -
        screenPaddingTop -
        screenPaddingBottom +
        screenInsetsBottom;

    return SafeArea(
      child: Container(
        height: height + screenInsetsBottom,
        width: screenWidth,
        child: Stack(
          children: [
            backgroundImage,
            FullScreenGradient(
                gradient: cMaristGradientWashed,
                height: height + screenInsetsBottom),
            Scaffold(
              backgroundColor: Colors.transparent,
              body: SingleChildScrollView(
                physics: ClampingScrollPhysics(),
                child: Container(
                  height: height,
                  width: screenWidth,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment: MainAxisAlignment.end,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Expanded(
                        flex: 8,
                        child: Listener(
                            onPointerDown: (_) =>
                                FocusScope.of(context).unfocus(),
                            behavior: HitTestBehavior.opaque,
                            child: SizedBox()),
                      ),

                      /// Title
                      Listener(
                        onPointerDown: (_) => FocusScope.of(context).unfocus(),
                        behavior: HitTestBehavior.opaque,
                        child: Container(
                          child: Text(
                            'MARIST',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: 'Lato',
                              fontWeight: FontWeight.w400,
                              fontSize: 72.0,
                              letterSpacing: 1.5,
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
                          child: Text(
                            'See What\'s Going On',
                            textAlign: TextAlign.center,
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
                      // Container(width: 100, height: 100),

                      Expanded(
                        flex: 25,
                        child: BlocProvider(
                          create: (BuildContext context) => LoginBloc(
                            authenticationRepository:
                                RepositoryProvider.of<AuthenticationRepository>(
                                    context),
                          ),
                          child: Builder(
                            builder: (context) {
                              final LoginState _loginState =
                                  context.watch<LoginBloc>().state;

                              if (_loginState is LoginStateLoginSubmitted) {
                                return LoadingWidget(
                                  size: 90.0,
                                  color: kHavenLightGray,
                                );
                              } // if

                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                mainAxisAlignment: MainAxisAlignment.end,
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Expanded(
                                    flex: 21,
                                    child: LoginForm(),
                                    // LoginForm
                                  ),
                                  Listener(
                                    onPointerDown: (_) =>
                                        FocusScope.of(context).unfocus(),
                                    behavior: HitTestBehavior.opaque,
                                    child: SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              .015,
                                    ),
                                  ),
                                  Listener(
                                    onPointerDown: (_) =>
                                        FocusScope.of(context).unfocus(),
                                    behavior: HitTestBehavior.opaque,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        Text(
                                          'Don\'t have an account? ',
                                          style: TextStyle(
                                            fontSize: 12.0,
                                          ),
                                        ),
                                        InkWell(
                                          child: Text(
                                            'Sign Up',
                                            style: TextStyle(
                                              fontSize: 14.0,
                                              fontStyle: FontStyle.italic,
                                              fontWeight: FontWeight.bold,
                                              decoration:
                                                  TextDecoration.underline,
                                            ),
                                          ),
                                          onTap: () {
                                            FocusScope.of(context).unfocus();
                                            Navigator.of(context)
                                                .pushNamed('/sign_up');
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    child: Listener(
                                        onPointerDown: (_) =>
                                            FocusScope.of(context).unfocus(),
                                        behavior: HitTestBehavior.opaque,
                                        child: SizedBox()),
                                  ),
                                  Listener(
                                    onPointerDown: (_) =>
                                        FocusScope.of(context).unfocus(),
                                    behavior: HitTestBehavior.opaque,
                                    child: Container(
                                      child: Row(
                                        children: <Widget>[
                                          Expanded(
                                              child: Divider(
                                            thickness: 1.5,
                                          )),
                                          Container(
                                            child: Text(
                                              " OR ",
                                              style: TextStyle(
                                                fontWeight: FontWeight.normal,
                                                fontSize: 15.0,
                                                fontFamily: 'Lato',
                                                color: kHavenLightGray,
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                              child: Divider(
                                            thickness: 1.5,
                                          )),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Listener(
                                        onPointerDown: (_) =>
                                            FocusScope.of(context).unfocus(),
                                        behavior: HitTestBehavior.opaque,
                                        child: SizedBox()),
                                  ),
                                  Listener(
                                    onPointerDown: (_) =>
                                        FocusScope.of(context).unfocus(),
                                    behavior: HitTestBehavior.opaque,
                                    child: Container(
                                      child: GestureDetector(
                                        onTap: () async {
                                          FocusScope.of(context).unfocus();
                                        },
                                        child: Text(
                                          'Continue as Guest',
                                          style: TextStyle(
                                            fontSize: 17.0,
                                            fontFamily: 'Lato',
                                            fontWeight: FontWeight.w400,
                                            color: kHavenLightGray,
                                            decoration:
                                                TextDecoration.underline,
                                            fontStyle: FontStyle.italic,
                                          ),
                                        ),
                                      ),
                                      alignment: Alignment.center,
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                        ),
                      ),

                      Expanded(
                        flex: 9,
                        child: Listener(
                            onPointerDown: (_) =>
                                FocusScope.of(context).unfocus(),
                            behavior: HitTestBehavior.opaque,
                            child: SizedBox()),
                      ),
                      Listener(
                        onPointerDown: (_) => FocusScope.of(context).unfocus(),
                        behavior: HitTestBehavior.opaque,
                        child: SizedBox(
                          height: screenInsetsBottom,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  } // build
} // _LoginScreenState

/// **Screen width** is easy: [MediaQuery.of(context).size.width]
///
/// **Screen height** is more complicated:
///   + Screen height:
///     - [MediaQuery.of(context).size.height]
///   + Adjust for *Safe Area*:
///     - Subtract [MediaQuery.of(context).padding.top] and
///       [MediaQuery.of(context).padding.bottom] from the height
///   + Adjust for a keyboard
///     - Subtract [MediaQuery.of(context).viewInsets.bottom] from the height
///   + ToolbarHeight
///     - kToolbarHeight
