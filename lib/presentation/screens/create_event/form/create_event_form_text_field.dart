import 'package:flutter/material.dart';
import 'package:communitytabs/constants/marist_color_scheme.dart';

typedef AddEventCallback = void Function(String eventDetail);

class CreateEventFormTextField extends StatefulWidget {
  final String initialTextValue;
  final String hintText;
  final double height;
  final double width;
  final AddEventCallback addEventCallback;

  const CreateEventFormTextField({
    Key key,
    @required this.initialTextValue,
    @required this.hintText,
    @required this.height,
    @required this.width,
    @required this.addEventCallback,
  }) : super(key: key);

  @override
  _CreateEventFormTextFieldState createState() =>
      _CreateEventFormTextFieldState();
} // CreateEventFormTextField

class _CreateEventFormTextFieldState extends State<CreateEventFormTextField> {
  FocusNode _focusNode;
  String temporaryTextFieldValue;
  TextEditingController _textEditingController;

  @override
  void initState() {
    super.initState();

    /// OnEditing Complete does not trigger when the user changes focus
    /// without hitting the keyboard done button. Thus, a listener is required
    /// to do the same form validation as when the
    _focusNode = FocusNode();
    _focusNode.addListener(() {
      if (!_focusNode.hasFocus) {

        /// Automatically clear empty text fields
        if (temporaryTextFieldValue.trim().isEmpty) {
          this.widget.addEventCallback('');
        } // if
        else {
          this.widget.addEventCallback(temporaryTextFieldValue);
        } // else
      } // if
    });
  } // initState

  @override
  Widget build(BuildContext context) {

    _textEditingController = new TextEditingController(text: this.widget.initialTextValue);
    temporaryTextFieldValue = this.widget.initialTextValue;

    return Container(
      height: this.widget.height,
      width: this.widget.width,
      child: Row(
        children: <Widget>[
          cLeftMarginSmall(context),
          Expanded(
            child: TextFormField(
              controller: _textEditingController,
              focusNode: _focusNode,
              style: TextStyle(color: cWhite100),
              textInputAction: TextInputAction.done,
              decoration: cAddEventTextFormFieldDecoration.copyWith(hintText: this.widget.hintText),
              onEditingComplete: () {

                /// Automatically clear empty text fields
                if (temporaryTextFieldValue.trim().isEmpty) {
                  this.widget.addEventCallback('');
                } // if
                else {
                  this.widget.addEventCallback(_textEditingController.text);
                } // else
                _focusNode.unfocus();
              },
              onChanged: (value) {
                temporaryTextFieldValue = value;
              },
            ),
          ),
          cRightMarginSmall(context)
        ],
      ),
    );
  } // build

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  } // dispose
} // _CreateEventFormTextFieldState
