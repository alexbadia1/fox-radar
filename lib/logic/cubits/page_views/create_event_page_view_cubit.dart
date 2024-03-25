import 'package:flutter/material.dart';
import 'package:fox_radar/logic/logic.dart';

class CreateEventPageViewCubit extends Cubit<CreateEventPageViewState> {
  final PageController _createEventPageViewController = new PageController(initialPage: 0, keepPage: true);

  CreateEventPageViewCubit() : super(CreateEventPageViewEventDetails());

  void animateToEventForm() {
    _createEventPageViewController.animateToPage(0, duration: const Duration(milliseconds: 150), curve: Curves.easeIn);
    emit(CreateEventPageViewEventDetails());
  }

  void animateToEventPhoto() {
    _createEventPageViewController.animateToPage(1, duration: const Duration(milliseconds: 150), curve: Curves.easeIn);
    emit(CreateEventPageViewEventPhoto());
  }

  double? currentPage () {
    return _createEventPageViewController.page;
  }

  get createEventPageViewController => _createEventPageViewController;

  @override
  void onChange(Change<CreateEventPageViewState> change) {
    print('Create Event Page View Cubit Change $change');
    super.onChange(change);
  }

  @override
  Future<void> close() {
    print('Create Event Page View Cubit Change Closed!');
    _createEventPageViewController.dispose();
    return super.close();
  }
}
