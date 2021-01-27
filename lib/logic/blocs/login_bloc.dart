import 'blocs.dart';
import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:communitytabs/logic/constants/enums.dart';
import 'package:authentication_repository/authentication_repository.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final AuthenticationRepository authenticationRepository;

  LoginBloc({@required this.authenticationRepository})
      : assert(authenticationRepository != null),
        super(LoginStateLoggedOut(msg: ''));

  @override
  Stream<LoginState> mapEventToState(LoginEvent loginEvent) async* {
    if (loginEvent is LoginEventLogin) {
      yield* _mapLoginEventLoginToState(loginEvent: loginEvent);
    } // else if

    else if (loginEvent is LoginEventLogout) {
      yield* _mapLoginEventLogoutToState();
    } // else-if
  } // mapEventToState

  Stream<LoginState> _mapLoginEventLoginToState({@required LoginEventLogin loginEvent}) async* {
    // Emit state to let user know the form is being processed
    // Probably should show a loading widget or something
    yield LoginStateLoginSubmitted();

    // Remove artificial delay
    // await Future.delayed(Duration(milliseconds: 3000));

    // Choose a sign in method to use...
    final UserModel user = await _mapLoginTypeToLoginMethod(loginEvent: loginEvent);

    // Ensure a firebase user was returned
    if (user != null) {
      yield LoginStateLoggedIn(user: user);
    } // if
    else {
      yield LoginStateLoggedOut(msg: "\u26A0 Login failed: Invalid username or password");
    } // else
  } // mapLoginEventLoginToState

  Stream<LoginState> _mapLoginEventLogoutToState() async* {
    // logout
    await this.authenticationRepository.signOut();

    yield LoginStateLoggedOut(msg: '');
  } // mapLoginEventLogoutToState

  Future<UserModel> _mapLoginTypeToLoginMethod({@required LoginEventLogin loginEvent}) async {

    /// TODO: Map more login types to login methods from the authentication repository
    if (loginEvent.loginType == LoginType.emailAndPassword) {
      // Returns UserModel on successful login
      // Returns null on failed login attempt
      return await this.authenticationRepository.signInWithEmailAndPassword(loginEvent.hashedEmail, loginEvent.hashedPassword);
    } // if

    // No login methods are supported (or perhaps even exists) for this login type.
    else {
      return null;
    } // else
  } // _mapLoginTypeToLoginMethod

  @override
  void onChange(Change<LoginState> change) {
    print('Login Bloc: $change');
    super.onChange(change);
  } // onChange

  @override
  Future<void> close() {
    return super.close();
  } // close
} // LoginBloc
