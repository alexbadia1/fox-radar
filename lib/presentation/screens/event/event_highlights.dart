import 'package:flutter/material.dart';
import 'event_subtitle.dart';

class HighlightsList extends StatelessWidget {
  final IconData icon;
  final List<String> highlights;

  const HighlightsList({this.icon, this.highlights});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        SizedBox(
          width: MediaQuery.of(context).size.width * .04275,
        ),
        Expanded(
          child: ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: highlights.length,
              itemBuilder: (context, index) {
                return Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Subtitle(
                          icon: Icons.add,
                          text: highlights[index]),
                    ),
                  ],
                );
              }),
        ),
        SizedBox(
          width: MediaQuery.of(context).size.width * .125,
        ),
      ],
    );
  }
}