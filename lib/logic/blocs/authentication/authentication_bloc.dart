import 'dart:async';
import 'package:fox_radar/logic/logic.dart';
import 'package:authentication_repository/authentication_repository.dart';

class AuthenticationBloc extends Bloc<AuthEvent, AuthState> {
  final AuthenticationRepository _authRepo;
  StreamSubscription? _userSubscription;

  AuthenticationBloc(AuthenticationRepository authRepo)
      : _authRepo = authRepo,
        super(AuthStateAuthenticating()) {
    on<AuthStarted>((event, emit) async {
      Authenticating();
    });
    on<AuthLoggedIn>((event, emit) async {
      LoggedIn(event.user, emit);
    });
    on<AuthLoggedOut>((event, emit) async {
      LoggedOut(emit);
    });
  }

  void Authenticating() {
    _userSubscription = _authRepo.user.listen((UserModel user) {
      if (user != UserModel.nullConstructor()) {
        this.add(AuthLoggedIn(user));
      } else {
        this.add(AuthLoggedOut());
      }
    });
  }

  void LoggedIn(UserModel? user, Emitter<AuthState> e) {
    e(AuthStateAuthenticated(user));
  }

  void LoggedOut(Emitter<AuthState> e) {
    e(AuthStateUnauthenticated());
  }

  @override
  Future<void> close() {
    _userSubscription?.cancel();
    return super.close();
  }
}
