import 'dart:async';
import 'package:fox_radar/logic/logic.dart';
import 'package:authentication_repository/authentication_repository.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final AuthenticationRepository authenticationRepository;

  LoginBloc({required this.authenticationRepository})
      : super(LoginStateLoggedOut(msg: '')) {
    on<LoginEventLogin>((event, emit) {
      _mapLoginEventLoginToState(event, emit);
    });
    on<LoginEventLogout>((event, emit) {
      _mapLoginEventLogoutToState(emit);
    });
  }

  void _mapLoginEventLoginToState(
      LoginEventLogin loginEvent, Emitter<LoginState> e) async {
    // Emit state to let user know the form is being processed
    // Probably should show a loading widget or something
    e(LoginStateLoginSubmitted());

    // Remove artificial delay
    // await Future.delayed(Duration(milliseconds: 3000));

    // Choose a sign in method to use...
    final UserModel? user = await _mapLoginTypeToLoginMethod(loginEvent);

    // Ensure a firebase user was returned
    if (user != null) {
      e(LoginStateLoggedIn(user: user));
    } else {
      e(
        LoginStateLoggedOut(
          msg: "\u26A0 Login failed: Invalid username or password",
        ),
      );
    }
  }

  void _mapLoginEventLogoutToState(Emitter<LoginState> e) async {
    await this.authenticationRepository.signOut();
    e(LoginStateLoggedOut(msg: ''));
  }

  // TODO: Support more login methods from the authentication repository
  Future<UserModel?> _mapLoginTypeToLoginMethod(
      LoginEventLogin loginEvent) async {
    if (loginEvent.loginType == LoginType.emailAndPassword) {
      // Returns UserModel on successful login or null on failed login attempt
      return await this.authenticationRepository.signInWithEmailAndPassword(
          newEmail: loginEvent.hashedEmail,
          newPassword: loginEvent.hashedPassword);
    }

    // No login methods are supported (or even exist) for this login type.
    return null;
  }

  @override
  void onChange(Change<LoginState> change) {
    print('Login Bloc: $change');
    super.onChange(change);
  }

  @override
  Future<void> close() {
    return super.close();
  }
}
