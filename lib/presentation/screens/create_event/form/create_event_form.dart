import 'package:flutter/material.dart';
import 'package:fox_radar/presentation/presentation.dart';

/// Stateful Widget Required
/// If not, the keyboard will immediately dismiss itself upon trying
/// to edit a text field... This issue has to do with rebuilding the widget
/// and the form key... Do some further investigation on this...
class CreateEventForm extends StatefulWidget {
  @override
  _CreateEventFormState createState() => _CreateEventFormState();
}

class _CreateEventFormState extends State<CreateEventForm> {
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: AlwaysScrollableScrollPhysics(),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            SizedBox(height: MediaQuery.of(context).size.height * .05),
            Required(),
            SizedBox(height: MediaQuery.of(context).size.height * .05),
            Time(),
            SizedBox(height: MediaQuery.of(context).size.height * .05),
            Category(),
            SizedBox(height: MediaQuery.of(context).size.height * .05),
            Highlights(),
            SizedBox(height: MediaQuery.of(context).size.height * .05),
            Description(),
            SizedBox(height: MediaQuery.of(context).size.height * .05),
          ],
        ),
      ),
    );
  }
}
