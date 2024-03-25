import 'package:bloc/bloc.dart';
import'category_picker_state.dart';

class CategoryPickerCubit extends Cubit<CategoryPickerState> {
  CategoryPickerCubit() : super(CategoryPickerClosed(isOpen: false, index: 0));

  void openExpansionPanelToCategoryPicker({int? newPickerIndex}) {
    if (newPickerIndex == null) {
      newPickerIndex = this.state.index;
    }
    emit(CategoryPickerOpen(isOpen: true, index: newPickerIndex));
  }

  void closeExpansionPanel() {
    emit(CategoryPickerClosed(isOpen: false, index: this.state.index));
  }

  @override
  void onChange(Change<CategoryPickerState> change) {
    print('Category Picker Cubit $change');
    super.onChange(change);
  }
}
