import 'dart:async';
import 'package:fox_radar/logic/logic.dart';
import 'package:authentication_repository/authentication_repository.dart';

class SignUpBloc extends Bloc<SignUpEvent, SignUpState> {
  final AuthenticationRepository authenticationRepository;

  SignUpBloc({required this.authenticationRepository})
      : super(SignUpStateFailed('')) {
    on<SignUpEventSignUp>((event, emit) {
      _mapSignUpEventSignUpToState(event, emit);
    });
  }

  void _mapSignUpEventSignUpToState(
    SignUpEventSignUp signUpEvent,
    Emitter<SignUpState> e,
  ) async {
    // Should trigger a loading widget
    e(SignUpStateSubmitted());

    // Try to sign up using authentication repository
    final UserModel? user =
        await _mapSignUpEventSignUpToSignUpMethod(signUpEvent);

    if (user != null) {
      UserModel? loggedInUser =
          await authenticationRepository.signInWithEmailAndPassword(
        newEmail: signUpEvent.hashedEmail,
        newPassword: signUpEvent.hashedPassword,
      );

      if (loggedInUser != null) {
        e(SignUpStateSuccessful());
      } else {
        e(SignUpStateFailed('Sign Up Successful!'));
      }
    } else {
      // TODO: Indicate if the email already is in use!
      e(SignUpStateFailed('\u26A0 Sign up failed'));
    }
  }

  // TODO: Implement more sign up methods that firebase provides
  Future<UserModel?> _mapSignUpEventSignUpToSignUpMethod(
      SignUpEventSignUp signUpEventSignUp) async {
    if (signUpEventSignUp.signUpType == SignUpType.emailAndPassword) {
      return await authenticationRepository.signInWithEmailAndPassword(
        newEmail: signUpEventSignUp.hashedEmail,
        newPassword: signUpEventSignUp.hashedPassword,
      );
    }
    return null;
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
