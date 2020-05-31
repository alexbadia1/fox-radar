class User {
  String _myUserID;
  String _myEmail;
  String _myFirstName;
  String _myLastName;

  User({String newUserId, String newEmail}) {
    _myUserID = newUserId;
    _myEmail = newEmail;
    _generateFullName(_myEmail);
  }

  User.nullConstructor(){
    _myUserID = '[UserID]';
    _myEmail = '[First Name].[Last Name]@marist.edu';
    _myFirstName = '[First Name]';
    _myLastName = '[Last Name]';
  }

  ///Get's the first name from the email address
  void _generateFullName(String email){
   List<String> firstNameWithLastNameWithEmailSuffix = email.split('.');
   List<String> lastNameWithEmailSuffix = firstNameWithLastNameWithEmailSuffix[1].split('@');
   List<String> numbers = '0123456789'.split('');
   _myFirstName = firstNameWithLastNameWithEmailSuffix[0];
   _myLastName = lastNameWithEmailSuffix[0];
   for(String digit in numbers){
     _myLastName = _myLastName.replaceAll(digit, "");
   }//for
    _myFirstName = _myFirstName.replaceRange(0, 1, _myFirstName[0].toUpperCase());
   _myLastName = _myLastName.replaceRange(0, 1, _myLastName[0].toUpperCase());
  }//_generateFullName

  String get getLastName => _myLastName;

  String get getFirstName => _myFirstName;

  String get getEmail => _myEmail;

  String get getUserID => _myUserID;
}//class