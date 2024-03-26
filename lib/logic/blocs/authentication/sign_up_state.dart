import 'package:equatable/equatable.dart';

abstract class SignUpState extends Equatable{
  const SignUpState();
}

class SignUpStateSubmitted extends SignUpState {
  @override
  List<Object?> get props => [];
}

class SignUpStateSuccessful extends SignUpState{
  @override
  List<Object?> get props => [];
}

class SignUpStateFailed extends SignUpState{
  final String msg;

  SignUpStateFailed(this.msg);

  @override
  List<Object?> get props => [];
}

