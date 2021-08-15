import 'package:flutter/material.dart';
import 'package:communitytabs/logic/logic.dart';
import 'package:communitytabs/presentation/presentation.dart';

/*
 * bottom_navigation_bar.dart
 *
 * Implements a normal Scaffold's BottomNavigationBar, but is separated
 * in order to call set state without rebuilding the entire application.
 */
class CustomBottomNavigationBar extends StatefulWidget {
  @override
  _CustomBottomNavigationBarState createState() => _CustomBottomNavigationBarState();
} // CustomBottomNavigationBar

class _CustomBottomNavigationBarState extends State<CustomBottomNavigationBar> {
  int pageNum = 0;
  @override
  Widget build(BuildContext context) {
    final AppPageViewState _appPageView = context.watch<AppPageViewCubit>().state;
    HomePageViewCubit _homePageViewCubit = BlocProvider.of<HomePageViewCubit>(context);
    AccountPageViewCubit _accountPageViewCubit = BlocProvider.of<AccountPageViewCubit>(context);

    if (_appPageView is AppPageViewStatePosition) {
      pageNum =_appPageView.index;
    }// if

    return Container(
      color: Colors.white,
      child: Container(
        decoration: BoxDecoration(gradient: cMaristGradient),
        child: BottomNavigationBar(
          selectedItemColor: kHavenLightGray,
          unselectedItemColor: kHavenLightGray,
          selectedFontSize: 10.0,
          unselectedFontSize: 10.0,
          elevation: 0,
          backgroundColor: Colors.transparent,
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              label: "Home",
              activeIcon: Icon(Icons.home),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.add_circle_outline_rounded),
              label: "Create",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline),
              label: "Account",
              activeIcon: Icon(Icons.person),
            ),
          ],
          onTap: (index) {
            switch (index) {
              case 2: // Clicked on Account Page View Icon
                if (pageNum == 1) {
                  // Already on Account Page View
                  if (_accountPageViewCubit.currentPage() == 1.0) {
                    _accountPageViewCubit.animateToPinnedEventsPage();
                  } // if
                } // if

                else {
                  BlocProvider.of<AppPageViewCubit>(context).jumpToAccountPage();
                } // else
                break;
              case 0: // Clicked on Home Page View Icon
                if (pageNum == 0) {
                  // Already on Home Page View
                  if (_homePageViewCubit.currentPage() == 1.0) {
                    _homePageViewCubit.animateToHomePage();
                  } // if
                } // if

                else {
                  BlocProvider.of<AppPageViewCubit>(context).jumpToHomePage();
                } // else
                break;
              case 1: // Show the create event screen (wih bottom sheet)
                final _uploadState = BlocProvider.of<UploadEventBloc>(context).state;

                if (_uploadState is UploadEventStateUploading && !_uploadState.complete) {
                  showModalBottomSheet<void>(
                    context: context,
                    builder: (BuildContext context) {
                      return BlocProvider.value(
                        value: BlocProvider.of<UploadEventBloc>(context),
                        child: ModalConfirmation(
                          prompt: 'An event is already currently being upload. Please wait for, or cancel, that event!',
                          cancelText: 'CANCEL CURRENT UPLOAD',
                          cancelColor: Colors.redAccent,
                          onCancel: () {
                            showModalBottomSheet(
                                context: context,
                                builder: (context) {
                                  return ModalConfirmation(
                                    cancelText: 'CANCEL CURRENT UPLOAD',
                                    cancelColor: Colors.redAccent,
                                    onCancel: () {
                                      BlocProvider.of<UploadEventBloc>(context).add(UploadEventCancel());

                                      Navigator.popUntil(context, (route) => route.isFirst);
                                    },
                                    confirmText: "NEVERMIND",
                                    confirmColor: Colors.blueAccent,
                                    onConfirm: () => Navigator.popUntil(context, (route) => route.isFirst),
                                  );
                                });
                          },
                          confirmText: 'I CAN WAIT',
                          confirmColor: Colors.blueAccent,
                          onConfirm: () => Navigator.pop(context),
                        ),
                      );
                    },
                  );
                } // if

                else {
                  if (_uploadState is UploadEventStateUploading && _uploadState.complete) {
                    // Reset the upload event bloc
                    BlocProvider.of<UploadEventBloc>(context).add(UploadEventReset());
                  } // if
                  showModalBottomSheet(
                    isScrollControlled: true,
                    enableDrag: false,
                    context: context,
                    builder: (bottomModalSheetContext) {
                      return MultiBlocProvider(
                        providers: [
                          BlocProvider.value(
                            value: BlocProvider.of<UploadEventBloc>(context),
                          ),
                          BlocProvider.value(
                            value: BlocProvider.of<AccountPageViewCubit>(context),
                          ),
                        ],
                        child: CreateEventScreen(initialEventModel: null // Don't pass an initial event model
                            ),
                      );
                    }, // builder
                  );
                } // else
                break;
              default: // Do nothing
                break;
            } // switch
          }, // onTap
          currentIndex: pageNum == 0 ? 0 : 2,
        ),
      ),
    );
  } // build
} // _CustomBottomNavigationBarState
