import 'package:flutter/material.dart';
import 'package:fox_radar/presentation/presentation.dart';

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
