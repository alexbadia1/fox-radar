import 'package:flutter/material.dart';
import 'package:communitytabs/services/auth.dart';
import 'package:communitytabs/colors/marist_color_scheme.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final GlobalKey<FormState> _loginFormKey = new GlobalKey<FormState>();
  final AuthService _auth = new AuthService();
  String myError = '';
  String myEmail = '';
  String myPassword = '';
  String myConfirmPassword = '';
  bool loading = false;
  bool failedLogin = false;

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
                        fit: BoxFit.cover)),
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
                        flex: 4,
                        child: SizedBox(),
                      ),

                      Container(
                        height: MediaQuery.of(context).size.height * .10,
                        width: MediaQuery.of(context).size.width * .75,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            IconButton(
                              icon: Icon(Icons.chevron_left),
                              iconSize: 35.0,
                              color: kHavenLightGray,
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            ),
                            Container(
                              child: InkWell(
                                onTap: () {
                                  Navigator.pop(context);
                                },
                                child: Text(
                                  'Back',
                                  style: TextStyle(
                                      fontSize: 22.0,
                                      color: kHavenLightGray),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      ////////////////
                      /////Title/////
                      ///////////////
                      Center(
                        child: Container(
                          width: MediaQuery.of(context).size.width * .775,
                          child: Text(
                            'Sign Up',
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              fontFamily: 'Lato',
                              fontWeight: FontWeight.w400,
                              fontSize: 44.0,
                              color: kHavenLightGray,
                            ),
                          ),
                        ),
                      ),

                      ////////////////
                      ////Subtitle////
                      ////////////////
                      Center(
                        child: Container(
                          width: MediaQuery.of(context).size.width * .75,
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

                      ////////////////
                      //////Form//////
                      ////////////////
                      Expanded(
                        flex: 17,
                        child: Form(
                          key: _loginFormKey,
                          child: loading
                              ? LoadingWidget()
                              : Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: <Widget>[
                                    Container(
                                      width:
                                          MediaQuery.of(context).size.width * .75,
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
                                    Container(
                                      width:
                                          MediaQuery.of(context).size.width * .75,
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
                                          obscureText: true,
                                          decoration: customTextField.copyWith(
                                              labelText: 'New Password'),
                                          onChanged: (value) {
                                            setState(() {
                                              myPassword = value;
                                            });
                                          },
                                          validator: (String value) {
                                            value = value.trim();
                                            if (value.isNotEmpty) {
                                              return value.length < 6
                                                  ? '\u26A0 Should be at least 6 characters.'
                                                  : null;
                                            } else
                                              return '\u26A0 Enter a password.';
                                          },
                                        ),
                                      ),
                                    ),
                                    Container(
                                      width:
                                          MediaQuery.of(context).size.width * .75,
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
                                          obscureText: true,
                                          decoration: customTextField.copyWith(
                                              labelText: 'Confirm Password'),
                                          onChanged: (value) {
                                            setState(() {
                                              myConfirmPassword = value;
                                            });
                                          },
                                          validator: (String value) {
                                            value = value.trim();
                                            if (myConfirmPassword.isNotEmpty)
                                              return myPassword !=
                                                      myConfirmPassword
                                                  ? '\u26A0 Passwords must match.'
                                                  : null;
                                            else
                                              return '\u26A0 Confirm the new password.';
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
                        height: MediaQuery.of(context).size.height * .025,
                      ),

                      //////////////////////
                      ////Sign Up Button////
                      //////////////////////
                      Container(
                        height: MediaQuery.of(context).size.height * .05,
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              child: SizedBox(),
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width * .535,
                              child: FlatButton(
                                color: kHavenLightGray,
                                onPressed: () async {
                                  if (_loginFormKey.currentState.validate()) {
                                    setState(() {
                                      loading = true;
                                    });
                                    dynamic result =
                                        await _auth.registerWithEmailAndPassword(
                                            myEmail, myPassword);
                                    if (result == null) {
                                      setState(() {
                                        loading = false;
                                        failedLogin = true;
                                        myError =
                                            '\u26A0 An existing account already uses that email.';
                                      });
                                    } else
                                      failedLogin = false;
                                  }
                                },
                                child: Container(
                                  child: Text(
                                    'Sign Up',
                                    style: TextStyle(
                                      letterSpacing: 1.0,
                                      color: Colors.white,
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: new BorderRadius.circular(10.0),
                                  side: BorderSide(color: kHavenLightGray),
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            'Already have an account? ',
                            style: TextStyle(
                              fontSize: 12.0,
                            ),
                          ),
                          InkWell(
                            child: Text(
                              'Sign In',
                              style: TextStyle(
                                fontSize: 14.0,
                                fontStyle: FontStyle.italic,
                                fontWeight: FontWeight.bold,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                            onTap: () {
                              Navigator.pop(context);
                            },
                          ),
                        ],
                      ),
                      Expanded(
                        flex: 7,
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
