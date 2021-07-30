import 'package:flutter/material.dart';
import 'package:communitytabs/presentation/presentation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:communitytabs/logic/logic.dart';

class SearchButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: IconButton(
        color: kHavenLightGray,
        splashColor: kActiveHavenLightGray,
        icon: Icon(Icons.search),
        onPressed: () async {
          BlocProvider.of<SlidingUpPanelCubit>(context).openPanel();
          // await showSearch(context: context, delegate: Search());
        },
      ),
    );
  }
}
