import 'package:communitytabs/constants/marist_color_scheme.dart';
import 'package:communitytabs/logic/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

/// An option callback when the currently centered item changes.
///
/// The argument passed 'index' [int] changes when the item closest to the center changes.
/// NOTE: This callback is only triggered when scrolling settles, not during scrolls or ballistic flings.
typedef OnSelectedItemChangedCallback = void Function(int index);

class CategoryPicker extends StatelessWidget {
  final OnSelectedItemChangedCallback onSelectedItemChangedCallback;

  const CategoryPicker({Key key, @required this.onSelectedItemChangedCallback}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * .15,
      child: CupertinoTheme(
        data: CupertinoThemeData(
            textTheme: CupertinoTextThemeData(
                dateTimePickerTextStyle: TextStyle(color: Colors.white))),
        child: CupertinoPicker(
          backgroundColor: Colors.transparent,
          itemExtent: 40.0,
          children: [
            Center(
              child: Text(CATEGORIES[0], style: TextStyle(color: cWhite100)),
            ),
            Center(
              child: Text(CATEGORIES[1], style: TextStyle(color: cWhite100)),
            ),
            Center(
              child: Text(CATEGORIES[2], style: TextStyle(color: cWhite100)),
            ),
            Center(
              child: Text(CATEGORIES[3], style: TextStyle(color: cWhite100)),
            ),
            Center(
              child: Text(CATEGORIES[4], style: TextStyle(color: cWhite100)),
            ),
            Center(
              child: Text(CATEGORIES[5], style: TextStyle(color: cWhite100)),
            ),
            Center(
              child: Text(CATEGORIES[6], style: TextStyle(color: cWhite100)),
            ),
            Center(
              child: Text(CATEGORIES[7], style: TextStyle(color: cWhite100)),
            ),
            Center(
              child: Text(CATEGORIES[8], style: TextStyle(color: cWhite100)),
            ),
            Center(
              child: Text(CATEGORIES[9], style: TextStyle(color: cWhite100)),
            ),
            Center(
              child: Text(CATEGORIES[10], style: TextStyle(color: cWhite100)),
            ),
            Center(
              child: Text(CATEGORIES[11], style: TextStyle(color: cWhite100)),
            ),
            Center(
              child: Text(CATEGORIES[12], style: TextStyle(color: cWhite100)),
            ),
            Center(
              child: Text(CATEGORIES[13], style: TextStyle(color: cWhite100)),
            ),
            Center(
              child: Text(CATEGORIES[14], style: TextStyle(color: cWhite100)),
            ),
            Center(
              child: Text(CATEGORIES[15], style: TextStyle(color: cWhite100)),
            ),
            Center(
              child: Text(CATEGORIES[16], style: TextStyle(color: cWhite100)),
            ),
          ],
          onSelectedItemChanged: (index) {
            this.onSelectedItemChangedCallback(index);
          },
        ),
      ),
    );
  }// build
}// CategoryPicker
