import 'package:communitytabs/Navigation/transitions.dart';
import 'package:communitytabs/services/deprecated_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:communitytabs/constants/marist_color_scheme.dart';
import 'package:flutter/widgets.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final GlobalKey<FormState> _loginFormKey = new GlobalKey<FormState>();

  String myError = '';
  String myEmail = '';
  String myPassword = '';
  bool loading = false;
  bool failedLogin = false;
  bool _showPassword = false;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height,
            child: Stack(
              children: <Widget>[
                Container(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  child: Image(
                      image: AssetImage("images/image1.jpg"),
                      fit: BoxFit.cover),
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

                      ////////////////
                      //////Form//////
                      ////////////////
                      loading
                          ? Container(
                              height: MediaQuery.of(context).size.height * .15,
                            )
                          : Expanded(
                              flex: 17,
                              child: Form(
                                key: _loginFormKey,
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: <Widget>[
                                    /////////////////
                                    //////Email//////
                                    /////////////////
                                    Container(
                                      width: MediaQuery.of(context).size.width *
                                          .65,
                                      child: Focus(
                                        onFocusChange: (hasFocus) {
                                          if (hasFocus) {
                                            setState(() {
                                              failedLogin = false;
                                            });
                                          }
                                        },
                                        child: TextFormField(
                                          initialValue: myEmail,
                                          textInputAction: TextInputAction.done,
                                          decoration: customTextField.copyWith(
                                              labelText: 'Marist Email'),
                                          onChanged: (value) {
                                            setState(() {
                                              myEmail = value;
                                            });
                                          },
                                          validator: (String value) {
                                            value = value.trim();
                                            return value.isEmpty
                                                ? '\u26A0 Enter a MARIST email.'
                                                : null;
                                          },
                                        ),
                                      ),
                                    ),

                                    ////////////////////
                                    //////Password//////
                                    ////////////////////
                                    Container(
                                      width: MediaQuery.of(context).size.width *
                                          .65,
                                      child: Focus(
                                        onFocusChange: (hasFocus) {
                                          if (hasFocus) {
                                            setState(() {
                                              failedLogin = false;
                                            });
                                          }
                                        },
                                        child: TextFormField(
                                          textInputAction: TextInputAction.done,
                                          obscureText: !_showPassword,
                                          decoration: customTextField.copyWith(
                                              labelText: 'Password',
                                              suffixIcon: IconButton(
                                                  icon: _showPassword ? Icon(Icons.visibility): Icon(Icons.visibility_off),
                                              onPressed: () {
                                                    setState(() {
                                                      _showPassword = !_showPassword;
                                                    });
                                              },),
                                          ),
                                          onChanged: (value) {
                                            setState(() {
                                              myPassword = value;
                                            });
                                          },
                                          validator: (String value) {
                                            value = value.trim();
                                            return value.isEmpty
                                                ? '\u26A0 Enter a password.'
                                                : null;
                                          },
                                        ),
                                      ),
                                    ),
                                    Container(
                                      child: failedLogin
                                          ? Center(child: Text(myError))
                                          : SizedBox(),
                                    ),
                                  ],
                                ),
                              ),
                            ),

                      SizedBox(
                        height: MediaQuery.of(context).size.height * .02,
                      ),
                      ////////////////////////
                      //////Login Button//////
                      ////////////////////////
                      loading
                          ? LoadingWidget()
                          : Container(
                              height:
                                  MediaQuery.of(context).size.height * .0475,
                              child: Row(
                                children: <Widget>[
                                  Expanded(
                                    child: SizedBox(),
                                  ),
                                  Container(
                                    width: MediaQuery.of(context).size.width *
                                        .535,
                                    child: FlatButton(
                                      color: kHavenLightGray,
                                      onPressed: () async {
                                        // if (_loginFormKey.currentState.validate()) {
                                        //   setState(() {loading = true;});
                                        //
                                        //   dynamic result = await _auth.signInWithEmailAndPassword(myEmail, myPassword);
                                        //
                                        //   if (result == null) {
                                        //     print('Error Signing In User.');
                                        //     setState(() {
                                        //       loading = false;
                                        //       myError =
                                        //           "\u26A0 Incorrect email and/or password.";
                                        //       failedLogin = true;
                                        //     });
                                        //   } else {
                                        //     setState(() {
                                        //       failedLogin = false;
                                        //     });
                                        //   }
                                        // }
                                      },
                                      child: Container(
                                        child: Text(
                                          'Login',
                                          style: TextStyle(
                                            letterSpacing: 1.0,
                                            color: Colors.white,
                                            fontSize: 18.0,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            new BorderRadius.circular(10.0),
                                        side:
                                            BorderSide(color: kHavenLightGray),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: SizedBox(),
                                  ),
                                ],
                              ),
                            ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * .015,
                      ),
                      loading
                          ? Container()
                          : Row(
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
                                    Navigator.of(context).push(slideInRight());
                                  },
                                ),
                              ],
                            ),
                      Expanded(
                        child: SizedBox(),
                      ),
                      loading
                          ? Container()
                          : Container(
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
                      loading
                          ? Container()
                          : Container(
                              child: GestureDetector(
                                onTap: () async {
                                  setState(() {
                                    loading = true;
                                  });
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
}
