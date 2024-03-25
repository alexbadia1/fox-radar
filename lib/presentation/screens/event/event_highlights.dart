import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fox_radar/presentation/presentation.dart';

class HighlightsList extends StatelessWidget {
  final IconData? icon;
  final List<String>? highlights;

  HighlightsList({this.icon, this.highlights});

  final List<Widget> highlightWidgets = [];
  @override
  Widget build(BuildContext context) {
    for (int i = 0; i < this.highlights!.length; ++i) {
      highlightWidgets.add(
        Padding(
          padding: const EdgeInsets.all(4.0),
          child: Subtitle(icon: Icons.add, text: this.highlights![i]),
        ),
      );
    } // for

    return Container(
      width: MediaQuery.of(context).size.width * .85,
      alignment: Alignment.centerRight,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: highlightWidgets,
      ),
    );
  }
}
