import 'package:equatable/equatable.dart';
import 'package:fox_radar/logic/logic.dart';

abstract class LoginEvent extends Equatable {
  const LoginEvent();
}

class LoginEventLogin extends LoginEvent {
  final LoginType loginType;
  final hashedEmail;
  final hashedPassword;

  LoginEventLogin(
      {required this.hashedEmail,
      required this.hashedPassword,
      required this.loginType})
      : assert(hashedEmail != null),
        assert(hashedPassword != null) {
    print("Login: ${this.hashedEmail} : ${this.hashedPassword}");
  }

  @override
  List<Object?> get props => [this.hashedEmail, this.hashedPassword];
}

class LoginEventLogout extends LoginEvent {
  @override
  List<Object?> get props => [];
}
