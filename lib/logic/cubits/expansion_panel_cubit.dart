import 'package:bloc/bloc.dart';
import 'expansion_panel_state.dart';

class ExpansionPanelCubit extends Cubit<ExpansionPanelState> {
  ExpansionPanelCubit() : super(ExpansionPanelClosed(false));

  void openExpansionPanelToDatePicker() {
    emit(ExpansionPanelOpenShowDatePicker(true));
  }// open

  void openExpansionPanelToTimePicker() {
    emit(ExpansionPanelOpenShowTimePicker(true));
  }// open

  void closeExpansionPanel() {
    emit(ExpansionPanelClosed(false));
  }// close

  @override
  void onChange(Change<ExpansionPanelState> change) {
    print('Expansion Panel Cubit $change');
    super.onChange(change);
  }// onChange
}// ExpansionPanelCubit
