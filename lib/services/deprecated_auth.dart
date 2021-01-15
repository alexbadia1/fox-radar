// import 'package:communitytabs/services/deprecated_database.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'deprecated_user_model.dart';

// class AuthService {
//   //Create a firebase authentication object
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//
//   //Create our own user object
//   User _userFromFirebaseUser( user) {
//      return user != null ?
//       user.isAnonymous ?
//         new User(newUserId: user.uid, newEmail: null) : new User(newUserId: user.uid, newEmail: user.email)
//      : null;
//   }//_userFromFirebaseUser
//
//   //Listening to the stream and mapping the user data to a local user intance
//   Stream<User> getUser() async* {
//     _auth.authStateChanges().listen((User user) {
//       if (user != null) {
//         return UserRepository(newUserId: user.uid, newEmail: user.email);
//       }// if
//
//       else {
//
//       }// else
//     });
//     return _auth.authStateChanges().map((User user) => _userFromFirebaseUser(user));
//   }//user
//
//   //Anonymous sign in
//   Future anonymousSignIn() async {
//     try{
//       //Try to get an authentication result
//       AuthResult _result = await _auth.signInAnonymously();
//       FirebaseUser _user = _result.user;
//       return _userFromFirebaseUser(_user);
//     } catch (Exception) {
//       print(Exception.toString());
//       return null;
//     }
//   }//anonymousSigIn
//
//   //Email password sign in
//   Future signInWithEmailAndPassword(String newEmail, String newPassword) async {
//     try{
//       AuthResult result = await _auth.signInWithEmailAndPassword(email: newEmail, password: newPassword);
//       FirebaseUser user = result.user;
//       return _userFromFirebaseUser(user);
//     } catch (e) {
//       print(e);
//       return null;
//     }
//   }//signInWithEmailAndPassword
//
//   //Register Email and password
//   Future registerWithEmailAndPassword(String newEmail, String newPassword) async {
//     try {
//       //Contact Firebase to see if user exists
//       print('Performing sign up task...');
//       AuthResult result = await _auth.createUserWithEmailAndPassword(email: newEmail, password: newPassword);
//
//       print('Recieved user sign up task results...');
//       FirebaseUser user = result.user;
//
//       //Create a new user account
//       print('Creating new user in database...');
//       await new DatabaseService(uid: user.uid).updateUserData(newEmail, newPassword);
//
//       //Return user data received from Firebase
//       print('Returning new firebase user');
//       return _userFromFirebaseUser(user);
//
//     } catch (e) {
//       print('User returned null');
//       print(e.toString());
//       return null;
//     }
//   }//registerWithEmailAndPassword
//
//   //sign out
//   Future<void> signOut () async {
//     try{
//       return await _auth.signOut();
//     } catch (error) {
//       return -1;
//     }
//   }//signOut
// }