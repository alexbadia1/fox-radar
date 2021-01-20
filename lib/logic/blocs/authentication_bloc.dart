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
class AuthenticationBloc extends Bloc<AuthenticationEvent, AuthenticationState> {
  final AuthenticationRepository _authenticationRepository;

  AuthenticationBloc(AuthenticationRepository authenticationRepository) :
        _authenticationRepository = authenticationRepository, super(AuthenticationStateAuthenticating());

  @override
  Stream<AuthenticationState> mapEventToState(AuthenticationEvent event) async* {
    if (event is AuthenticationStarted) {
      yield* _mapAuthenticationStartedToState();
    }// if

    else if (event is AuthenticationLoggedIn) {
      yield* _mapAuthenticationLoggedInToState();
    }// else-if

    else if (event is AuthenticationLoggedOut) {
      yield* _mapAuthenticationLoggedOutToState();
    }// else-if
  }// mapEventToState

  /// Check to see if the user is signed in...
  Stream<AuthenticationState> _mapAuthenticationStartedToState () async* {
    final bool isSignedIn = _authenticationRepository.isSignedIn();

    if (isSignedIn) {
      final UserModel firebaseUser = _authenticationRepository.getUser();
      yield AuthenticationStateAuthenticated(user: firebaseUser );
    }// if
    else {
      yield AuthenticationStateUnauthenticated();
    }// else
  }// _mapAuthenticationEventToState

  Stream<AuthenticationState> _mapAuthenticationLoggedInToState() async* {
    yield AuthenticationStateAuthenticated();
  }// _mapAuthenticationEventToState

  Stream<AuthenticationState> _mapAuthenticationLoggedOutToState() async* {
    yield AuthenticationStateUnauthenticated();
    //_authenticationRepository.signOut();
  }// _mapAuthenticationEventToState

@override
  void onChange(Change<AuthenticationState> change) {
    // TODO: implement onChange
    print('$change');
    super.onChange(change);
  }
}