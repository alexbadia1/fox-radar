import 'package:flutter/material.dart';
import 'package:fox_radar/logic/logic.dart';
import 'package:fox_radar/presentation/presentation.dart';
import 'package:database_repository/database_repository.dart';
import 'package:authentication_repository/authentication_repository.dart';

class AccountScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return PageView(
      controller: BlocProvider.of<AccountPageViewCubit>(context).accountPageViewController,
      physics: NeverScrollableScrollPhysics(),
      children: [
        PinnedEventsScreen(),
        BlocProvider<AccountEventsBloc>(
          create: (accountBlocProv) => AccountEventsBloc(
            db: RepositoryProvider.of<DatabaseRepository>(context),
            accountID: RepositoryProvider.of<AuthenticationRepository>(context).getUserModel().userID,
          )..add(AccountEventsEventFetch()),
          child: AccountEventsScreen(),
        ),
      ],
    );
  } // build
} // AccountScreen
