import 'package:communitytabs/colors/marist_color_scheme.dart';
import 'package:flutter/material.dart';

class SportsSearch extends SearchDelegate {
  @override
  List<Widget> buildActions(BuildContext context) {
    //Same as the app bar where a list actions on the right
    return [
      query == ''
          ? IconButton(
              icon: Icon(Icons.mic),
              onPressed: () {},
            )
          : IconButton(
              icon: Icon(Icons.clear),
              onPressed: () {
                query = '';
              },
            ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    //Same as the app bar where the leading action appears on the left
    //Traditionally, the back button goes here
    return IconButton(
      icon: Icon(Icons.arrow_back),
      color: kHavenLightGray,
      splashColor: kActiveHavenLightGray,
      onPressed: () {
        //Close returning null for the result since the user canceled the search
        //Format: close(context, <result>);
        close(context, null);
      },
    );
  } //buildLeading

  @override
  Widget buildResults(BuildContext context) {
    // implement results from search
    return Container(
      child: Center(
        child: Text('Once submitted, search results appear here'),
      ),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    //Implements Search Suggestions
    //Use the 'query' variable. It stores what the user types in real time

    return Container(
      child: Center(
        child: Text('While typing, search suggestions appear here'),
      ),
    );
  }
}
