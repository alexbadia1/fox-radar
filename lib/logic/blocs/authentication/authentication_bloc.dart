import 'dart:async';
import 'authentication.dart';
import 'package:fox_radar/logic/logic.dart';
import 'package:authentication_repository/authentication_repository.dart';

class AuthenticationBloc extends Bloc<AuthenticationEvent, AuthenticationState> {
  final AuthenticationRepository _authenticationRepository;
  StreamSubscription? _userSubscription;

  AuthenticationBloc(AuthenticationRepository authenticationRepository)
      : _authenticationRepository = authenticationRepository,
        super(AuthenticationStateAuthenticating()) {
    this.add(AuthenticationStarted());
  }

  @override
  Stream<AuthenticationState> mapEventToState(AuthenticationEvent event) async* {
    if (event is AuthenticationStarted) {
      yield* _mapAuthenticationStartedToState();
    } else if (event is AuthenticationLoggedIn) {
      yield* _mapAuthenticationLoggedInToState(event.user);
    } else if (event is AuthenticationLoggedOut) {
      yield* _mapAuthenticationLoggedOutToState();
    }
  }

  // Check to see if the user is signed in...
  Stream<AuthenticationState> _mapAuthenticationStartedToState() async* {
    _userSubscription = _authenticationRepository.user.listen((UserModel user) {
      if (user != UserModel.nullConstructor()) {
        this.add(AuthenticationLoggedIn(user));
      }
      else {
        this.add(AuthenticationLoggedOut());
      }
    });
  }

  Stream<AuthenticationState> _mapAuthenticationLoggedInToState(UserModel? user) async* {
    yield AuthenticationStateAuthenticated(user);
  }

  Stream<AuthenticationState> _mapAuthenticationLoggedOutToState() async* {
    yield AuthenticationStateUnauthenticated();
  }

  @override
  Future<void> close() {
    _userSubscription?.cancel();
    return super.close();
  }
}
