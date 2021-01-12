// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
//
// class UserRepository {
//   String _myUserID;
//   String _myEmail;
//   String _myFirstName;
//   String _myLastName;
//
//   UserRepository({@required String newUserId, @required String newEmail}) {
//     _myUserID = newUserId;
//     _myEmail = newEmail;
//     _generateFullName(_myEmail);
//   }
//
//   UserRepository.nullConstructor(){
//     _myUserID = '[UserID]';
//     _myEmail = '[First Name].[Last Name]@marist.edu';
//     _myFirstName = '[First Name]';
//     _myLastName = '[Last Name]';
//   }
//
//   ///Get's the first name from the email address
//   void _generateFullName(String email){
//     int time;
//     if (email == null) {
//       time = -1;
//       try{
//         time = int.parse(TimeOfDay.now().toString().replaceAll(':', "").replaceAll('TimeOfDay(', '').replaceAll(')', ''));
//       } catch (e) {
//         print(e);
//       }
//       _myFirstName = 'Good';
//       _myLastName = 'to meet you';
//       if (time >= 1800.0) {
//         _myLastName = 'Evening';
//       } else if (time >= 1200.0) {
//         _myLastName = 'Afternoon';
//       } else if (time >= 400.0){
//         _myLastName = 'Morning';
//       } else if (time >= 0){
//         _myLastName = 'Evening';
//       }
//     } else if (email.contains('@marist.edu')) {
//       List<String> firstNameWithLastNameWithEmailSuffix = email.split('.');
//       List<
//           String> lastNameWithEmailSuffix = firstNameWithLastNameWithEmailSuffix[1]
//           .split('@');
//       List<String> numbers = '0123456789'.split('');
//       _myFirstName = firstNameWithLastNameWithEmailSuffix[0];
//       _myLastName = lastNameWithEmailSuffix[0];
//       for (String digit in numbers) {
//         _myLastName = _myLastName.replaceAll(digit, "");
//       } //for
//       _myFirstName =
//           _myFirstName.replaceRange(0, 1, _myFirstName[0].toUpperCase());
//       _myLastName =
//           _myLastName.replaceRange(0, 1, _myLastName[0].toUpperCase());
//     }
//     else {
//       _myFirstName = 'Non-Marist';
//       _myLastName = 'User';
//     }
//   }//_generateFullName
//
//   String get getLastName => _myLastName;
//
//   String get getFirstName => _myFirstName;
//
//   String get getEmail => _myEmail;
//
//   String get getUserID => _myUserID;
// }//class