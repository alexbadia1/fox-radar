import 'package:communitytabs/components/temporaryCancelButton.dart';
import 'package:flutter/material.dart';
import '../../colors/marist_color_scheme.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:communitytabs/data/IconsStateProvider.dart';
import '../../data/IconsStateProvider.dart';

class AddEventHeader extends StatefulWidget {
  @override
  _AddEventHeaderState createState() => _AddEventHeaderState();
}

class _AddEventHeaderState extends State<AddEventHeader> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.white,
      leading: TemporaryCloseButton(),
      title: Center(
        child: Text(
          'Add Event',
          style: TextStyle(color: kHavenLightGray, fontSize: 18.0, fontWeight: FontWeight.bold),
        ),
      ),
      actions: <Widget>[NextButton()],
      flexibleSpace: HeaderStyle(),
    );
  }
}

class NextButton extends StatefulWidget {
  final PageController c;
  NextButton({this.c});
  @override
  _NextButtonState createState() => _NextButtonState();
}

class _NextButtonState extends State<NextButton> {
  @override
  Widget build(BuildContext context) {
    return Consumer<IconStateProvider>(
      builder: (context, iconState, child) {
        return iconState.formStepNum < 3
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
              );
      },
    );
  }
}


class HeaderStyle extends StatefulWidget {
  @override
  _HeaderStyleState createState() => _HeaderStyleState();
}

class _HeaderStyleState extends State<HeaderStyle> {
  @override
  Widget build(BuildContext context) {
    return Container(
      key: UniqueKey(),
      height: MediaQuery.of(context).size.height * .0725,
      child: Stack(
        children: <Widget>[
          Image(
              key: UniqueKey(),
              width: double.infinity,
              height: 100.0,
              image: ResizeImage(
                AssetImage("images/tenney.jpg"),
                width: 500,
                height: 100,
              ),
              fit: BoxFit.fill),
          Container(
            decoration: BoxDecoration(gradient: cMaristGradientWashed),
          ),
        ],
      ),
    );
  }
}
