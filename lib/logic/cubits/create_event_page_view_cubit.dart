import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'create_event_page_view_state.dart';

class CreateEventPageViewCubit extends Cubit<CreateEventPageViewState> {
  final PageController _createEventPageViewController = new PageController(initialPage: 0, keepPage: true);

  CreateEventPageViewCubit() : super(CreateEventPageViewInitial());

  void animateToHomePage() {
    _createEventPageViewController.animateToPage(0, duration: const Duration(milliseconds: 150), curve: Curves.easeIn);
  } // animateToNextPage

  void animateToCategoryPage() {
    _createEventPageViewController.animateToPage(1, duration: const Duration(milliseconds: 150), curve: Curves.easeIn);
  } // animateToNextPage

  double currentPage () {
    return _createEventPageViewController.page;
  }// currentPage

  get createEventPageViewController => _createEventPageViewController;

  @override
  Future<void> close() {
    _createEventPageViewController.dispose();
    return super.close();
  }// close
}// CreateEventPageViewCubit
