import 'package:communitytabs/components/addEvent/formTitle.dart';
import 'package:communitytabs/components/addEvent/progressBar.dart';
import 'package:communitytabs/components/formPart1.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:communitytabs/data/pageViewMetadata.dart';
import 'package:communitytabs/components/addEvent/addEventAppBar.dart';
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
          child: AddEventAppBar(),
        ),
        body: Container(
          color: Colors.white,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              ///Form-Header: contains the changing title and progress bar
              Container(
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: Colors.black,
                    )
                  )
                ),
                width: double.infinity,
                height: MediaQuery.of(context).size.height * .0725,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    SizedBox(width: MediaQuery.of(context).size.width * .05),
                    FormTitle(),
                    Expanded(child: SizedBox()),
                    ProgressBar(),
                    SizedBox(width: MediaQuery.of(context).size.width * .05),
                  ],
                ),
              ),
              Expanded(child: EventForm()),
            ],
          ),
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
            FormPart1(formKey: _formKey, newEvent: newEvent),
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
