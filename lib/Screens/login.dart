import 'package:communitytabs/authentication//auth.dart';
import 'package:flutter/material.dart';
import 'package:communitytabs/colors/marist_color_scheme.dart';
import 'package:flutter/widgets.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {

  final AuthService _auth = new AuthService();
  final Image image1 = Image(
      image: AssetImage("images/image1.jpg"),
      fit: BoxFit.cover);

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    precacheImage(image1.image, context);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: image1
          ),
          Container(
            decoration: BoxDecoration (
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: <Color> [
                  cWashedRed,
                  cFullRed,
                ],
              ),
            ),

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.end,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[

                Expanded(flex: 13, child: SizedBox(),),

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
                    )
                  ),
                ),

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
                    )
                  )
                ),

                Expanded(flex: 9, child: SizedBox(),),

                Row(
                  children: <Widget>[
                    Expanded(child: SizedBox(),),
                    Container(
                      child: FlatButton(
                        color: kHavenLightGray,
                        onPressed: () async {
                          dynamic _result = await _auth.anonymousSignIn();
                          if (_result == null){
                            print('Error Signing In');
                          } else {
                            print('Sign in successful');
                            print(_result);
                          }
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
                            borderRadius: new BorderRadius.circular(5.0),
                            side: BorderSide(color: kHavenLightGray),
                        ),
                      ),
                    ),
                    Expanded(child: SizedBox(),),
                  ],
                ),

                Expanded(child: SizedBox(),),

                Container(
                  child: Row(
                    children: <Widget>[
                      Expanded(child: Divider(
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
                      Expanded(child: Divider(
                        thickness: 1.5,
                      )),
                    ],
                  ),
                ),

                Expanded(child: SizedBox(),),

                Container(
                  child: GestureDetector(
                    onTap: () async {
                      dynamic _result = await _auth.anonymousSignIn();
                      if (_result == null){
                        print('Error Signing In');
                      } else {
                        print('Sign in successful');
                        print(_result);
                        Navigator.pushReplacementNamed(context, '/loading');
                      }
                    },
                    child: Text(
                      'Continue as Guest',
                      style: TextStyle(
                        fontSize: 21.0,
                        fontFamily: 'Lato',
                        fontWeight: FontWeight.w400,
                        color: kHavenLightGray,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                  alignment: Alignment.center,
                ),

                Expanded(flex: 11, child: SizedBox(),),

              ],
            ),
          ),
        ],
      ),
    );
  }
}

