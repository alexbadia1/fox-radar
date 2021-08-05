import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:communitytabs/logic/logic.dart';
import 'package:communitytabs/presentation/presentation.dart';

class SliverListHeader extends StatelessWidget {
  final String text;
  final IconData icon;
  final Function onPressed;

  const SliverListHeader({Key key, @required this.text, this.onPressed, this.icon})
      : assert(text != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    if (this.onPressed != null) {
      return SliverToBoxAdapter(
        child: GestureDetector(
          onTap: this.onPressed,
          child: Container(
            height: screenHeight * .09,
            alignment: Alignment.centerLeft,
            decoration: BoxDecoration(
              color: Color.fromRGBO(33, 33, 33, 1.0),
              border: Border(
                top: BorderSide(
                  color: Color.fromRGBO(61, 61, 61, 1.0),
                ),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  flex: 1,
                  child: SizedBox(),
                ),
                this.icon != null ? Icon(this.icon, color: cWhite100) : Container(),
                this.icon != null ? Expanded(
                  flex: 1,
                  child: SizedBox(),
                ) : Container(),
                Text(
                  this.text ?? '[Header]',
                  style: TextStyle(color: cWhite100, fontSize: 16.5),
                ),
                Expanded(
                  flex: 20,
                  child: SizedBox(),
                ),
              ],
            ),
          ),
        ),
      );
    }// if

    return SliverToBoxAdapter(
      child: Container(
        height: screenHeight * .09,
        alignment: Alignment.centerLeft,
        decoration: BoxDecoration(
          color: Color.fromRGBO(33, 33, 33, 1.0),
          border: Border(
            top: BorderSide(
              color: Color.fromRGBO(61, 61, 61, 1.0),
            ),
          ),
        ),
        child: Row(
          children: [
            Expanded(
              flex: 1,
              child: SizedBox(),
            ),
            this.icon != null ? Icon(this.icon, color: cWhite100) : Container(),
            this.icon != null ? Expanded(
              flex: 1,
              child: SizedBox(),
            ) : Container(),
            Text(
              this.text ?? '[Header]',
              style: TextStyle(color: cWhite100, fontSize: 16.5),
            ),
            Expanded(
              flex: 20,
              child: SizedBox(),
            ),
          ],
        ),
      ),
    );
  } // build
} // SliverListHeader