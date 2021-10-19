import 'package:flutter/material.dart';
import 'package:fox_radar/presentation/presentation.dart';

class ModalConfirmation extends StatelessWidget {
  /// Centered text appearing at the top of the modal bottom sheet.
  ///
  /// Tell the user something useful, though not required. If you
  /// aren't going to give a prompt, be sure the buttons uses are easily inferred.
  final String prompt;

  /// Text description of the "Cancel" Button (Button on the LEFT)
  final String cancelText;

  /// Text color of the "Cancel" Button (Button on the LEFT)
  final Color cancelColor;

  /// Text description of the "Confirm" Button (Button on the RIGHT)
  final String confirmText;

  /// Text color of the "Confirm" Button (Button on the RIGHT)
  final Color confirmColor;

  /// Function performed when the "Cancel" Button (Button on the LEFT) is pressed
  final Function onCancel;

  /// Function performed when the "Cancel" Button (Button on the RIGHT) is pressed
  final Function onConfirm;

  const ModalConfirmation(
      {Key key,
      this.prompt = '',
      this.cancelText = 'CANCEL',
      this.cancelColor = cWhite70,
      this.confirmText = 'CONFIRM',
      this.confirmColor = cWhite70,
      this.onCancel,
      this.onConfirm})
      : super(key: key);

  @override
  Widget build(BuildContext pContext) {
    final _realHeight = MediaQuery.of(pContext).size.height -
        MediaQuery.of(pContext).padding.top -
        MediaQuery.of(pContext).padding.bottom +
        MediaQuery.of(pContext).viewInsets.bottom;

    return ConstrainedBox(
      constraints: BoxConstraints(
          minWidth: double.infinity, maxHeight: _realHeight * .3),
      child: Container(
        color: Color.fromRGBO(24, 24, 24, 1.0),
        child: Padding(
          padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(flex: 1, child: SizedBox()),
              this.prompt.isNotEmpty
                  ? Padding(
                      padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                      child: Text(
                        this.prompt,
                        maxLines: 2,
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontSize: 16.0, color: cWhite70),
                      ),
                    )
                  : Expanded(flex: 1, child: SizedBox()),
              Expanded(flex: 1, child: SizedBox()),
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(flex: 1, child: SizedBox()),
                  TextButton(
                    child: Text(
                      this.cancelText,
                      style: TextStyle(
                        fontSize: 16.0,
                        color: this.cancelColor,
                      ),
                    ),
                    onPressed: this.onCancel,
                    // Let user cancel choice
                    onLongPress: () {}, //Let user cancel choice on long press
                  ),
                  Expanded(flex: 1, child: SizedBox()),
                  TextButton(
                    child: Text(
                      this.confirmText,
                      style: TextStyle(
                        fontSize: 16.0,
                        color: this.confirmColor,
                      ),
                    ),
                    onPressed: this.onConfirm,
                    onLongPress: () {}, //Let user cancel choice on long press
                  ),
                  Expanded(flex: 1, child: SizedBox()),
                ],
              ),
              Expanded(flex: 1, child: SizedBox()),
            ],
          ),
        ),
      ),
    );
  } // build
} // ModalConfirmation
