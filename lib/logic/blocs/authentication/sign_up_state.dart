import 'package:flutter/material.dart';
import 'package:equatable/equatable.dart';

abstract class SignUpState extends Equatable{
  const SignUpState();
}//SignUpState

class SignUpStateSubmitted extends SignUpState {
  @override
  List<Object> get props => [];
}// SignUpSubmitted

class SignUpStateSuccessful extends SignUpState{
  @override
  List<Object> get props => [];
}// SignUpSuccessful

class SignUpStateFailed extends SignUpState{
  final msg;

  SignUpStateFailed({@required this.msg});

  @override
  List<Object> get props => [];
}// SignUpFailed

