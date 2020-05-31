import 'package:communitytabs/components/formPart1.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';
import 'package:communitytabs/data/pageViewMetadata.dart';
import 'package:communitytabs/components/addEvent/addEventHeader.dart';
import 'package:communitytabs/data/club_event_data.dart';

class AddEventContent extends StatefulWidget {
  @override
  _AddEventContentState createState() => _AddEventContentState();
}

class _AddEventContentState extends State<AddEventContent> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize:
              Size.fromHeight(MediaQuery.of(context).size.height * .0725),
          child: AddEventHeader(),
        ),
        body: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                SizedBox(width: MediaQuery.of(context).size.width * .05),
                FormTitle(),
                Expanded(
                  child: SizedBox(),
                ),
                ProgressBarHeader(),
                SizedBox(width: MediaQuery.of(context).size.width * .05),
              ],
            ),
            Expanded(child: EventForm()),
          ],
        ),
      ),
    );
  }
}

class FormTitle extends StatefulWidget {
  @override
  _FormTitleState createState() => _FormTitleState();
}

class _FormTitleState extends State<FormTitle> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Text(
          'Description',
          style: TextStyle(fontSize: 18.0),
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
  GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  ClubEventData newEvent = new ClubEventData.nullConstructor();
  @override
  Widget build(BuildContext context) {
    return Consumer<PageViewMetaData>(
      builder: (context, pageViewState, child) {
        return PageView(
          controller: pageViewState.pageViewController,
          physics: NeverScrollableScrollPhysics(),
          children: <Widget>[
            Container(
              child: FormPart1(formKey: _formKey, newEvent: newEvent),
            ),
            Container(
              color: Colors.greenAccent,
              child: Center(child: Text('2')),
            ),
            Container(
              color: Colors.blueAccent,
              child: Center(
                child: Text('3'),
              ),
            ),
          ],
        );
      },
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
    return Consumer<PageViewMetaData>(
      builder: (context, pageViewState, child) {
        return Container(
          child: StepProgressIndicator(
            totalSteps: 3,
            currentStep: pageViewState.formStepNum,
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
