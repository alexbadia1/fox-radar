import 'dart:async';
import 'package:fox_radar/logic/logic.dart';
import 'package:authentication_repository/authentication_repository.dart';

class SignUpBloc extends Bloc<SignUpEvent, SignUpState> {
  final AuthenticationRepository authenticationRepository;

  SignUpBloc({required this.authenticationRepository})
      : super(SignUpStateFailed(''));

  @override
  Stream<SignUpState> mapEventToState(SignUpEvent signUpEvent) async* {
    if (signUpEvent is SignUpEventSignUp) {
      yield* _mapSignUpEventSignUpToState(signUpEvent);
    }
  }

  Stream<SignUpState> _mapSignUpEventSignUpToState (SignUpEventSignUp signUpEvent) async* {
    // Should trigger a loading widget
    yield SignUpStateSubmitted();

    // Try to sign up using authentication repository
    final UserModel? user = await _mapSignUpEventSignUpToSignUpMethod(signUpEvent);

    if (user != null) {

      UserModel? loggedInUser = await authenticationRepository.signInWithEmailAndPassword(
          newEmail: signUpEvent.hashedEmail,
          newPassword: signUpEvent.hashedPassword
      );

      if (loggedInUser != null) {
        yield SignUpStateSuccessful();
      } else {
        yield SignUpStateFailed('Sign Up Successful!');
      }
    } else {
      /// TODO: Indicate if the email already is in use!
      yield SignUpStateFailed('\u26A0 Sign up failed');
    }
  }

  Future<UserModel?> _mapSignUpEventSignUpToSignUpMethod(SignUpEventSignUp signUpEventSignUp) async {
    /// TODO: Implement more sign up methods that firebase provides
    if (signUpEventSignUp.signUpType == SignUpType.emailAndPassword) {
      return await authenticationRepository.signInWithEmailAndPassword(
          newEmail: signUpEventSignUp.hashedEmail,
          newPassword: signUpEventSignUp.hashedPassword
      );
    } else {
      return null;
    }
  }

  @override
  void onChange(Change<SignUpState> change) {
    print('Sign Up Bloc: $change');
    super.onChange(change);
  }

  @override
  Future<void> close() {
    return super.close();
  }
}
