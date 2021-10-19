import 'dart:async';
import 'models/models.dart';
import 'package:meta/meta.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthenticationRepository {
  // Singleton
  static final AuthenticationRepository _authenticationRepository = AuthenticationRepository._internal();

  /// Create a firebase authentication object
  final FirebaseAuth _auth = FirebaseAuth.instance;

  factory AuthenticationRepository() {
    return _authenticationRepository;
  } // DatabaseRepository

  AuthenticationRepository._internal();

  /// Create our own user object
  UserModel _createModelUserFromFirebaseCredentials({@required user}) {
    return UserModel(userID: user.uid, email: user.email);
  } //_userFromFirebaseUser

  /// Listen to a firebase authentication stream and create a user model
  Stream<UserModel> get user {
    return _auth.authStateChanges().map((User user) {
      print(user);
      if (user != null) {
        return _createModelUserFromFirebaseCredentials(user: user);
      } // if
      else {
        return UserModel.nullConstructor();
      } // else
    });
  } //user

  /// Try an anonymous sign in
  Future anonymousSignIn() async {
    try {
      /// AuthResult changed to "UserCredential"
      UserCredential _userCredential = await _auth.signInAnonymously();

      /// FirebaseUser changed to "User"
      User user = _userCredential.user;

      /// Create a model for the anonymous user
      return _createModelUserFromFirebaseCredentials(user: user);
    } catch (Exception) {
      print(Exception.toString());
      return null;
    }
  } //anonymousSigIn

  bool isSignedIn() {
    return _auth.currentUser != null;
  } // isSignedIn

  UserModel getUserModel() {
    return _createModelUserFromFirebaseCredentials(user: _auth.currentUser);
  } // getUser

  /// Try an anonymous sign in
  Future<UserModel> signIn() async {
    try {
      /// AuthResult changed to "UserCredential"
      UserCredential _userCredential = await _auth.signInWithEmailAndPassword(email: '', password: '');

      /// FirebaseUser changed to "User"
      User user = _userCredential.user;

      /// Create a model for the anonymous user
      return _createModelUserFromFirebaseCredentials(user: user);
    } catch (Exception) {
      print(Exception.toString());
      return null;
    }
  } //anonymousSigIn

  /// Email Password login
  Future signInWithEmailAndPassword(String newEmail, String newPassword) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(email: newEmail, password: newPassword);
      User user = userCredential.user;
      return _createModelUserFromFirebaseCredentials(user: user);
    } catch (e) {
      print(e);
      return null;
    }
  } //signInWithEmailAndPassword

  //Register Email and password
  Future registerWithEmailAndPassword(String newEmail, String newPassword) async {
    try {
      //Contact Firebase to see if user exists
      print('Performing sign up task...');
      UserCredential result = await _auth.createUserWithEmailAndPassword(email: newEmail, password: newPassword);

      print('Received user sign up task results...');
      User user = result.user;

      /// TODO: Add new user to the database, move to bloc
      /// await new DatabaseService(uid: user.uid).updateUserData(newEmail, newPassword);

      //Return user data received from Firebase
      print('Returning new firebase user');
      return _createModelUserFromFirebaseCredentials(user: user);
    } catch (e) {
      print('User received: $user');
      print(e.toString());
      return null;
    }
  } //registerWithEmailAndPassword

  //sign out
  Future<void> signOut() async {
    try {
      await Future.wait([_auth.signOut()]);
    } on Exception {
      throw LogoutFailure();
    }
  } //signOut
}

class LogoutFailure implements Exception {}
