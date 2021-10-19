import 'package:authentication_repository/authentication_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fox_radar/logic/logic.dart';
import 'package:database_repository/database_repository.dart';
import 'package:fox_radar/presentation/presentation.dart';

class AppPageView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<UploadEventBloc>(
          create: (context) => UploadEventBloc(
            db: RepositoryProvider.of<DatabaseRepository>(context),
            uid: RepositoryProvider.of<AuthenticationRepository>(context).getUserModel().userID,
          ),
        ),

        /// Declared here, to allow bottom navigation to change
        /// to the home page view from the category page view
        BlocProvider<HomePageViewCubit>(
          create: (context) => HomePageViewCubit(),
        ),

        /// Declared here, to allow bottom navigation to change
        /// to the created page view from the pinned page view
        BlocProvider<AccountPageViewCubit>(
          create: (context) => AccountPageViewCubit(),
        ),
      ],
      child: Scaffold(
        bottomNavigationBar: CustomBottomNavigationBar(),
        body: PageView(
          controller: BlocProvider.of<AppPageViewCubit>(context).appPageViewController,
          physics: NeverScrollableScrollPhysics(),
          children: [
            HomeScreen(),
            AccountScreen(),
          ],
        ),
      ),
    );
  } // build
} // AppPageView
