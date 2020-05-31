import 'package:communitytabs/constants/marist_color_scheme.dart';
import 'package:communitytabs/services/search.dart';
import 'package:flutter/material.dart';

class SearchButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: IconButton(
        color: kHavenLightGray,
        splashColor: kActiveHavenLightGray,
        icon: Icon(Icons.search),
        onPressed: () async {
          await showSearch(context: context, delegate: Search());
        },
      ),
    );
  }
}
