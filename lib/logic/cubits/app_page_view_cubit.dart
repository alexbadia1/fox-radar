import 'package:bloc/bloc.dart';
import 'app_page_view_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:communitytabs/logic/logic.dart';

class AppPageViewCubit extends Cubit<AppPageViewState> {
  final PageController _appPageViewController =
      new PageController(initialPage: HOME_PAGE_VIEW_INDEX, keepPage: true);

  AppPageViewCubit() : super(AppPageViewInitial());

  void jumpToHomePage() {
    _appPageViewController.jumpToPage(HOME_PAGE_VIEW_INDEX);
  } // animateToNextPage

  void jumpToAccountPage() {
    _appPageViewController.jumpToPage(ACCOUNT_PAGE_VIEW_INDEX);
  } // animateToNextPage

  double currentPage() {
    return _appPageViewController.page;
  } // currentPage

  get appPageViewController => _appPageViewController;

  @override
  Future<void> close() {
    _appPageViewController.dispose();
    return super.close();
  } // close
}// AppPageViewCubit
