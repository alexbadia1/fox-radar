import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:communitytabs/data/pageViewMetadata.dart';

class NextOrCreateButton extends StatefulWidget {
  @override
  _NextOrCreateButtonState createState() => _NextOrCreateButtonState();
}

class _NextOrCreateButtonState extends State<NextOrCreateButton> {
  @override
  Widget build(BuildContext context) {
    return Consumer<PageViewMetaData>(
        builder: (context, pageViewState, child) {
          return Container(
            child: pageViewState.formStepNum < 3
                ? FlatButton(
              textColor: Colors.blueAccent,
              child: Text(
                'Next',
                style: TextStyle(fontSize: 16.0),
              ),
              onPressed: () {
                ///TODO: Advance to the next step
                pageViewState.setFormStepNum(pageViewState.formStepNum + 1);
                pageViewState.pageViewController.animateToPage(pageViewState.formStepNum - 1, duration: const Duration(milliseconds: 400), curve: Curves.easeInOut);
              },
            )
                : FlatButton(
              textColor: Colors.blueAccent,
              child: Text(
                'Create',
                style: TextStyle(fontSize: 16.0),
              ),
              onPressed: () {
                ///TODO: Submit the Event Form
              },
            ),
          );
        }
    );
  }
}