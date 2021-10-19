import 'package:fox_radar/logic/logic.dart';

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

@override
  void onChange(Change<CategoryPageState> change) {
    print('Category Cubit: $change');
    super.onChange(change);
  }
}// CategoryTitleCubit
