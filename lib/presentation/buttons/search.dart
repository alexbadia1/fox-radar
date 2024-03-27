import 'package:database_repository/database_repository.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../components/cards/event_card.dart';
import '../utils/colors.dart';

class Search extends SearchDelegate {
  List<EventModel> myEvents = [];

  @override
  ThemeData appBarTheme(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return theme.copyWith(
      scaffoldBackgroundColor: cBackground,
      appBarTheme: AppBarTheme(
        backgroundColor: cBackground,
      ),
      textTheme: TextTheme(
        caption: TextStyle(color: Colors.white)
      ),
      inputDecorationTheme:
          InputDecorationTheme(
              hintStyle: TextStyle(color: kActiveHavenLightGray),
              border: InputBorder.none,
              fillColor: cBackground,
          ),
    );
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    //Same as the app bar where a list actions on the right
    return [
      query == ''
          ? IconButton(
              color: Colors.white,
              icon: Icon(Icons.mic),
              onPressed: () {},
            )
          : IconButton(
              color: Colors.white,
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
      color: Colors.white,
      splashColor: kActiveHavenLightGray,
      onPressed: () {
        //Close returning null for the result since the user canceled the search
        //Format: close(context, <result>);
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    DatabaseRepository _db = Provider.of<DatabaseRepository>(context);

    return FutureBuilder<List<SearchResultModel>>(
        future: _db.searchEventsByTitle(query),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final searchResults = snapshot.data as List<SearchResultModel>;
            return ListView.builder(
              itemCount: searchResults.length,
              itemBuilder: (context, index) {
                return EventCard(newSearchResult: searchResults[index]);
              },
            );
          } else {
            return Center(
              child: Text('No Data'),
            );
          }
        });
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    //Implements Search Suggestions
    //Use the 'query' variable. It stores what the user types in real time
    //MultiProvider was used in main.dart to create multiple StreamProviders, this class is a descendant of main and thus has access to the stream
    DatabaseRepository _db = Provider.of<DatabaseRepository>(context);

    return FutureBuilder<List<SearchResultModel>>(
        future: _db.searchSuggestions(query),
        builder: (context, snap) {
          if (snap.hasData) {
            final searchSuggestions = snap.data as List<SearchResultModel>;
            return searchSuggestions.isEmpty
                ? Center(
                    child: Text('No Data'),
                  )
                : ListView.builder(
                    itemCount: searchSuggestions.length,
                    itemBuilder: (context, index) {
                      final title = (searchSuggestions[index].title ?? '');
                      final host = (searchSuggestions[index].host ?? '');
                      final suggestion = title.toLowerCase().trim().contains(
                                query.toLowerCase().trim(),
                              )
                          ? searchSuggestions[index]
                          : null;
                      return suggestion == null
                          ? Container()
                          : ListTile(
                              leading: IconButton(
                                icon: Icon(Icons.search, color: Colors.white,),
                                onPressed: () {
                                  // Show results
                                  query = title;
                                  showResults(context);
                                },
                              ),
                              title: Text(title, style: TextStyle(color: Colors.white),),
                              subtitle: Text('Host: ' + host),
                              onTap: () {
                                // Show results for that search
                                showResults(context);
                              },
                              trailing: IconButton(
                                icon: Icon(Icons.call_made, color: Colors.white),
                                onPressed: () {
                                  // Replace search query with this suggestion
                                  query = title;
                                },
                              ),
                            );
                    },
                  );
          } else {
            return Center(
              child: Text('Getting Data...'),
            );
          }
        });
  }
}
