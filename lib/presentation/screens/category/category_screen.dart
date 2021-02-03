import 'package:communitytabs/logic/cubits/category_title_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'category_screen_body.dart';

class CategoryScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    switch (BlocProvider.of<CategoryTitleCubit>(context).category) {
      case 'Sports':
        return CategoryBody(
          title: 'Sports',
          tabNamesFromLtoR: ['Intramural', 'College', 'Club'],
        );
        break;
      case 'Arts':
        return CategoryBody(
          title: 'Arts',
          tabNamesFromLtoR: ['Music & Dance', 'Movies & Theatre'],
        );
        break;
      case 'Diversity':
        return CategoryBody(
          title: 'Diversity',
          tabNamesFromLtoR: ['Culture', 'Religion', 'Spiritual'],
        );
        break;
      case 'Student':
        return CategoryBody(
          title: 'Student Interest',
          tabNamesFromLtoR: ['Academic', 'Political', 'Media'],
        );
        break;
      case 'Food':
        return CategoryBody(
          title: 'Marist Food',
          tabNamesFromLtoR: ['Marist Dining', 'Occasions', 'Free Food'],
        );
        break;
      case 'Greek':
        return CategoryBody(
          title: 'Greek Life',
          tabNamesFromLtoR: ['Fraternity', 'Sorority', 'Rushes'],
        );
        break;
      default:
        return Center(
          child: Text('Oops!'),
        );
    }
  }
}
