import 'package:flutter/material.dart';

@immutable
abstract class PasswordState {}// PasswordState

class PasswordStateHidden extends PasswordState {
  final bool obscurePassword = true;
}// PasswordHidden

class PasswordStateVisible extends PasswordState {
  final bool obscurePassword = false;
}// PasswordVisible
