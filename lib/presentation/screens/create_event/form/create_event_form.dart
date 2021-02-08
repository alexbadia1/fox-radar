import 'form.dart';
import 'package:flutter/material.dart';
import 'package:communitytabs/constants/marist_color_scheme.dart';

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
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            cVerticalMarginSmall(context),
            CreateEventFormRequired(),
            cVerticalMarginSmall(context),
            CreateEventFormTime(),
            // cVerticalMarginSmall(context),
            // Category(),
            // cVerticalMarginSmall(context),
            // FormSectionHighlights(),
            // cVerticalMarginSmall(context),
            CreateEventFormDescription(),
            // cVerticalMarginSmall(context),
          ],
        ),
      ),
    );
  }}// CreateEventForm