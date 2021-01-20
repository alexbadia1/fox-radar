import 'package:equatable/equatable.dart';
import 'package:authentication_repository/authentication_repository.dart';

abstract class AuthenticationState extends Equatable {
  @override
  List<Object> get props => [];
}

/// Authenticated
class AuthenticationStateAuthenticated extends AuthenticationState {
  final UserModel user;
  AuthenticationStateAuthenticated({this.user});

  @override
  List<Object> get props => [user];

}

/// Unauthenticated
class AuthenticationStateUnauthenticated extends AuthenticationState {
  @override
  List<Object> get props => [];
}

/// Authenticating
class AuthenticationStateAuthenticating extends AuthenticationState {
  @override
  List<Object> get props => [];
}