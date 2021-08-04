import 'category_screen_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:communitytabs/logic/logic.dart';

class CategoryScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final state = context.watch<CategoryPageCubit>().state;
    if (state is CategoryPageCategory) {
      switch (state.category) {
        case 'Sports':
          return CategoryBody(
            title: 'Sports',
            tabNamesFromLtoR: [INTRAMURAL, 'College', 'Club'],
          );
          break;
        case 'Arts':
          return CategoryBody(
            title: 'Arts',
            tabNamesFromLtoR: [MUSIC_AND_DANCE, MOVIES_THEATRE],
          );
          break;
        case 'Diversity':
          return CategoryBody(
            title: 'Diversity',
            tabNamesFromLtoR: [CULTURE, RELIGION, SPIRITUAL],
          );
          break;
        case 'Student':
          return CategoryBody(
            title: 'Student Interest',
            tabNamesFromLtoR: [ACADEMIC, POLITICAL, "Media"],
          );
          break;
        case 'Food':
          return CategoryBody(
            title: 'Marist Food',
            tabNamesFromLtoR: [MARIST_DINING, OCCASIONS, FREE_FOOD],
          );
          break;
        case 'Greek':
          return CategoryBody(
            title: 'Greek Life',
            tabNamesFromLtoR: [FRATERNITY, SORORITY, RUSHES],
          );
          break;
        default:
          return Center(
            child: Text('Oops!'),
          );
      } // switch
    }// if

    else {
      return Center(
        child: Text('Oops!'),
      );
    }// else
  }
}
