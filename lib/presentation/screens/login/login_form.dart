import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fox_radar/logic/logic.dart';
import 'package:fox_radar/presentation/presentation.dart';

class LoginForm extends StatefulWidget {
  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final GlobalKey<FormState> _loginFormKeyEmail = new GlobalKey<FormState>();
  final GlobalKey<FormState> _loginFormKeyPassword = new GlobalKey<FormState>();

  late FocusNode _emailFocusNode;
  late FocusNode _passwordFocusNode;
  late TextEditingController _emailTextEditingController;
  late TextEditingController _passwordTextEditingController;

  @override
  void initState() {
    super.initState();
    this._emailFocusNode = new FocusNode();
    this._emailFocusNode.addListener(() {
      if (!this._emailFocusNode.hasFocus) {
        this._loginFormKeyEmail.currentState?.validate();
      } // if
    });

    this._passwordFocusNode = new FocusNode();
    this._passwordFocusNode.addListener(() {
      if (!this._passwordFocusNode.hasFocus) {
        this._loginFormKeyPassword.currentState?.validate();
      } // if
    });

    this._emailTextEditingController = new TextEditingController();
    this._passwordTextEditingController = new TextEditingController();
  } // initState

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Column(
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
                      loginFormKeyEmail: this._loginFormKeyEmail,
                      emailFocusNode: this._emailFocusNode,
                      emailTextEditingController: this._emailTextEditingController,
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
                      loginFormKeyPassword: this._loginFormKeyPassword,
                      passwordFocusNode: this._passwordFocusNode,
                      passwordTextEditingController: this._passwordTextEditingController,
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
            final _loginState = context.watch<LoginBloc>().state;
            final _networkState = context.watch<DeviceNetworkBloc>().state;
            print("$_networkState");
            if (_networkState is DeviceNetworkStateNone) {
              return LoginMessage(msg: "\u26A0 No Internet Connection!");
            } // if
            else if (_loginState is LoginStateLoggedOut) {
              return LoginMessage(msg: _loginState.msg);
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
              Listener(
                onPointerDown: (_) => FocusScope.of(context).unfocus(),
                behavior: HitTestBehavior.opaque,
                child: Container(width: double.infinity),
              ),
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
                      'Login',
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
                        (this._loginFormKeyEmail.currentState?.validate() ?? false) &&
                        (this._loginFormKeyPassword.currentState?.validate() ?? false)) {
                      BlocProvider.of<LoginBloc>(context).add(
                        LoginEventLogin(
                          loginType: LoginType.emailAndPassword,
                          hashedEmail: this._emailTextEditingController.text.trim(),
                          hashedPassword: this._passwordTextEditingController.text.trim(),
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
    this._emailFocusNode.dispose();
    this._passwordFocusNode.dispose();
    this._emailTextEditingController.dispose();
    this._passwordTextEditingController.dispose();
    super.dispose();
  } // dispose
} // _LoginFormState

class LoginMessage extends StatelessWidget {
  final String? msg;
  const LoginMessage({
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
          child: Text(msg ?? "[LoginMessage]"),
        ),
      ),
    );
  } // build
} // LoginMessage
