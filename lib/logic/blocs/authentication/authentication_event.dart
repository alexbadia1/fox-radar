import 'package:authentication_repository/authentication_repository.dart';
import 'package:equatable/equatable.dart';

abstract class AuthenticationEvent extends Equatable {
  @override
  List<Object> get props => [];
}// AuthenticationEvent

/// Authenticated
class AuthenticationStarted extends AuthenticationEvent {
}

/// Unauthenticated
class AuthenticationLoggedIn extends AuthenticationEvent {
  final UserModel user;

  AuthenticationLoggedIn(this.user);
}// AuthenticationLoggedIn

/// Authenticating
class AuthenticationLoggedOut extends AuthenticationEvent {

}// AuthenticationLoggedOut