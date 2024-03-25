import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fox_radar/logic/logic.dart';
import 'package:fox_radar/presentation/presentation.dart';

class SignUpForm extends StatefulWidget {
  @override
  _SignUpFormState createState() => _SignUpFormState();
} // SignUpForm

class _SignUpFormState extends State<SignUpForm> {
  final GlobalKey<FormState> _signUpFormKeyEmail = new GlobalKey<FormState>();
  final GlobalKey<FormState> _signUpFormKeyPassword = new GlobalKey<FormState>();
  FocusNode? emailFocusNode;
  FocusNode? passwordFocusNode;
  TextEditingController? emailTextEditingController;
  TextEditingController? passwordTextEditingController;

  @override
  void initState() {
    super.initState();
    emailFocusNode = new FocusNode();
    emailFocusNode!.addListener(() {
      if (!emailFocusNode!.hasFocus) {
        _signUpFormKeyEmail.currentState!.validate();
      } // if
    });

    passwordFocusNode = new FocusNode();
    passwordFocusNode!.addListener(() {
      if (!passwordFocusNode!.hasFocus) {
        _signUpFormKeyPassword.currentState!.validate();
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
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            IntrinsicHeight(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Listener(
                    onPointerDown: (_) => FocusScope.of(context).unfocus(),
                    behavior: HitTestBehavior.opaque,
                    child: Container(width: double.infinity),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * .65,
                    child: EmailTextFormField(
                      loginFormKeyEmail: this._signUpFormKeyEmail,
                      emailFocusNode: this.emailFocusNode!,
                      emailTextEditingController: this.emailTextEditingController!,
                    ),
                  ),
                ],
              ),
            ),
            IntrinsicHeight(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Listener(
                    onPointerDown: (_) => FocusScope.of(context).unfocus(),
                    behavior: HitTestBehavior.opaque,
                    child: Container(width: double.infinity),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * .65,
                    child: PasswordTextFormField(
                      loginFormKeyPassword: this._signUpFormKeyPassword,
                      passwordFocusNode: this.passwordFocusNode!,
                      passwordTextEditingController: this.passwordTextEditingController!,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        Listener(
          onPointerDown: (_) => FocusScope.of(context).unfocus(),
          behavior: HitTestBehavior.opaque,
          child: Builder(builder: (context) {
            final _signUpState = context.watch<SignUpBloc>().state;
            final _networkState = context.watch<DeviceNetworkBloc>().state;

            if (_networkState is DeviceNetworkStateNone) {
              return SignUpMessage(msg: "\u26A0 No Internet Connection!");
            } // if
            else if (_signUpState is SignUpStateFailed) {
              return SignUpMessage(msg: _signUpState.msg);
            } // if
            else {
              return cVerticalMarginSmall(context);
            } // else
          }),
        ),
        IntrinsicHeight(
          child: Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: MediaQuery.of(context).size.width * .535,
                child: TextButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(kHavenLightGray),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(10.0),
                        side: BorderSide(color: kHavenLightGray),
                      ),
                    ),
                  ),
                  child: Container(
                    child: Text(
                      'Sign Up',
                      style: TextStyle(
                        letterSpacing: 1.0,
                        color: Colors.white,
                        fontSize: 16.0,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  onPressed: () {
                    final _networkState = BlocProvider.of<DeviceNetworkBloc>(context).state;
                    if (!(_networkState is DeviceNetworkStateNone) &&
                        _signUpFormKeyEmail.currentState!.validate() &&
                        _signUpFormKeyPassword.currentState!.validate()) {
                      BlocProvider.of<SignUpBloc>(context).add(
                        SignUpEventSignUp(
                          signUpType: SignUpType.emailAndPassword,
                          hashedEmail: emailTextEditingController!.text.trim(),
                          hashedPassword: passwordTextEditingController!.text.trim(),
                        ),
                      );
                    } // if
                  },
                  onLongPress: () {}, // Do nothing, to let user cancel selection
                ),
              ),
            ],
          ),
        ),
      ],
    );
  } // build

  @override
  void dispose() {
    emailFocusNode?.dispose();
    passwordFocusNode?.dispose();
    emailTextEditingController?.dispose();
    passwordTextEditingController?.dispose();
    super.dispose();
  } // dispose
} // _SignUpFormState

class SignUpMessage extends StatelessWidget {
  final String msg;
  const SignUpMessage({
    Key? key,
    required this.msg,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.only(top: 16.0, bottom: 16.0),
          child: Text(this.msg),
        ),
      ),
    );
  } // build
} // SignUpMessage
