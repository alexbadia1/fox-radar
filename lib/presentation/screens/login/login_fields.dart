import 'package:flutter/material.dart';
import 'package:communitytabs/logic/logic.dart';
import 'package:communitytabs/presentation/presentation.dart';

class EmailTextFormField extends StatelessWidget {
  const EmailTextFormField({
    Key key,
    @required GlobalKey<FormState> loginFormKeyEmail,
    @required this.emailFocusNode,
    @required this.emailTextEditingController,
  })  : _loginFormKeyEmail = loginFormKeyEmail,
        super(key: key);

  final GlobalKey<FormState> _loginFormKeyEmail;
  final FocusNode emailFocusNode;
  final TextEditingController emailTextEditingController;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _loginFormKeyEmail,
      child: TextFormField(
        focusNode: emailFocusNode,
        controller: emailTextEditingController,
        textInputAction: TextInputAction.done,
        decoration: customTextField.copyWith(labelText: 'Marist Email'),
        validator: (String email) {
          // Missing password
          if (email.isEmpty || email.contains(' ')) {
            return '\u26A0 Enter a MARIST email.';
          } // if

          return null;
        },
      ),
    );
  }// build
}// EmailTextFormField

class PasswordTextFormField extends StatelessWidget {
  const PasswordTextFormField({
    Key key,
    @required GlobalKey<FormState> loginFormKeyPassword,
    @required this.passwordFocusNode,
    @required this.passwordTextEditingController,
  }) : _loginFormKeyPassword = loginFormKeyPassword, super(key: key);

  final GlobalKey<FormState> _loginFormKeyPassword;
  final FocusNode passwordFocusNode;
  final TextEditingController passwordTextEditingController;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _loginFormKeyPassword,
      child: BlocProvider<PasswordCubit>(
        create: (context) => PasswordCubit(),
        child: Builder(
          builder: (context) {
            context.watch<PasswordCubit>();
            return TextFormField(
              focusNode: passwordFocusNode,
              controller: passwordTextEditingController,
              textInputAction: TextInputAction.done,
              obscureText: BlocProvider.of<PasswordCubit>(context).obscurePassword,
              decoration: customTextField.copyWith(
                labelText: 'Password',
                suffixIcon: IconButton(
                  icon: !BlocProvider.of<PasswordCubit>(context).obscurePassword ? Icon(Icons.visibility) : Icon(Icons.visibility_off),
                  onPressed: () {
                    BlocProvider.of<PasswordCubit>(context).obscurePassword
                        ? BlocProvider.of<PasswordCubit>(context).setPasswordVisible()
                        : BlocProvider.of<PasswordCubit>(context).setPasswordHidden();
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
            );
          },
        ),
      ),
    );
  }//  build
} // PasswordTextFormField
