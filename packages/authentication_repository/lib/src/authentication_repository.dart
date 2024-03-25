import 'dart:async';
import 'models/models.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthenticationRepository {
  /// Singleton
  static final AuthenticationRepository _authenticationRepository = AuthenticationRepository._internal();

  /// Create a firebase authentication object
  final FirebaseAuth _auth = FirebaseAuth.instance;

  factory AuthenticationRepository() {
    return _authenticationRepository;
  }

  AuthenticationRepository._internal();

  /// Create our own user object
  UserModel _createModelUserFromFirebaseCredentials({required user}) {
    return UserModel(userID: user.uid, email: user.email);
  }

  /// Listen to a firebase authentication stream and create a user model
  Stream<UserModel> get user {
    return _auth.authStateChanges().map((User? user) {
      print(user);
      if (user != null) {
        return _createModelUserFromFirebaseCredentials(user: user);
      } else {
        return UserModel.nullConstructor();
      }
    });
  }

  /// Try an anonymous sign in
  Future<UserModel?> anonymousSignIn() async {
    try {
      /// AuthResult changed to "UserCredential"
      UserCredential? _userCredential = await _auth.signInAnonymously();

      /// FirebaseUser changed to "User"
      User? user = _userCredential.user;

      /// Create a model for the anonymous user
      return _createModelUserFromFirebaseCredentials(user: user);
    } catch (Exception) {
      print(Exception.toString());
      return null;
    }
  }

  bool isSignedIn() {
    return _auth.currentUser != null;
  }

  UserModel getUserModel() {
    return _createModelUserFromFirebaseCredentials(user: _auth.currentUser);
  }

  /// Try an anonymous sign in
  Future<UserModel?> signIn() async {
    try {
      /// AuthResult changed to "UserCredential"
      UserCredential? _userCredential = await _auth.signInWithEmailAndPassword(
          email: '',
          password: ''
      );

      /// FirebaseUser changed to "User"
      User? user = _userCredential.user;

      /// Create a model for the anonymous user
      return _createModelUserFromFirebaseCredentials(user: user);
    } catch (Exception) {
      print(Exception.toString());
      return null;
    }
  }

  /// Email Password login
  Future<UserModel?> signInWithEmailAndPassword({
    required String newEmail, required String newPassword
  }) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: newEmail,
          password: newPassword
      );
      User? user = userCredential.user;
      return _createModelUserFromFirebaseCredentials(user: user);
    } catch (e) {
      print(e);
      return null;
    }
  }

  /// Register Email and password
  Future<UserModel?> registerWithEmailAndPassword({
    required String newEmail, required String newPassword
  }) async {
    try {
      //Contact Firebase to see if user exists
      print('Performing sign up task...');
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: newEmail,
          password: newPassword
      );

      print('Received user sign up task results...');
      User? user = result.user;

      /// TODO: Add new user to the database, move to bloc
      /// await new DatabaseService(uid: user.uid).updateUserData(newEmail, newPassword);

      // Return user data received from Firebase
      print('Returning new firebase user');
      return _createModelUserFromFirebaseCredentials(user: user);
    } catch (e) {
      print('User received: $user');
      print(e.toString());
      return null;
    }
  }

  /// sign out
  Future<void> signOut() async {
    try {
      await Future.wait([_auth.signOut()]);
    } on Exception {
      throw LogoutFailure();
    }
  }
}

class LogoutFailure implements Exception {}
