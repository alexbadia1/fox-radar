import 'package:bloc/bloc.dart';
import 'password_error_state.dart';

class PasswordErrorCubit extends Cubit<PasswordErrorState> {
  PasswordErrorCubit() : super(PasswordErrorNoError());

  void throwPasswordErrorEmpty() {
    emit(PasswordErrorEmpty());
  }// showPasswordErrorEmpty

  void throwPasswordErrorNone() {
    emit(PasswordErrorNoError());
  }// showPasswordErrorEmpty

  @override
  void onChange(Change<PasswordErrorState> change) {
    print('PasswordErrorCubit $change');
    super.onChange(change);
  }// onChange

  @override
  Future<void> close() {
    this.close();
    return super.close();
  }// close
}// PasswordErrorCubit
