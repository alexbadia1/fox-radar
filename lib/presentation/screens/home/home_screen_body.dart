import 'package:communitytabs/logic/blocs/blocs.dart';
import 'package:communitytabs/presentation/components/components.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:communitytabs/constants/marist_color_scheme.dart';
import 'package:communitytabs/presentation/buttons/buttons.dart';
import 'package:database_repository/database_repository.dart';

class HomeScreenBody extends StatefulWidget {
  //TODO: Add add preferences Arguments for Horizontal Lists for preferences.
  @override
  _HomeScreenBodyState createState() => _HomeScreenBodyState();
}

class _HomeScreenBodyState extends State<HomeScreenBody>
    with AutomaticKeepAliveClientMixin {
  GlobalKey navigation = new GlobalKey();
  @override
  Widget build(BuildContext context) {
    super.build(context);
    double screenHeight = MediaQuery.of(context).size.height;
    return Container(
      color: cBackground,
      child: CustomScrollView(
        slivers: [
          MaristSliverAppBar(title: 'Marist'),
          SliverGrid.count(
            key: navigation,
            crossAxisCount: 2,
            crossAxisSpacing: MediaQuery.of(context).size.width * .02,
            mainAxisSpacing: MediaQuery.of(context).size.height * .01,
            childAspectRatio: 4,
            children: <Widget>[
              CategoryNavigationItem(
                  option: 'Arts', icon: Icons.palette, nextPage: '/arts'),
              CategoryNavigationItem(
                  option: 'Sports', icon: Icons.flag, nextPage: '/sports'),
              CategoryNavigationItem(
                  option: 'Diversity',
                  icon: Icons.public,
                  nextPage: '/diversity'),
              CategoryNavigationItem(
                  option: 'Student',
                  icon: Icons.library_books,
                  nextPage: '/student'),
              CategoryNavigationItem(
                  option: 'Food', icon: Icons.local_dining, nextPage: '/food'),
              CategoryNavigationItem(
                  option: 'Greek',
                  icon: Icons.account_balance,
                  nextPage: '/greek'),
            ],
          ),
          SliverAppBar(
            centerTitle: false,
            backgroundColor: Colors.transparent,
            title: Text(
              'Suggestions',
              style: TextStyle(color: kHavenLightGray),
            ),
          ),
          BlocProvider(
            create: (context) => SuggestedEventsBloc(
                db: RepositoryProvider.of<DatabaseRepository>(context))
              ..add(SuggestedEventsEventFetch()),
            child: Builder(
              builder: (context) {
                final SuggestedEventsState _suggestedEventsState =
                    context.watch<SuggestedEventsBloc>().state;
                if (_suggestedEventsState is SuggestedEventsStateSuccess) {
                  return SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (BuildContext context, int index) {
                        if (index <
                            _suggestedEventsState.eventModels.length - 1) {
                          return EventCard(
                              newEvent: _suggestedEventsState.eventModels
                                  .elementAt(index));
                        } // if
                        else {
                          return Column(
                            children: <Widget>[
                              EventCard(
                                  newEvent: _suggestedEventsState.eventModels
                                      .elementAt(index)),
                              SizedBox(
                                height: screenHeight * .1,
                                width: double.infinity,
                              ),
                            ],
                          );
                        } // else
                      },
                      childCount: _suggestedEventsState.eventModels.length,
                    ),
                  );
                } // if
                else if (_suggestedEventsState is SuggestedEventsStateFailed) {
                  return SliverList(
                    delegate: SliverChildListDelegate(
                      [
                        Center(
                            child: Text('Welp, Nothings Going On',
                                style: TextStyle(color: Colors.white)))
                      ],
                    ),
                  );
                } else {
                  return SliverList(
                    delegate: SliverChildListDelegate(
                      [Center(child: LoadingWidget())],
                    ),
                  );
                } // else
              },
            ),
          )
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
