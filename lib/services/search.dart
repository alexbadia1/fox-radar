import 'package:communitytabs/colors/marist_color_scheme.dart';
import 'package:communitytabs/components/club_card.dart';
import 'package:communitytabs/data/club_event_data.dart';
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
    List<ClubEventData> resultEvents =
        Provider.of<List<ClubEventData>>(context);

    return resultEvents == null
        ? Center(
            child: Text('No Data'),
          )
        : ListView.builder(
            itemCount: resultEvents.length,
            itemBuilder: (context, index) {
              final results = resultEvents[index]
                      .getTitle
                      .toLowerCase()
                      .trim()
                      .contains(query.toLowerCase().trim())
                  ? resultEvents[index]
                  : null;
              return results == null
                  ? null
                  : clubCard(results, context);
            },
          );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    //Implements Search Suggestions
    //Use the 'query' variable. It stores what the user types in real time
    //MultiProvider was used in main.dart to create multiple StreamProviders, this class is a descendant of main and thus has access to the stream
    List<ClubEventData> suggestEvents =
        Provider.of<List<ClubEventData>>(context);

    return suggestEvents == null
        ? Center(
            child: Text('No Data'),
          )
        : ListView.builder(
            itemCount: suggestEvents.length,
            itemBuilder: (context, index) {
              final suggestion = suggestEvents[index]
                      .getTitle
                      .toLowerCase()
                      .trim()
                      .contains(query.toLowerCase().trim())
                  ? suggestEvents[index]
                  : null;
              return suggestion == null
                  ? null
                  : ListTile(
                      leading: IconButton(
                        icon: Icon(Icons.search),
                        onPressed: () {
                          //Show results
                          showResults(context);
                        },
                      ),
                      title: Text(suggestion.getTitle),
                      subtitle: Text(suggestion.getHost),
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
  } //buildSuggestions
}
