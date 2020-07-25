import 'package:communitytabs/components/clubCardBig.dart';
import 'package:communitytabs/constants/marist_color_scheme.dart';
import 'package:communitytabs/components/club_card.dart';
import 'package:communitytabs/data/club_event_data.dart';
import 'package:communitytabs/data/searchResult.dart';
import 'package:communitytabs/services/database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Search extends SearchDelegate {
  List<ClubEventData> myEvents = [];

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
    DatabaseService _db = Provider.of<DatabaseService>(context);

    return FutureBuilder<List<ClubEventData>>(
        future: _db.deepFetchQuery(query),
        builder: (context, resultEvents) {
          if (resultEvents.hasData) {
            return ListView.builder(
              itemCount: resultEvents.data.length,
              itemBuilder: (context, index) {
                final results = resultEvents.data[index].getTitle
                        .toLowerCase()
                        .trim()
                        .contains(query.toLowerCase().trim())
                    ? resultEvents.data[index]
                    : null;
                return results == null ? null : ClubBigCard(newEvent: results);
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
    DatabaseService _db = Provider.of<DatabaseService>(context);

    return FutureBuilder<List<SearchResult>>(
        future: _db.shallowFetchQuery(query),
        builder: (context, snap) {
          if (snap.hasData) {
            return snap.data.isEmpty
                ? Center(
                    child: Text('No Data'),
                  )
                : ListView.builder(
                    itemCount: snap.data.length,
                    itemBuilder: (context, index) {
                      final suggestion = snap.data[index].getTitle
                              .toLowerCase()
                              .trim()
                              .contains(query.toLowerCase().trim())
                          ? snap.data[index]
                          : null;
                      return suggestion == null
                          ? null
                          : ListTile(
                              leading: IconButton(
                                icon: Icon(Icons.search),
                                onPressed: () {
                                  //Show results
                                  query = suggestion.getTitle;
                                  showResults(context);
                                },
                              ),
                              title: Text(suggestion.getTitle),
                              subtitle: Text(snap.data[index].getHost),
                              onTap: () {
                                //Show results for that search
                                showResults(context);
                              },
                              trailing: IconButton(
                                icon: Icon(Icons.call_made),
                                onPressed: () {
                                  //Replace search query with this suggestion
                                  query = suggestion.getTitle;
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
  } //buildSuggestions
}
