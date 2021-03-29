import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:communitytabs/logic/blocs/blocs.dart';
import 'package:communitytabs/constants/marist_color_scheme.dart';

class SliverListHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final SuggestedEventsState _suggestedEventsState = context.watch<SuggestedEventsBloc>().state;

      if (_suggestedEventsState is SuggestedEventsStateFetching) {
        return SliverToBoxAdapter(child: Container());
      } // if

      return SliverToBoxAdapter(
        child: Container(
          height: screenHeight * .09,
          alignment: Alignment.centerLeft,
          decoration: BoxDecoration(
            color: Color.fromRGBO(33, 33, 33, 1.0),
            border: Border(
              top: BorderSide(
                color: Color.fromRGBO(61, 61, 61, 1.0),
              ),
            ),
          ),
          child: Row(
            children: [
              Expanded(
                flex: 1,
                child: SizedBox(),
              ),
              Text(
                'Suggestions',
                style: TextStyle(
                    color: cWhite100, fontSize: 16.5),
              ),
              Expanded(
                flex: 20,
                child: SizedBox(),
              ),
            ],
          ),
        ),
      );
  }// build
}// SliverListHeader
