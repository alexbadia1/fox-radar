import 'package:database_repository/database_repository.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../components/cards/event_card.dart';
import '../utils/colors.dart';

class Search extends SearchDelegate {
  List<EventModel> myEvents = [];

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
                                icon: Icon(Icons.search),
                                onPressed: () {
                                  // Show results
                                  query = title;
                                  showResults(context);
                                },
                              ),
                              title: Text(title),
                              subtitle: Text('Host: ' + host),
                              onTap: () {
                                // Show results for that search
                                showResults(context);
                              },
                              trailing: IconButton(
                                icon: Icon(Icons.call_made),
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
