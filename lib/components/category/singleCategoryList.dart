import 'package:communitytabs/data/club_event_data.dart';
import 'package:communitytabs/services/database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:communitytabs/components/clubCardBig.dart';

class SingleCategoryView extends StatefulWidget {
  final String eventType;
  SingleCategoryView({this.eventType});
  @override
  _SingleCategoryViewState createState() => _SingleCategoryViewState();
}

class _SingleCategoryViewState extends State<SingleCategoryView> {
  Stream<List<ClubEventData>> _events;

  @override
  Widget build(BuildContext context) {
//    super.build(context);
    double screenHeight = MediaQuery.of(context).size.height;

    /// Student Category
    if (this.widget.eventType == 'Academic') {
      _events = Provider.of<DatabaseService>(context).streamAcademic;
    }
    else if (this.widget.eventType == 'Politcal') {
      _events = Provider.of<DatabaseService>(context).streamPolitical;
    }
    else if (this.widget.eventType == 'Media & Publication') {
      _events = Provider.of<DatabaseService>(context).streamMediaPublication;
    }

    /// Sports Category
    else if (this.widget.eventType == 'Club Sports') {
      _events = Provider.of<DatabaseService>(context).streamClubSports;
    }
    else if (this.widget.eventType == 'College Sports') {
      _events = Provider.of<DatabaseService>(context).streamCollegeSports;
    }
    else if (this.widget.eventType == 'Intramural') {
      _events = Provider.of<DatabaseService>(context).streamIntramural;
    }

    /// Diversity
    else if (this.widget.eventType == 'Culture') {
      _events = Provider.of<DatabaseService>(context).streamCulture;
    }
    else if (this.widget.eventType == 'Religion') {
      _events = Provider.of<DatabaseService>(context).streamReligion;
    }
    else if (this.widget.eventType == 'Spiritual') {
      _events = Provider.of<DatabaseService>(context).streamSpiritual;
    }

    /// Greek
    else if (this.widget.eventType == 'Fraternity') {
      _events = Provider.of<DatabaseService>(context).streamFraternity;
    }
    else if (this.widget.eventType == 'Sorority') {
      _events = Provider.of<DatabaseService>(context).streamSorority;
    }
    else if (this.widget.eventType == 'Rushes') {
      _events = Provider.of<DatabaseService>(context).streamRushes;

    }

    /// Food
    else if (this.widget.eventType == 'Free Food') {
      _events = Provider.of<DatabaseService>(context).streamFreeFood;
    }
    else if (this.widget.eventType == 'Marist Dining') {
      _events = Provider.of<DatabaseService>(context).streamMaristDining;
    }
    else if (this.widget.eventType == 'Occasions') {
      _events = Provider.of<DatabaseService>(context).streamOccasions;
    }

    /// Art
    else if (this.widget.eventType == 'Movies & Theatre') {
      _events = Provider.of<DatabaseService>(context).streamMoviesTheatre;
    }
    else if (this.widget.eventType == 'Music & Dance') {
      _events = Provider.of<DatabaseService>(context).streamMusicDance;
    }

    return Container(
      color: Colors.black,
      child: StreamBuilder<Object>(
          stream: _events,
          builder: (context, snapshot) {
            print(snapshot.data.runtimeType);
            print(snapshot.data.toString());
            List<ClubEventData> tempList = snapshot.data as List<ClubEventData>;
            int size = tempList?.length ?? 0;
            return ListView.builder(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemCount: size,
              itemBuilder: (context, index) {
                return index < size - 1
                    ? ClubBigCard(newEvent: tempList[index])
                    : Column(
                        children: <Widget>[
                          ClubBigCard(newEvent: tempList[index]),
                          SizedBox(
                            height: screenHeight * .1,
                            width: double.infinity,
                          ),
                        ],
                      );
              },
            );
          }),
    );
  }

//  @override
//  bool get wantKeepAlive => true;
}

//          snapshot = snapshot
//              .where((snapshot) => snapshot.myCategory.contains(this.widget.eventType))
//              .toList();
