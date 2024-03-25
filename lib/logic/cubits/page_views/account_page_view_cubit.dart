import 'package:flutter/material.dart';
import 'package:fox_radar/logic/logic.dart';

class AccountPageViewCubit extends Cubit<AccountPageViewState> {
  AccountPageViewCubit() : super(AccountPageViewInitial());

  final PageController _accountPageViewController = new PageController(initialPage: 0, keepPage: true);

  void animateToPinnedEventsPage() {
    if (this._accountPageViewController.hasClients) {
      this._accountPageViewController.animateToPage(0, duration: const Duration(milliseconds: 150), curve: Curves.easeIn);
    }
  }

  void animateToMyEventsPage() {
    if (this._accountPageViewController.hasClients) {
      this._accountPageViewController.animateToPage(1, duration: const Duration(milliseconds: 150), curve: Curves.easeIn);
    }
  }

  double? currentPage () {
    if (this._accountPageViewController.hasClients) {
      return this._accountPageViewController.page;
    }
    return 0.0;
  }

  get accountPageViewController => _accountPageViewController;

  @override
  Future<void> close() {
    this._accountPageViewController.dispose();
    return super.close();
  }
}
