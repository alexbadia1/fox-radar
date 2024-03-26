import 'package:equatable/equatable.dart';
import 'package:fox_radar/logic/constants/enums.dart';

abstract class SignUpEvent extends Equatable {
  const SignUpEvent();
}

class SignUpEventSignUp extends SignUpEvent {
  final SignUpType signUpType;
  final hashedEmail;
  final hashedPassword;

  SignUpEventSignUp({
    required this.hashedEmail,
    required this.hashedPassword,
    required this.signUpType,
  })  : assert(hashedEmail != null),
        assert(hashedPassword != null);

  @override
  List<Object?> get props => [this.hashedEmail, this.hashedPassword];
}
