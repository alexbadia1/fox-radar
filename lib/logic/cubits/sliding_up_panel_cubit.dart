import 'package:bloc/bloc.dart';
import 'sliding_up_panel_state.dart';
import 'package:flutter/material.dart';
import 'package:communitytabs/logic/cubits/cubits.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class SlidingUpPanelCubit extends Cubit<SlidingUpPanelState> {
  final PanelController _slidingUpPanelControl = new PanelController();

  SlidingUpPanelCubit() : super(SlidingUpPanelClosed());

  get slidingUpPanelControl => _slidingUpPanelControl;

  void openPanel() {
    _slidingUpPanelControl.open();

    emit(SlidingUpPanelOpen());
  } // openPanel

  void closePanel() {
    _slidingUpPanelControl.close();
  } // closePanel

  @override
  Future<void> close() {
    /// TODO: Find our how the Sliding Up Panel Controller is disposed
    return super.close();
  }// close
}// SlidingUpPanelCubit
