import 'package:bloc/bloc.dart';
import 'package:communitytabs/logic/cubits/cubits.dart';
import 'package:flutter/material.dart';
import 'create_event_page_view_state.dart';

class CreateEventPageViewCubit extends Cubit<CreateEventPageViewState> {
  final PageController _createEventPageViewController = new PageController(initialPage: 0, keepPage: true);

  CreateEventPageViewCubit() : super(CreateEventPageViewEventDetails());

  void animateToEventForm() {
    _createEventPageViewController.animateToPage(0, duration: const Duration(milliseconds: 150), curve: Curves.easeIn);
    emit(CreateEventPageViewEventDetails());
  } // animateToNextPage

  void animateToEventPhoto() {
    _createEventPageViewController.animateToPage(1, duration: const Duration(milliseconds: 150), curve: Curves.easeIn);
    emit(CreateEventPageViewEventPhoto());
  } // animateToNextPage

  double currentPage () {
    return _createEventPageViewController.page;
  }// currentPage

  get createEventPageViewController => _createEventPageViewController;

  @override
  void onChange(Change<CreateEventPageViewState> change) {
    print('Create Event Page View Cubit Change $change');
    super.onChange(change);
  }// onChange

  @override
  Future<void> close() {
    print('Create Event Page View Cubit Change Closed!');
    _createEventPageViewController.dispose();
    return super.close();
  }// close
}// CreateEventPageViewCubit
