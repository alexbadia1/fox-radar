import 'category_screen_body.dart';
import 'package:flutter/material.dart';
import 'package:fox_radar/logic/logic.dart';

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
        case 'Arts':
          return CategoryBody(
            title: 'Arts',
            tabNamesFromLtoR: [MUSIC_AND_DANCE, MOVIES_THEATRE],
          );
        case 'Diversity':
          return CategoryBody(
            title: 'Diversity',
            tabNamesFromLtoR: [CULTURE, RELIGION, SPIRITUAL],
          );
        case 'Student':
          return CategoryBody(
            title: 'Student Interest',
            tabNamesFromLtoR: [ACADEMIC, POLITICAL, "Media"],
          );
        case 'Food':
          return CategoryBody(
            title: 'Marist Food',
            tabNamesFromLtoR: [MARIST_DINING, OCCASIONS, FREE_FOOD],
          );
        case 'Greek':
          return CategoryBody(
            title: 'Greek Life',
            tabNamesFromLtoR: [FRATERNITY, SORORITY, RUSHES],
          );
        default:
          return Center(
            child: Text('Oops!'),
          );
      }
    } else {
      return Center(
        child: Text('Oops!'),
      );
    }
  }
}
