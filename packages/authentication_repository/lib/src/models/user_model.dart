import 'dart:typed_data';
import 'package:equatable/equatable.dart';

class UserModel extends Equatable {
  late String userID;
  late String email;
  late String? imagePath;
  late Uint8List? imageBytes;
  String _firstName = "";
  String _lastName = "";

  UserModel({
    this.imagePath,
    required this.userID,
    required this.email,
  }) {
    int i = 0;

    // Get first name
    while (i < email.length && email[i] != ".") {
      this._firstName += email[i++];
    }

    if (this._firstName.isEmpty) {
      this._firstName = "User";
    }

    // Skip over the "."
    i++;

    // Get last name
    while (i < email.length && email[i] != "@") {
      this._lastName += email[i++];
    }

    if (this._lastName.isEmpty) {
      this._lastName = "";
    }
  }

  UserModel.nullConstructor() {
    this.userID = "";
    this.email = "";
    this.imagePath = null;
  }

  @override
  List<Object?> get props => [this.userID];

  String get firstName => this._firstName;
  String get lastName => this._lastName;
}
