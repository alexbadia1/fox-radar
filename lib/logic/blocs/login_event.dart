import 'package:flutter/material.dart';
import 'package:equatable/equatable.dart';
import 'package:communitytabs/logic/constants/enums.dart';

abstract class LoginEvent extends Equatable {
  const LoginEvent();
}// LoginEvent

class LoginEventLogin extends LoginEvent {
  final LoginType loginType;
  final hashedEmail;
  final hashedPassword;

  LoginEventLogin({@required this.hashedEmail, @required this.hashedPassword, @required this.loginType});

  @override
  List<Object> get props => [this.hashedEmail, this.hashedPassword];
}// LoginEventLogin

class LoginEventLogout extends LoginEvent {

  @override
  List<Object> get props => [];
}// LoginEventLogout