import 'package:flutter/material.dart';
import 'package:fox_radar/logic/logic.dart';

class AppPageViewCubit extends Cubit<AppPageViewState> {
  final PageController _appPageViewController =
      new PageController(initialPage: HOME_PAGE_VIEW_INDEX, keepPage: true);

  AppPageViewCubit() : super(AppPageViewStatePosition(HOME_PAGE_VIEW_INDEX));

  void jumpToHomePage() {
    if (this._appPageViewController.hasClients) {
      _appPageViewController.jumpToPage(HOME_PAGE_VIEW_INDEX);
      emit(AppPageViewStatePosition(HOME_PAGE_VIEW_INDEX));
    }// if
  } // animateToNextPage

  void jumpToAccountPage() {
    if (this._appPageViewController.hasClients) {
      _appPageViewController.jumpToPage(ACCOUNT_PAGE_VIEW_INDEX);
      emit(AppPageViewStatePosition(ACCOUNT_PAGE_VIEW_INDEX));
    }// if
  } // animateToNextPage

  double currentPage() {
    if (this._appPageViewController.hasClients) {
      return _appPageViewController.page;
    }// if
    else {
      return 0;
    }// else
  } // currentPage

  get appPageViewController => _appPageViewController;

  @override
  Future<void> close() {
    _appPageViewController.dispose();
    return super.close();
  } // close
}// AppPageViewCubit
