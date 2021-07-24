import 'package:communitytabs/logic/blocs/blocs.dart';
import 'package:communitytabs/logic/cubits/cubits.dart';
import 'package:database_repository/database_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:communitytabs/presentation/screens/screens.dart';
import 'home_bottom_navigation.dart';

class HomeScreen extends StatelessWidget {
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
            collapsed: HomeBottomNavigationBar(),
            isDraggable: false,
            panel: CreateEventScreen(),
            body: BlocProvider(
              create: (context) => CategoryPageCubit(),
              child: PageView(
                controller: BlocProvider.of<HomePageViewCubit>(context).homePageViewController,
                physics: NeverScrollableScrollPhysics(),
                children: [
                  BlocProvider(
                    create: (context) => SuggestedEventsBloc(
                        db: RepositoryProvider.of<DatabaseRepository>(
                            context))
                      ..add(SuggestedEventsEventFetch()),
                    child: HomeScreenBody(),
                  ),
                  CategoryScreen(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
