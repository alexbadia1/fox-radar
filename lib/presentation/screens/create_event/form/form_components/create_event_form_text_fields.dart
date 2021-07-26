import 'package:flutter/material.dart';
import 'package:communitytabs/presentation/presentation.dart';


typedef OnEditingCompleteOrLostFocusCallBack = void Function(String eventDetail);

/// A custom abstraction of the Form Field that implements a FocusNode with a listener
/// and a TextEditingController in order to create a form behavior that trims() user input
/// typical to that of normal web form behavior.
///
/// Also combines the onEditingComplete callback
/// and loss focus callback in one callback function onEditingCompleteOrLostFocus.
class CreateEventFormTextField extends StatefulWidget {

  /// Text that appears in the TextFormField
  final String initialTextValue;

  /// Text that suggests what sort of input the field accepts.
  ///
  /// Displayed on top of the InputDecorator.child (i.e., at the same location
  /// on the screen where text may be entered in the InputDecorator.child) when
  /// the input isEmpty and either (a) labelText is null or (b) the input has the focus
  final String hintText;

  /// Height of the of input field
  ///
  /// Default height: null
  final double height;

  /// Width of the of input field
  ///
  /// Default width: null
  final double width;

  /// Creates a FormField that contains a TextField.
  /// When a controller is specified, initialValue must be null (the default). If controller is null, then a TextEditingController will be constructed automatically and its text will be initialized to initialValue or the empty string.
  /// For documentation about the various parameters, see the TextField class and new TextField, the constructor.
  final TextInputType keyboardType;

  final int maxLines;

  final int minLines;

  /// A void callback that triggers when either the Form Field loses focus or on Editing Complete.
  ///
  /// Implemented with a _focusNode.addListener() to detect focus changes and the dart defined FormField
  /// property [onEditingComplete]. The argument passed back during the callback is the current FormFieldValue.
  final OnEditingCompleteOrLostFocusCallBack onEditingCompleteOrLostFocus;

  const CreateEventFormTextField({
    Key key,
    @required this.initialTextValue,
    @required this.hintText,
    @required this.height,
    @required this.width,
    @required this.onEditingCompleteOrLostFocus, this.keyboardType, this.maxLines, this.minLines,
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

    _focusNode = FocusNode();

    // Clear empty text when form loses focus
    //
    // The user can technically click to different form fields without actually pressing the
    // keyboard 'complete' button. So in order to ensure the form field function is triggered
    // a focus listener is added.
    _focusNode.addListener(() {
      if (!_focusNode.hasFocus) {
        if (temporaryTextFieldValue.trim().isEmpty) {
          this.widget.onEditingCompleteOrLostFocus('');
        } // if
        else {
          this.widget.onEditingCompleteOrLostFocus(temporaryTextFieldValue);
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
      color: Color.fromRGBO(33, 33, 33, 1.0),
      child: Row(
        children: <Widget>[
          cLeftMarginSmall(context),
          Expanded(
            child: TextFormField(
              keyboardType: this.widget.keyboardType,
              maxLines: this.widget.maxLines ?? 1,
              minLines: this.widget.minLines ?? 1,
              controller: _textEditingController,
              focusNode: _focusNode,
              style: TextStyle(color: cWhite100),
              textInputAction: TextInputAction.done,
              decoration: cAddEventTextFormFieldDecoration.copyWith(hintText: this.widget.hintText),

              // Clear empty text when form editing is completed
              //
              // onEditingComplete ONLY triggers when the keyboard 'complete' button is pressed by the user
              // onEditingComplete: () {
              //   if (temporaryTextFieldValue.trim().isEmpty) {
              //     this.widget.onEditingCompleteOrLostFocus('');
              //   } // if
              //   else {
              //     this.widget.onEditingCompleteOrLostFocus(_textEditingController.text);
              //   } // else
              //   _focusNode.unfocus();
              // },
              onChanged: (value) {
                temporaryTextFieldValue = value;

                // Prevents the user from hitting next while editing a text field
                this.widget.onEditingCompleteOrLostFocus(temporaryTextFieldValue);
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
    _textEditingController.dispose();
    super.dispose();
  } // dispose
} // _CreateEventFormTextFieldState
