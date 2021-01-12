import 'dart:async';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'models/models.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  /// Create a firebase authentication object
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Create our own user object
  UserModel _createModelUserfromFirebaseCredentials({@required User user}) {
    return UserModel(userID: user.uid, email: user.email);
  }//_userFromFirebaseUser

  /// Listen to a firebase authentication stream and create a user model
  Stream<UserModel> get user {
      return _auth.authStateChanges().map((User user) {
        if (user != null) {
          return _createModelUserfromFirebaseCredentials(user: user);
        } // if
        else {
          return UserModel.empty;
        } // else
      });
  }//user

  /// Try an anonymous sign in
  Future anonymousSignIn() async {
    try{
      /// AuthResult changed to "UserCredential"
      UserCredential _userCredential = await _auth.signInAnonymously();

      /// FirebaseUser changed to "User"
      User _user = _userCredential.user;

      /// Create a model for the anonymous user
      return _createModelUserfromFirebaseCredentials(_user);
    } catch (Exception) {
      print(Exception.toString());
      return null;
    }
  }//anonymousSigIn

  //Email password sign in
  Future signInWithEmailAndPassword(String newEmail, String newPassword) async {
    try{
      AuthResult result = await _auth.signInWithEmailAndPassword(email: newEmail, password: newPassword);
      FirebaseUser user = result.user;
      return _userFromFirebaseUser(user);
    } catch (e) {
      print(e);
      return null;
    }
  }//signInWithEmailAndPassword

  //Register Email and password
  Future registerWithEmailAndPassword(String newEmail, String newPassword) async {
    try {
      //Contact Firebase to see if user exists
      print('Performing sign up task...');
      AuthResult result = await _auth.createUserWithEmailAndPassword(email: newEmail, password: newPassword);

      print('Recieved user sign up task results...');
      FirebaseUser user = result.user;

      //Create a new user account
      print('Creating new user in database...');
      await new DatabaseService(uid: user.uid).updateUserData(newEmail, newPassword);

      //Return user data received from Firebase
      print('Returning new firebase user');
      return _userFromFirebaseUser(user);

    } catch (e) {
      print('User returned null');
      print(e.toString());
      return null;
    }
  }//registerWithEmailAndPassword

  //sign out
  Future<void> signOut () async {
    try{
      await Future.wait(
          [_auth.signOut()]
      );
    } on Exception {
      throw LogoutFailure();
    }
  }//signOut
}

class LogoutFailure implements Exception{}