import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';
import '../data/IconsStateProvider.dart';
import 'package:communitytabs/components/addEvent/addEventHeader.dart';

class AddEventContent extends StatefulWidget {
  final bool hasHeader;
  AddEventContent({this.hasHeader});
  @override
  _AddEventContentState createState() => _AddEventContentState();
}

class _AddEventContentState extends State<AddEventContent> {
  ScrollController _controller = new ScrollController();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: this.widget.hasHeader
            ? PreferredSize(
                preferredSize:
                    Size.fromHeight(MediaQuery.of(context).size.height * .0725),
                child: AddEventHeader(),
              )
            : null,
        body: ListView(
          controller: _controller,
          children: [
            ProgressBarHeader(),
            EventForm(),
          ],
        ),
      ),
    );
  }
}

class EventForm extends StatefulWidget {
  @override
  _EventFormState createState() => _EventFormState();
}

class _EventFormState extends State<EventForm> {

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * .3,
      child: Consumer<IconStateProvider>(
        builder: (context, iconState, child) {
          return PageView(
            controller: iconState.pageViewController,
              children: <Widget>[
                Container(
                  color: Colors.redAccent,
                  child: Center(child: Text('1')),
                ),
                Container(
                  color: Colors.greenAccent,
                  child: Center(child: Text('2')),
                ),
                Container(
                  color: Colors.blueAccent,
                  child: Center(child: Text('3')),
                ),
              ],
          );
        },
      ),
    );
  }
}

class ProgressBarHeader extends StatefulWidget {
  @override
  _ProgressBarHeaderState createState() => _ProgressBarHeaderState();
}

class _ProgressBarHeaderState extends State<ProgressBarHeader> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: MediaQuery.of(context).size.height * .0725,
      child: ProgressIndicator(),
    );
  }
}

class ProgressIndicator extends StatefulWidget {
  @override
  _ProgressIndicatorState createState() => _ProgressIndicatorState();
}

class _ProgressIndicatorState extends State<ProgressIndicator> {
  @override
  Widget build(BuildContext context) {
    return Consumer<IconStateProvider>(
      builder: (context, iconState, child) {
        return Container(
          child: StepProgressIndicator(
            totalSteps: 3,
            currentStep: iconState.formStepNum,
            size: 36,
            selectedColor: Colors.green,
            unselectedColor: Colors.grey[200],
            customStep: (index, color, _) => color == Colors.green
                ? Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                          color: color, width: 2.0, style: BorderStyle.solid),
                    ),
                    child: Center(
                      child: Text(
                        (index + 1).toString(),
                      ),
                    ),
                  )
                : Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                          color: color, width: 2.0, style: BorderStyle.solid),
                    ),
                    child: Center(
                      child: Text(
                        (index + 1).toString(),
                        style: TextStyle(color: Colors.grey[200]),
                      ),
                    ),
                  ),
          ),
        );
      },
    );
  }
}
