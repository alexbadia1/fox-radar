import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:communitytabs/logic/logic.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:communitytabs/presentation/presentation.dart';
import 'package:database_repository/database_repository.dart';
import 'package:authentication_repository/authentication_repository.dart';

class AccountScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Material(
        child: SafeArea(
          child: SlidingUpPanel(
            onPanelOpened: () {
              BlocProvider.of<SlidingUpPanelCubit>(context).openPanel();
            },
            controller: BlocProvider.of<SlidingUpPanelCubit>(context)
                .slidingUpPanelControl,
            minHeight: MediaQuery.of(context).size.height * .0625,
            maxHeight: MediaQuery.of(context).size.height,
            collapsed: AccountBottomNavigationBar(),
            isDraggable: false,
            panel: CreateEventScreen(),
            body: BlocProvider<AccountEventsBloc>(
              create: (context) => AccountEventsBloc(
                db: RepositoryProvider.of<DatabaseRepository>(context),
                accountID: RepositoryProvider.of<AuthenticationRepository>(context).getUserModel().userID,
              )..add(AccountEventsEventFetch()),
              child: AccountScreenBody(),
            ),
          ),
        ),
      ),
    );
  }
}
