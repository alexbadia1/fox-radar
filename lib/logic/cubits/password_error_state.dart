import 'package:flutter/material.dart';

@immutable
abstract class PasswordErrorState {
  final msg = '';
}

class PasswordErrorNoError extends PasswordErrorState {
  final msg = '';
}// PasswordErrorInitial

class PasswordErrorEmpty extends PasswordErrorState {
  final msg = '\u26A0 Enter a password.';
}// PasswordErrorEmpty