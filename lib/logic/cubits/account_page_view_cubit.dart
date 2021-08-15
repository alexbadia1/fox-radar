import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:communitytabs/logic/logic.dart';

class AccountPageViewCubit extends Cubit<AccountPageViewState> {
  AccountPageViewCubit() : super(AccountPageViewInitial());

  final PageController _accountPageViewController = new PageController(initialPage: 0, keepPage: true);

  void animateToPinnedEventsPage() {
    this._accountPageViewController.animateToPage(0, duration: const Duration(milliseconds: 150), curve: Curves.easeIn);
  } // animateToNextPage

  void animateToMyEventsPage() {
    this._accountPageViewController.animateToPage(1, duration: const Duration(milliseconds: 150), curve: Curves.easeIn);
  } // animateToNextPage

  double currentPage () {
    return this._accountPageViewController.page;
  }// currentPage

  get accountPageViewController => _accountPageViewController;

  @override
  Future<void> close() {
    this._accountPageViewController.dispose();
    return super.close();
  }// close
}// AccountPageViewCubit
