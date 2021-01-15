import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class UserModel extends Equatable {

  const UserModel ({@required this.userID, @required this.email, @required this.firstName, @required this.lastName}) :
  assert(userID != null), assert(email != null);

  final String userID;
  final String email;
  final String firstName;
  final String lastName;

  static const empty = UserModel(userID: '', email: '', firstName: '', lastName: '');
  /// Used to tell if two user instances are "Equal" (a.k.a "Equatable")
  @override
  List<Object> get props => [this.userID];
}// User