import 'package:equatable/equatable.dart';

abstract class AuthenticationEvent extends Equatable {
  @override
  List<Object> get props => [];
}

/// Authenticated
class AuthenticationStarted extends AuthenticationEvent {
}

/// Unauthenticated
class AuthenticationLoggedIn extends AuthenticationEvent {}

/// Authenticating
class AuthenticationLoggedOut extends AuthenticationEvent {}