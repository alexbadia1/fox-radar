import 'package:flutter/material.dart';
import 'package:fox_radar/logic/logic.dart';

class HomePageViewCubit extends Cubit<HomePageViewState> {
  final PageController _homePageViewController = new PageController(initialPage: 0, keepPage: true);

  HomePageViewCubit() : super(HomePageViewInitial());

  void animateToHomePage() {
    _homePageViewController.animateToPage(0, duration: const Duration(milliseconds: 150), curve: Curves.easeIn);
  }

  void animateToCategoryPage() {
    _homePageViewController.animateToPage(1, duration: const Duration(milliseconds: 150), curve: Curves.easeIn);
  }

  double? currentPage () {
    return _homePageViewController.page;
  }

  get homePageViewController => _homePageViewController;

@override
  Future<void> close() {
    _homePageViewController.dispose();
    return super.close();
  }
}
