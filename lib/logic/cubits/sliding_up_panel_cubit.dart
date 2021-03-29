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

    emit(SlidingUpPanelClosed());
  } // closePanel

  @override
  void onChange(Change<SlidingUpPanelState> change) {
    print('SlidingUp Panel Cubit Change $change');
    super.onChange(change);
  }// onChange

  @override
  Future<void> close() {
    print('SlidingUp Panel Cubit Closed!');
    _slidingUpPanelControl.close();
    return super.close();
  }// close
}// SlidingUpPanelCubit
