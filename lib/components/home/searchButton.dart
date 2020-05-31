import 'package:communitytabs/colors/marist_color_scheme.dart';
import 'package:communitytabs/data/IconsStateProvider.dart';
import 'package:communitytabs/services/search.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SearchButton extends StatefulWidget {
  @override
  _SearchButtonState createState() => _SearchButtonState();
}

class _SearchButtonState extends State<SearchButton> {
  @override
  Widget build(BuildContext context) {
    return Consumer<IconStateProvider>(builder: (context, iconState, child) {
      return Container(
        child: iconState.showSearch
            ? IconButton(
                color: kHavenLightGray,
                splashColor: kActiveHavenLightGray,
                icon: Icon(Icons.search),
                onPressed: () async {
                  await showSearch(context: context, delegate: Search());
                },
              )
            : Container(
                child: iconState.formStepNum < 3
                    ? FlatButton(
                        textColor: Colors.blueAccent,
                        child: Text(
                          'Next',
                          style: TextStyle(fontSize: 16.0),
                        ),
                        onPressed: () {
                          ///TODO: Advance to the next step
                          iconState.setFormStepNum(iconState.formStepNum + 1);
                          iconState.pageViewController.animateToPage(iconState.formStepNum - 1, duration: const Duration(milliseconds: 400), curve: Curves.easeInOut);
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
              ),
      );
    });
  }
}
