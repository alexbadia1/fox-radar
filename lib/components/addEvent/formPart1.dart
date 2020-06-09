import 'package:communitytabs/components/addEvent/form_section_description.dart';
import 'package:communitytabs/components/addEvent/form_section_time.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:communitytabs/constants/marist_color_scheme.dart';
import 'form_section_highlights.dart';
import 'cupertinoCategoryPicker.dart';
import 'form_section_event.dart';

class FormPart1 extends StatefulWidget {

  @override
  _FormPart1State createState() => _FormPart1State();
}

class _FormPart1State extends State<FormPart1> {
  GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            cVerticalMarginSmall(context),
            FormSectionEvent(),
            cVerticalMarginSmall(context),
            FormSectionTime(),
            cVerticalMarginSmall(context),
            Category(),
            cVerticalMarginSmall(context),
            FormSectionHighlights(),
            cVerticalMarginSmall(context),
            FormSectionDescription(),
            cVerticalMarginSmall(context),
          ],
        ),
      ),
    );
  }
}
