import 'dart:async';
import 'authentication_event.dart';
import 'authentication_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:authentication_repository/authentication_repository.dart';

/// Authentication Bloc
/// Purpose:
///   Responsible for authenticating the user
/// Input:
///   Authentication Events
/// Outputs:
///   Authentication States
class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  final AuthenticationRepository _authenticationRepository;
  StreamSubscription _userSubscription;

  AuthenticationBloc(AuthenticationRepository authenticationRepository)
      : _authenticationRepository = authenticationRepository,
        super(AuthenticationStateAuthenticating()) {
    this.add(AuthenticationStarted());
  }

  @override
  Stream<AuthenticationState> mapEventToState(
      AuthenticationEvent event) async* {
    if (event is AuthenticationStarted) {
      yield* _mapAuthenticationStartedToState();
    } // if

    if (event is AuthenticationLoggedIn) {
      yield* _mapAuthenticationLoggedInToState();
    } // else-if

    else if (event is AuthenticationLoggedOut) {
      yield* _mapAuthenticationLoggedOutToState();
    } // else-if
  } // mapEventToState

  /// Check to see if the user is signed in...
  Stream<AuthenticationState> _mapAuthenticationStartedToState() async* {
    _userSubscription = _authenticationRepository.user.listen((UserModel user) {
      if (user != UserModel.empty) {
        this.add(AuthenticationLoggedIn());
      } // if
      else {
        this.add(AuthenticationLoggedOut());
      } // else
    });
  } // _mapAuthenticationEventToState

  Stream<AuthenticationState> _mapAuthenticationLoggedInToState() async* {
    yield AuthenticationStateAuthenticated();
  } // _mapAuthenticationEventToState

  Stream<AuthenticationState> _mapAuthenticationLoggedOutToState() async* {
    yield AuthenticationStateUnauthenticated();
  } // _mapAuthenticationEventToState

  @override
  void onChange(Change<AuthenticationState> change) {
    print('Authentication Bloc: $change');
    super.onChange(change);
  } // onChange

  @override
  Future<void> close() {
    _userSubscription.cancel();
    return super.close();
  } // close
}
