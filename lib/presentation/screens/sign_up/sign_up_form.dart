import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:communitytabs/logic/blocs/blocs.dart';
import 'package:communitytabs/logic/cubits/cubits.dart';
import 'package:communitytabs/logic/constants/enums.dart';
import 'package:communitytabs/constants/marist_color_scheme.dart';

class SignUpForm extends StatefulWidget {
  @override
  _SignUpFormState createState() => _SignUpFormState();
}// SignUpForm

class _SignUpFormState extends State<SignUpForm> {
  final GlobalKey<FormState> _signUpFormKeyEmail = new GlobalKey<FormState>();
  final GlobalKey<FormState> _signUpFormKeyPassword = new GlobalKey<FormState>();
  FocusNode emailFocusNode;
  FocusNode passwordFocusNode;
  TextEditingController emailTextEditingController;
  TextEditingController passwordTextEditingController;

  @override
  void initState() {
    super.initState();
    emailFocusNode = new FocusNode();
    emailFocusNode.addListener(() {
      if (!emailFocusNode.hasFocus) {
        _signUpFormKeyEmail.currentState.validate();
      } // if
    });

    passwordFocusNode = new FocusNode();
    passwordFocusNode.addListener(() {
      if (!passwordFocusNode.hasFocus) {
        _signUpFormKeyPassword.currentState.validate();
      } // if
    });

    emailTextEditingController = new TextEditingController();
    passwordTextEditingController = new TextEditingController();
  } // initState

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Expanded(
          flex: 2,
          child: SizedBox(),
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Form(
              key: _signUpFormKeyEmail,
              child: Container(
                width: MediaQuery.of(context).size.width * .65,
                child: TextFormField(
                  focusNode: emailFocusNode,
                  controller: emailTextEditingController,
                  textInputAction: TextInputAction.done,
                  decoration:
                  customTextField.copyWith(labelText: 'Marist Email'),
                  validator: (String email) {
                    // Missing password
                    if (email.isEmpty || email.contains(' ')) {
                      return '\u26A0 Enter a MARIST email.';
                    } // if

                    return null;
                  },
                ),
              ),
            ),
            Form(
              key: _signUpFormKeyPassword,
              child: BlocProvider<PasswordCubit>(
                create: (context) => PasswordCubit(),
                child: Builder(
                  builder: (context) {
                    context.watch<PasswordCubit>();
                    return Container(
                      width: MediaQuery.of(context).size.width * .65,
                      child: TextFormField(
                        focusNode: passwordFocusNode,
                        controller: passwordTextEditingController,
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
                        validator: (String password) {
                          // Missing password
                          if (password.isEmpty) {
                            return '\u26A0 Enter a password.';
                          } // if
                          // No Spaces
                          if (password.contains(' ')) {
                            return '\u26A0 Password cannot contain spaces.';
                          } // if
                          return null;
                        },
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
        Expanded(
          flex: 3,
          child: Container(
            child: Center(
              child: Builder(
                builder: (context) {
                  final _signUpState = context.watch<SignUpBloc>().state;

                  // Sign up failed
                  if (_signUpState is SignUpStateFailed) {
                    return Text('${_signUpState.msg}');
                  }// if

                  // Normal logged out
                  return Container();
                },
              ),
            ),
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
                  onPressed: () async {
                    if (_signUpFormKeyEmail.currentState.validate() &&
                        _signUpFormKeyPassword.currentState.validate()) {
                      BlocProvider.of<SignUpBloc>(context).add(
                          SignUpEventSignUp(
                            signUpType: SignUpType.emailAndPassword,
                            hashedEmail: emailTextEditingController.text,
                            hashedPassword: passwordTextEditingController.text,
                          ));
                    } // if
                  },
                ),
              ),
              Expanded(child: SizedBox())
            ],
          ),
        ),
      ],
    );
  } // build

  @override
  void dispose() {
    emailFocusNode.dispose();
    passwordFocusNode.dispose();
    emailTextEditingController.dispose();
    passwordTextEditingController.dispose();
    super.dispose();
  } // dispose

} // _LoginFormState