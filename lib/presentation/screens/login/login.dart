import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:communitytabs/constants/marist_color_scheme.dart';
import 'package:flutter/widgets.dart';

import 'login_form.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  ScrollController scrollController = new ScrollController();

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
      child: Scaffold(
        backgroundColor: cWashedRed,
        body: SingleChildScrollView(
          controller: scrollController,
          child: Container(
            height: height,
            child: Stack(
              clipBehavior: Clip.hardEdge,
              children: <Widget>[
                Container(
                  height: screenHeight,
                  width: screenWidth,
                  decoration: BoxDecoration(
                    color: kHavenLightGray
                  ),
                  // child: Image(
                  //     image: AssetImage("images/image1.jpg"),
                  //     fit: BoxFit.cover),
                ),
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: <Color>[
                        cWashedRed,
                        cFullRed,
                      ],
                    ),
                  ),

                  /////////////////////
                  /////Page Header/////
                  /////////////////////
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment: MainAxisAlignment.end,
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      Expanded(
                        flex: 9,
                        child: SizedBox(),
                      ),

                      ////////////////
                      /////Title/////
                      ///////////////
                      Container(
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

                      ////////////////
                      ////Subtitle////
                      ////////////////
                      Container(
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
                       // Container(width: 100, height: 100),
                      Expanded(flex: 17, child: LoginForm(controller: scrollController,)),

                      SizedBox(
                        height: MediaQuery.of(context).size.height * .015,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
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
                                decoration: TextDecoration.underline,
                              ),
                            ),
                            onTap: () {
                              // Navigator.of(context).push(slideInRight());
                            },
                          ),
                        ],
                      ),
                      Expanded(
                        child: SizedBox(),
                      ),
                      Container(
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
                      Expanded(
                        child: SizedBox(),
                      ),
                      Container(
                        child: GestureDetector(
                          onTap: () async {
                            //   dynamic _result =
                            //       await _auth.anonymousSignIn();
                            //   if (_result == null) {
                            //     setState(() {
                            //       loading = false;
                            //     });
                            //     print('Error Signing In');
                            //   } else {
                            //     print('Sign in successful');
                            //     print(_result);
                            //     Navigator.pushReplacementNamed(
                            //         context, '/loading');
                            //     FocusScope.of(context).unfocus();
                            //   }
                          },
                          child: Text(
                            'Continue as Guest',
                            style: TextStyle(
                              fontSize: 18.0,
                              fontFamily: 'Lato',
                              fontWeight: FontWeight.w400,
                              color: kHavenLightGray,
                              decoration: TextDecoration.underline,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ),
                        alignment: Alignment.center,
                      ),
                      Expanded(
                        flex: 9,
                        child: SizedBox(),
                      ),
                      SizedBox(
                        height: screenInsetsBottom,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }
}

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
