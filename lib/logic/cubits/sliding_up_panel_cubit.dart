import 'sliding_up_panel_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:communitytabs/logic/logic.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:database_repository/database_repository.dart';

class SlidingUpPanelCubit extends Cubit<SlidingUpPanelState> {
  final PanelController _slidingUpPanelControl = new PanelController();

  SlidingUpPanelCubit() : super(SlidingUpPanelClosed(null));

  get slidingUpPanelControl => this._slidingUpPanelControl;

  void openPanel({EventModel initialEventModel}) {
    final _state = this.state;

    if (_state is SlidingUpPanelClosed) {

      // Change initial event model for the create
      // event form before opening up the sliding up panel.
      if (initialEventModel != null) {
        emit(SlidingUpPanelClosed(initialEventModel));
      }// if
    }// if

    if (_slidingUpPanelControl.isAttached) {
      this._slidingUpPanelControl.open();
      emit(SlidingUpPanelOpen(initialEventModel));
    } // if
  } // openPanel

  void closePanel() {
    if (_slidingUpPanelControl.isAttached) {
      this._slidingUpPanelControl.close();
      emit(SlidingUpPanelClosed(null));
    } // if
  } // closePanel

  @override
  void onChange(Change<SlidingUpPanelState> change) {
    print('SlidingUp Panel Cubit Change $change');
    super.onChange(change);
  } // onChange

  @override
  Future<void> close() {
    print('SlidingUp Panel Cubit Closed!');
    return super.close();
  } // close
} // SlidingUpPanelCubit
