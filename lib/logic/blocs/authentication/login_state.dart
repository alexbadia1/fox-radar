import 'package:flutter/material.dart';
import 'package:equatable/equatable.dart';
import 'package:authentication_repository/authentication_repository.dart';

abstract class LoginState extends Equatable {
  const LoginState();
}

class LoginStateLoginSubmitted extends LoginState {
  @override
  List<Object> get props => [];
}// LoginLoggedOut

class LoginStateLoggedIn extends LoginState {
  final UserModel user;

  LoginStateLoggedIn({@required this.user});

  @override
  List<Object> get props => [this.user];
}// LoginLoggedIn

class LoginStateLoggedOut extends LoginState {
  final String msg;
  LoginStateLoggedOut({this.msg});

  @override
  List<Object> get props => [this.msg];
}// LoginLoggedOut

