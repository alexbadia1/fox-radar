import 'password_state.dart';
import 'package:bloc/bloc.dart';

class PasswordCubit extends Cubit<PasswordState> {
  late bool obscurePassword;

  PasswordCubit() : super(PasswordStateHidden()){
    obscurePassword = PasswordStateHidden().obscurePassword;
  }
  
  void setPasswordVisible() {
    obscurePassword = PasswordStateVisible().obscurePassword;
    emit(PasswordStateVisible());
  }// setPasswordVisible

  void setPasswordHidden() {
    obscurePassword = PasswordStateHidden().obscurePassword;
    emit(PasswordStateHidden());
  }// setPasswordHidden

  @override
  void onChange(Change<PasswordState> change) {
    print('Password Cubit: $change');
    super.onChange(change);
  }// onChange

@override
  Future<void> close() {
    return super.close();
  }// close
}// PasswordCubit
