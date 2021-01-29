import 'package:communitytabs/data/slidingUpPanelMetadata.dart';
import 'package:communitytabs/logic/cubits/cubits.dart';
import 'package:communitytabs/presentation/components/components.dart';
import 'package:flutter/material.dart';
import 'package:communitytabs/screens/addEvent.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:communitytabs/presentation/screens/screens.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SlidingUpPanelMetaData _slidingUpPanelMetaData =
        Provider.of<SlidingUpPanelMetaData>(context);

    return SafeArea(
      child: Material(
        child: SafeArea(
          child: BlocProvider(
            create: (context) => HomePageViewCubit(),
            child: SlidingUpPanel(
              controller: _slidingUpPanelMetaData.getPanelController,
              minHeight: MediaQuery.of(context).size.height * .0625,
              maxHeight: MediaQuery.of(context).size.height,
              collapsed: MaristBottomNavigationBar(currentNamedRoute: '/home'),
              isDraggable: false,
              panel: AddEventContent(),
              body: BlocProvider(
                create: (context) => CategoryTitleCubit(),
                child: Builder(builder: (context) {
                  return PageView(
                    controller: BlocProvider.of<HomePageViewCubit>(context).homePageViewController,
                    physics: NeverScrollableScrollPhysics(),
                    children: [
                      HomeScreenBody(),
                      CategoryScreen(),
                    ],
                  );
                }),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
