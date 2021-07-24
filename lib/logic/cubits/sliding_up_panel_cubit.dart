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
    if (_slidingUpPanelControl.isAttached) {
      _slidingUpPanelControl.open();

      emit(SlidingUpPanelOpen());
    }// if
  } // openPanel

  void closePanel() {
    if (_slidingUpPanelControl.isAttached) {
      _slidingUpPanelControl.close();

      emit(SlidingUpPanelClosed());
    }// if
  } // closePanel

  @override
  void onChange(Change<SlidingUpPanelState> change) {
    print('SlidingUp Panel Cubit Change $change');
    super.onChange(change);
  }// onChange

  @override
  Future<void> close() {
    print('SlidingUp Panel Cubit Closed!');
    return super.close();
  }// close
}// SlidingUpPanelCubit
