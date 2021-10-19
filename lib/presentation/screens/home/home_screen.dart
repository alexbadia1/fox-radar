import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fox_radar/logic/logic.dart';
import 'package:database_repository/database_repository.dart';
import 'package:fox_radar/presentation/screens/screens.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CategoryPageCubit(),
      child: PageView(
        controller: BlocProvider.of<HomePageViewCubit>(context).homePageViewController,
        physics: NeverScrollableScrollPhysics(),
        children: [
          BlocProvider<SuggestedEventsBloc>(
            create: (context) => SuggestedEventsBloc(
              db: RepositoryProvider.of<DatabaseRepository>(context),
            )..add(SuggestedEventsEventFetch()),
            child: HomeScreenBody(),
          ),
          CategoryScreen(),
        ],
      ),
    );
  }
}
