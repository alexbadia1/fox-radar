import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class UserModel extends Equatable {
  String userID;
  String email;
  String _firstName = "";
  String _lastName = "";

  UserModel({@required this.userID, @required this.email})
      : assert(userID != null),
        assert(email != null) {
    int i = 0;

    // Get first name
    while (i < email.length && email[i] != ".") {
      this._firstName += email[i++];
    } // for
    if (this._firstName.isEmpty) {
      this._firstName = "User";
    }// if

    // Skip over the "."
    i++;

    // Get last name
    while (i < email.length && email[i] != "@") {
      this._lastName += email[i++];
    } // for
    if (this._lastName.isEmpty) {
      this._lastName = "";
    }// if
  } // UserModel

  UserModel.nullConstructor() {
    this.userID = "";
    this.email = "";
  }// UserModel.nullConstructor

  @override
  List<Object> get props => [this.userID];

  String get firstName => this._firstName;
} // User
