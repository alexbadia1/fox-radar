import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:communitytabs/logic/cubits/cubits.dart';
import 'package:communitytabs/constants/marist_color_scheme.dart';

class LoginForm extends StatefulWidget {
  @override
  _LoginFormState createState() => _LoginFormState();

  final ScrollController controller;
  LoginForm({@required this.controller});
}

class _LoginFormState extends State<LoginForm> {
  final GlobalKey<FormState> _loginFormKey = new GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Form(
          key: _loginFormKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              /////////////////
              //////Email//////
              /////////////////
              Container(
                width: MediaQuery.of(context).size.width * .65,
                child: Focus(
                  onFocusChange: (hasFocus) {
                    if (hasFocus) {}
                  },
                  child: TextFormField(
                    textInputAction: TextInputAction.done,
                    decoration:
                        customTextField.copyWith(labelText: 'Marist Email'),
                    validator: (String value) {
                      value = value.trim();
                      return value.isEmpty
                          ? '\u26A0 Enter a MARIST email.'
                          : null;
                    },
                  ),
                ),
              ),
              /// Error Message goes here
              Container(
                child: Center(child: Text('')),
              ),

              ////////////////////
              //////Password//////
              ////////////////////
              BlocProvider<PasswordCubit>(
                create: (context) => PasswordCubit(),
                child: Builder(
                  builder: (context) {
                    context.watch<PasswordCubit>();
                    return Container(
                      width: MediaQuery.of(context).size.width * .65,
                      child: TextFormField(
                        textInputAction: TextInputAction.done,
                        obscureText: BlocProvider.of<PasswordCubit>(context)
                            .obscurePassword,
                        decoration: customTextField.copyWith(
                          labelText: 'Password',
                          suffixIcon: IconButton(
                            icon: !BlocProvider.of<PasswordCubit>(context)
                                    .obscurePassword
                                ? Icon(Icons.visibility)
                                : Icon(Icons.visibility_off),
                            onPressed: () {
                              BlocProvider.of<PasswordCubit>(context)
                                      .obscurePassword
                                  ? BlocProvider.of<PasswordCubit>(context)
                                      .setPasswordVisible()
                                  : BlocProvider.of<PasswordCubit>(context)
                                      .setPasswordHidden();
                            },
                          ),
                        ),
                        validator: (String value) {
                          value = value.trim();
                          return value.isEmpty
                              ? '\u26A0 Enter a password.'
                              : null;
                        },
                      ),
                    );
                  },
                ),
              ),

              /// Error Message goes here
              Container(
                child: Center(child: Text('')),
              ),
            ],
          ),
        ),
        Container(
          height: MediaQuery.of(context).size.height * .0475,
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
                    borderRadius: new BorderRadius.circular(10.0),
                    side: BorderSide(color: kHavenLightGray),
                  ),
                ),
              ),
              Expanded(
                child: SizedBox(),
              )
            ],
          ),
        ),
      ],
    );
  } // build

}
