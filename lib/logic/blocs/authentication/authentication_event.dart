import 'package:authentication_repository/authentication_repository.dart';
import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class AuthStarted extends AuthEvent {}

class AuthLoggedIn extends AuthEvent {
  final UserModel? user;
  AuthLoggedIn(this.user);
}

class AuthLoggedOut extends AuthEvent {}
