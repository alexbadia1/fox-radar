import 'package:communitytabs/constants/marist_color_scheme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class EventDetails extends StatelessWidget {
  final myEvent;
  EventDetails({this.myEvent});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: GestureDetector(
          onPanUpdate: (details) {
            if (details.delta.dx > 0) {
              Navigator.pop(context);
            }
          },
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Container(
              width: MediaQuery.of(context).size.width,
              child: Column(
                children: <Widget>[
                  Container(
                    width: double.infinity,
                    child: Image(image: AssetImage(myEvent.getImage)),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height * .15,
                    child: Column(
                      children: <Widget>[
                        Expanded(
                          flex: 3,
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(4.0, 0, 0, 0),
                            child: Container(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                myEvent.getHost,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 36.0,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Lato',
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                flex: 1,
                                child: Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(8.0, 0, 0, 0),
                                  child: Container(
                                    child: Icon(
                                      Icons.location_on,
                                      size: 12.0,
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 18,
                                child: Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(8.0, 0, 0, 0),
                                  child: Container(
                                    child: Text(
                                      myEvent.getLocation + myEvent.getRoom,
                                      style: TextStyle(
                                        fontSize: 12.0,
                                        fontWeight: FontWeight.w300,
                                        fontFamily: 'Lato',
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                flex: 1,
                                child: Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(8.0, 0, 0, 0),
                                  child: Container(
                                    child: Icon(
                                      Icons.av_timer,
                                      size: 12.0,
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 18,
                                child: Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(8.0, 0, 0, 0),
                                  child: Container(
                                    child: Text(
                                      myEvent.getStartTime +
                                          " - " +
                                          myEvent.getEndTime,
                                      style: TextStyle(
                                        fontSize: 12.0,
                                        fontWeight: FontWeight.w300,
                                        fontFamily: 'Lato',
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  //HighLights
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height * .40,
                    child: Column(
                      children: <Widget>[
                        Expanded(
                          flex: 1,
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(4.0, 0, 0, 0),
                            child: Container(
                              alignment: Alignment.bottomLeft,
                              child: Text(
                                "Highlights",
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 28.0,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Lato',
                                ),
                              ),
                            ),
                          ),
                        ),
//                      Expanded(
//                        flex: 2,
//                        child: ListView.builder(
//                            physics: NeverScrollableScrollPhysics(),
//                            key: key,
//                            itemCount: _myEvent.getHighlights.length,
//                            itemBuilder: (BuildContext context, int index) {
//                              return highlight(context,
//                                  _myEvent.getHighlights.elementAt(index).toString());
//                            }),
//                      ),
                      ],
                    ),
                  ),

                  Container(
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.fromLTRB(4.0, 17.0, 0, 0),
                          child: Container(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              myEvent.getTitle,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 28.0,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Lato',
                              ),
                            ),
                          ),
                        ),
                        Container(
                          child: Padding(
                            padding:
                                const EdgeInsets.fromLTRB(15.0, 12.0, 0, 15.0),
                            child: Container(
                              alignment: Alignment.topLeft,
                              width: MediaQuery.of(context).size.width * .80,
                              child: Text(
                                myEvent.getSummary,
                                style: TextStyle(
                                  fontSize: 12.0,
                                  fontWeight: FontWeight.w300,
                                  fontFamily: 'Lato',
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 25.0, 0, 30.0),
                    child: Container(
                      child: FloatingActionButton(
                        backgroundColor: cIlearnGreen,
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Icon(
                          Icons.close,
                          size: 32.0,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

Widget highlight(BuildContext context, String $highlight) {
  return Row(mainAxisSize: MainAxisSize.max, children: <Widget>[
    SizedBox(
      height: MediaQuery.of(context).size.height * .0475,
    ),
    Expanded(
      flex: 1,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(15.0, 0, 0, 0),
        child: Container(
            child: Icon(
          Icons.add,
          size: 12.0,
        )),
      ),
    ),
    Expanded(
      flex: 18,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(15.0, 0, 0, 0),
        child: Container(
            child: Text($highlight,
                style: TextStyle(
                    fontSize: 12.0,
                    fontWeight: FontWeight.w300,
                    fontFamily: 'Lato'))),
      ),
    ),
  ]);
}
