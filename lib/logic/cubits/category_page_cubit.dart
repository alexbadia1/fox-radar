import 'package:bloc/bloc.dart';
import 'package:communitytabs/logic/cubits/cubits.dart';
import 'category_page_state.dart';

class CategoryPageCubit extends Cubit<CategoryPageState> {
  String _category = '[Category Title]';

  CategoryPageCubit() : super(CategoryPageInitial());

  get category => _category;

  void setCategory(String newCategory){
    if (_category != newCategory) {
      _category = newCategory;
      emit(CategoryPageCategory(category: newCategory));
    }// if
  }// setCategory
}// CategoryTitleCubit
