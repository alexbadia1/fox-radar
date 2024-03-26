import 'package:equatable/equatable.dart';
import 'package:authentication_repository/authentication_repository.dart';

abstract class LoginState extends Equatable {
  const LoginState();
}

class LoginStateLoginSubmitted extends LoginState {
  @override
  List<Object?> get props => [];
}

class LoginStateLoggedIn extends LoginState {
  final UserModel? user;

  LoginStateLoggedIn({required this.user});

  @override
  List<Object?> get props => [this.user];
}

class LoginStateLoggedOut extends LoginState {
  final String? msg;
  LoginStateLoggedOut({this.msg});

  @override
  List<Object?> get props => [this.msg];
}
