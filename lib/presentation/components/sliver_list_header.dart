import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:communitytabs/logic/logic.dart';
import 'package:communitytabs/presentation/presentation.dart';

class SliverListHeader extends StatelessWidget {
  final String text;

  const SliverListHeader({Key key, @required this.text})
      : assert(text != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

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
