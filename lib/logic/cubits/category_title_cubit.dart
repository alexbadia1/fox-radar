import 'package:bloc/bloc.dart';
import 'category_title_state.dart';

class CategoryTitleCubit extends Cubit<CategoryTitleState> {
  String _category = '[Category Title]';

  CategoryTitleCubit() : super(CategoryTitleInitial());

  get category => _category;

  void setCategory(String newCategory){
    if (_category != newCategory) {
      _category = newCategory;
    }// if
  }// setCategory
}// CategoryTitleCubit
