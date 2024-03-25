import 'package:flutter/material.dart';
import 'package:fox_radar/presentation/presentation.dart';

/*
  CustomListTile

  Material list tiles have restrictions and alignment issues, this list
  tile implementation allows for more flexibility like adding an Image() as
  the leading widget, and having trailing Icon buttons actually centered correctly.
 */
class CustomListTile extends StatelessWidget {
  final Widget? leading;
  final Widget? title;
  final Widget? subtitle;
  final Widget? description;
  final Widget? trailing;

  /// Adds a thin light gray top and
  /// bottom border to the custom list title.
  ///
  /// Defaults to true.
  final bool enableBorders;

  const CustomListTile({
    Key? key,
    this.leading,
    this.title,
    this.subtitle,
    this.description,
    this.trailing,
    this.enableBorders = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _realHeight = MediaQuery.of(context).size.height -
        MediaQuery.of(context).padding.top -
        MediaQuery.of(context).padding.bottom +
        MediaQuery.of(context).viewInsets.bottom;

    if (this.enableBorders) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 5.0),
        child: BorderTopBottom(
          child: ConstrainedBox(
            constraints: BoxConstraints(minWidth: double.infinity, minHeight: _realHeight * .12, maxHeight: _realHeight * .15),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Expanded(flex: 3, child: this.leading ?? SizedBox()),
                Expanded(
                  flex: 9,
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomListTileDescription(
                        title: this.title ?? SizedBox(),
                        subtitle: this.subtitle ?? SizedBox(),
                        description: this.description ?? SizedBox(),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: [this.trailing ?? SizedBox()],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }// if

    // No borders
    else {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 5.0),
        child: ConstrainedBox(
          constraints: BoxConstraints(minWidth: double.infinity, minHeight: _realHeight * .12, maxHeight: _realHeight * .15),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Expanded(flex: 3, child: this.leading ?? SizedBox()),
              Expanded(
                flex: 9,
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomListTileDescription(
                      title: this.title ?? SizedBox(),
                      subtitle: this.subtitle ?? SizedBox(),
                      description: this.description ?? SizedBox(),
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 2,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: [this.trailing ?? SizedBox()],
                ),
              ),
            ],
          ),
        ),
      );
    }// else
  } // build
} // CustomListTile

class CustomListTileDescription extends StatelessWidget {
  /// Widget shown in the first line.
  final Widget? title;

  /// Widget shown in the second line.
  final Widget? subtitle;

  /// Widget shown in the third line.
  final Widget? description;

  const CustomListTileDescription({
    Key? key,
    this.title,
    this.subtitle,
    this.description,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(5.0, 0.0, 0.0, 0.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          this.title ?? SizedBox(),
          SizedBox(height: 10.0),
          this.subtitle ?? SizedBox(),
          SizedBox(height: 5.0),
          this.description ?? SizedBox(),
        ],
      ),
    );
  }// build
} // CustomListTileDescription
