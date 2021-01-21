import 'blocs.dart';
import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:communitytabs/logic/constants/enums.dart';
import 'package:authentication_repository/authentication_repository.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final AuthenticationBloc authenticationBloc;
  StreamSubscription _authenticationBlocSubscription;
  final AuthenticationRepository authenticationRepository;

  LoginBloc(
      {@required this.authenticationBloc,
      @required this.authenticationRepository})
      : assert(authenticationBloc != null),
        assert(authenticationRepository != null),
        super(LoginStateInitial());

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
    final UserModel user = await _mapLoginTypeToLoginMethod(loginEvent: loginEvent);

    // Ensure a firebase user was returned
    if (user != null) {
      yield LoginStateLoggedIn(user: user);
    } // if
    else {
      yield LoginStateLoggedOut();
    } // else
  } // mapLoginEventLoginToState

  Stream<LoginState> _mapLoginEventLogoutToState() async* {
    // logout
    await this.authenticationRepository.signOut();

    // Ensure user is signed out before emitting logged out state
    if (this.authenticationRepository.isSignedIn()) {
      yield LoginStateLoggedOut();
    } // if
    else {
      yield LoginStateLoggedIn();
    } // else
  } // mapLoginEventLogoutToState

  Future<UserModel> _mapLoginTypeToLoginMethod({@required LoginEventLogin loginEvent}) async {
    /// TODO: Map more login types to login methods from the authentication repository
    if (loginEvent.loginType == LoginType.emailAndPassword){
      // Returns UserModel on successful login
      // Returns null on failed login attempt
      return await this.authenticationRepository.signInWithEmailAndPassword(loginEvent.hashedEmail, loginEvent.hashedPassword);
    }// if

    // No login methods are supported (or perhaps even exists) for this login type.
    else {
      return null;
    }// else
  }// _mapLoginTypeToLoginMethod

  @override
  void onChange(Change<LoginState> change) {
    print('Login Bloc: $change');
    super.onChange(change);
  } // onChange

  @override
  Future<void> close() {
    this._authenticationBlocSubscription.cancel();
    return super.close();
  } // close
} // LoginBloc
