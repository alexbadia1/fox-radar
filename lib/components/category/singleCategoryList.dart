import 'package:communitytabs/data/club_event_data.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:communitytabs/components/clubCardBig.dart';

class SingleCategoryView extends StatefulWidget {
  final String eventType;
  SingleCategoryView({this.eventType});
  @override
  _SingleCategoryViewState createState() => _SingleCategoryViewState();
}

class _SingleCategoryViewState extends State<SingleCategoryView> with AutomaticKeepAliveClientMixin {
  List<ClubEventData> _events = [];

  @override
  Widget build(BuildContext context) {
    super.build(context);
    double screenHeight = MediaQuery.of(context).size.height;
    _events = Provider.of<List<ClubEventData>>(context) ?? [];
    _events = _events.where((_events) => _events.myCategory.contains(this.widget.eventType)).toList();
    int size = _events?.length ?? 0;

    return Container(
      color: Colors.black,
      child: ListView.builder(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        itemCount: size,
        itemBuilder: (context, index) {
          return index < size - 1
              ? clubCardBig(_events[index], context)
              : Column(
                  children: <Widget>[
                    clubCardBig(_events[index], context),
                    SizedBox(
                      height: screenHeight * .1,
                      width: double.infinity,
                    ),
                  ],
                );
        },
      ),
    );
  }
  @override
  bool get wantKeepAlive => true;
}
