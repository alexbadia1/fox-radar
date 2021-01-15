import 'package:communitytabs/constants/marist_color_scheme.dart';
import 'package:communitytabs/services/deprecated_database.dart';
import 'file:///C:/Users/alex.badia1/Github/Marist_Community_Tabs/packages/search.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SearchButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: IconButton(
        color: kHavenLightGray,
        splashColor: kActiveHavenLightGray,
        icon: Icon(Icons.search),
        onPressed: () async {
          // await showSearch(context: context, delegate: Search());
        },
      ),
    );
  }
}
