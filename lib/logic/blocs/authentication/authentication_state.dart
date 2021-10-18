import 'dart:typed_data';

import 'package:equatable/equatable.dart';
import 'package:authentication_repository/authentication_repository.dart';

abstract class AuthenticationState extends Equatable {
  @override
  List<Object> get props => [];
}// AuthenticationState

/// Authenticated
class AuthenticationStateAuthenticated extends AuthenticationState {
  final UserModel user;
  final Uint8List imageBytes;
  AuthenticationStateAuthenticated(this.user, [this.imageBytes]);

  @override
  List<Object> get props => [user];
}// AuthenticationStateAuthenticated

/// Unauthenticated
class AuthenticationStateUnauthenticated extends AuthenticationState {
  @override
  List<Object> get props => [];
}// AuthenticationStateUnauthenticated

/// Authenticating
class AuthenticationStateAuthenticating extends AuthenticationState {
  @override
  List<Object> get props => [];
}// AuthenticationStateAuthenticating