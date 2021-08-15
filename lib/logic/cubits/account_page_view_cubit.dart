import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:communitytabs/logic/logic.dart';

class AccountPageViewCubit extends Cubit<AccountPageViewState> {
  AccountPageViewCubit() : super(AccountPageViewInitial());

  final PageController _accountPageViewController = new PageController(initialPage: 0, keepPage: true);

  void animateToPinnedEventsPage() {
    if (this._accountPageViewController.hasClients) {
      this._accountPageViewController.animateToPage(0, duration: const Duration(milliseconds: 150), curve: Curves.easeIn);
    }// if
  } // animateToNextPage

  void animateToMyEventsPage() {
    if (this._accountPageViewController.hasClients) {
      this._accountPageViewController.animateToPage(1, duration: const Duration(milliseconds: 150), curve: Curves.easeIn);
    }// if
  } // animateToNextPage

  double currentPage () {
    if (this._accountPageViewController.hasClients) {
      return this._accountPageViewController.page;
    }// if
    return 0.0;
  }// currentPage

  get accountPageViewController => _accountPageViewController;

  @override
  Future<void> close() {
    this._accountPageViewController.dispose();
    return super.close();
  }// close
}// AccountPageViewCubit
