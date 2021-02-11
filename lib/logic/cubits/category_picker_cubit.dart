import 'package:bloc/bloc.dart';
import'category_picker_state.dart';

class CategoryPickerCubit extends Cubit<CategoryPickerState> {
  CategoryPickerCubit() : super(CategoryPickerClosed());
}
