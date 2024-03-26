import 'dart:typed_data';
import 'package:equatable/equatable.dart';
import 'package:authentication_repository/authentication_repository.dart';

abstract class AuthState extends Equatable {
  @override
  List<Object?> get props => [];
}

class AuthStateAuthenticated extends AuthState {
  final UserModel? user;
  final Uint8List? imageBytes;
  AuthStateAuthenticated(this.user, [this.imageBytes]);

  @override
  List<Object?> get props => [user];
}

class AuthStateUnauthenticated extends AuthState {
  @override
  List<Object?> get props => [];
}

class AuthStateAuthenticating extends AuthState {
  @override
  List<Object?> get props => [];
}
