import 'package:flutter/material.dart';
import 'package:fox_radar/presentation/presentation.dart';

class ModalActionMenuButton extends StatelessWidget {
  /// Description of the icon button's purpose
  final IconData icon;

  /// Description of the icon button's purpose
  final String description;

  /// Color of the icon and text
  final Color color;

  /// Expanded size of icon widget.
  final iconFlexFactor;

  /// Expanded size of text widget.
  final textFlexFactor;

  /// Spacing, in between the icons and text and borders.
  /// Change to manipulate the space around the icon and text widgets.
  final smallGutterFexFactor;

  /// Action performed when the button is pressed
  final Function onPressed;

  const ModalActionMenuButton(
      {Key key,
        @required this.icon,
        @required this.description,
        this.onPressed,
        this.color = cWhite70,
        this.iconFlexFactor = 2,
        this.textFlexFactor = 19,
        this.smallGutterFexFactor = 1})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(flex: this.smallGutterFexFactor, child: SizedBox()),
          Expanded(
            flex: this.iconFlexFactor,
            child: Icon(this.icon, color: this.color),
          ),
          Expanded(flex: this.smallGutterFexFactor, child: SizedBox()),
          Expanded(
            flex: this.textFlexFactor,
            child: Text(
              this.description,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(color: this.color, fontSize: 16.0),
            ),
          ),
          Expanded(flex: this.smallGutterFexFactor, child: SizedBox()),
        ],
      ),
      onPressed: onPressed,
      onLongPress: () {}, // Let user cancel choice on long press
    );
  } // build
} // ModalActionMenuButton