import 'package:flutter/material.dart';

@immutable
abstract class PasswordState {}

class PasswordStateHidden extends PasswordState {
  final bool obscurePassword = true;
}

class PasswordStateVisible extends PasswordState {
  final bool obscurePassword = false;
}
