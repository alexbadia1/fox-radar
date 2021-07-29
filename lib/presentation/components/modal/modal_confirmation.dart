import 'package:flutter/material.dart';
import 'package:communitytabs/presentation/presentation.dart';

class ModalConfirmation extends StatelessWidget {
  final String prompt;
  final String cancelText;
  final Color cancelColor;
  final String confirmText;
  final Color confirmColor;
  final Function onCancel;
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
