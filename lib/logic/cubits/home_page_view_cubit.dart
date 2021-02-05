import 'package:bloc/bloc.dart';
import 'home_page_view_state.dart';
import 'package:flutter/material.dart';

class HomePageViewCubit extends Cubit<HomePageViewState> {
  final PageController _homePageViewController = new PageController(initialPage: 0, keepPage: true);

  HomePageViewCubit() : super(HomePageViewInitial());

  void animateToHomePage() {
    _homePageViewController.animateToPage(0, duration: const Duration(milliseconds: 150), curve: Curves.easeIn);
  } // animateToNextPage

  void animateToCategoryPage() {
    _homePageViewController.animateToPage(1, duration: const Duration(milliseconds: 150), curve: Curves.easeIn);
  } // animateToNextPage

  double currentPage () {
    return _homePageViewController.page;
  }// currentPage

  get homePageViewController => _homePageViewController;

@override
  Future<void> close() {
    _homePageViewController.dispose();
    return super.close();
  }// close
}// HomePageViewCubit
