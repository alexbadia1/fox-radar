import 'package:communitytabs/colors/marist_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:communitytabs/components/club_card.dart';
import 'package:communitytabs/data/club_event_data.dart';

class Suggestions extends StatefulWidget {
  @override
  _SuggestionsState createState() => _SuggestionsState();
}

class _SuggestionsState extends State<Suggestions> {
  List<ClubEventData> _events = [];

  @override
  Widget build(BuildContext context) {
    _events = Provider.of<List<ClubEventData>>(context);

    return Container(
      child: _events == null
          ? LoadingWidget()
          : ListView.builder(
              itemCount: _events?.length,
              itemBuilder: (BuildContext context, int index) {
                return clubCard(_events[index], context);
              }),
    );
  }
}
