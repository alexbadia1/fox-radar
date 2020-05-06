import 'package:firebase_auth/firebase_auth.dart';
import 'user.dart';

class AuthService {
  //Create a firebase authentication object
  final FirebaseAuth _auth = FirebaseAuth.instance;

  //Create our own user object
  User _userFromFirebaseUser(FirebaseUser user) {
    return user != null ? new User(uid: user.uid): null;
  }

  //Listening to the stream
  Stream<User> get user {
    return _auth.onAuthStateChanged.map((FirebaseUser user) => _userFromFirebaseUser(user));
  }
  
  //Anonymous sign in
  Future anonymousSignIn() async {
    try{
      //Try to get an authentication result
      AuthResult _result = await _auth.signInAnonymously();
      FirebaseUser _user = _result.user;
      return _userFromFirebaseUser(_user);
    } catch (Exception) {
      print(Exception.toString());
      return null;
    }
  }

  //Email password sign in

  //Register Email and password

  //sign out
  Future signOut () async {
    try{
      return await _auth.signOut();
    } catch (error) {
      return null;
    }
  }
}