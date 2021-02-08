import 'dart:async';
import 'sign_up_state.dart';
import 'sign_up_event.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:communitytabs/logic/blocs/blocs.dart';
import 'package:communitytabs/logic/constants/enums.dart';
import 'package:authentication_repository/authentication_repository.dart';

class SignUpBloc extends Bloc<SignUpEvent, SignUpState> {
  final AuthenticationRepository authenticationRepository;

  SignUpBloc({@required this.authenticationRepository})
      : assert(authenticationRepository != null),
        super(SignUpStateFailed(msg: ''));

  @override
  Stream<SignUpState> mapEventToState(SignUpEvent signUpEvent) async* {
    if (signUpEvent is SignUpEventSignUp) {
      yield* _mapSignUpEventSignUpToState(signUpEvent: signUpEvent);
    }// if
  }// mapEventToState

  Stream<SignUpState> _mapSignUpEventSignUpToState ({@required SignUpEventSignUp signUpEvent}) async* {
    // Should trigger a loading widget
    yield SignUpStateSubmitted();

    // Try to sign up using authentication repository
    final UserModel user = await _mapSignUpEventSignUpToSignUpMethod(signUpEventSignUp: signUpEvent);

    if (user != null) {
      yield SignUpStateSuccessful();
    }// if
    else {
      /// TODO: Indicate if the email already is in use!
      yield SignUpStateFailed(msg: '\u26A0 Sign up failed');
    }// else
  }// _mapSignUpEventSignUpToState

  Future<UserModel> _mapSignUpEventSignUpToSignUpMethod({@required SignUpEventSignUp signUpEventSignUp}) async {
    /// TODO: Implement more sign up methods that firebase provides
    if (signUpEventSignUp.signUpType == SignUpType.emailAndPassword) {
      return await authenticationRepository.registerWithEmailAndPassword(signUpEventSignUp.hashedEmail, signUpEventSignUp.hashedPassword);
    }// if
    else {
      return null;
    }// else
  }// _mapSignUpEventSignUpToSignUpMethod

  @override
  void onChange(Change<SignUpState> change) {
    print('Sign Up Bloc: $change');
    super.onChange(change);
  } // onChange

  @override
  Future<void> close() {
    return super.close();
  } // close
}// SignUpBloc
