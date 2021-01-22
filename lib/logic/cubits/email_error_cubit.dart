import 'package:bloc/bloc.dart';
import 'email_error_state.dart';

class EmailErrorCubit extends Cubit<EmailErrorState> {
  EmailErrorCubit() : super(EmailErrorInitial());
}
