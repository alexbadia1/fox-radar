import 'package:fox_radar/presentation/presentation.dart';
import 'package:flutter/material.dart';

class ModalActionMenu extends StatelessWidget {
  /// Message displayed to the user to prompt them
  /// to pick a choice from the list of [actions].
  ///
  /// IF the icons are self explanatory and the
  /// user task is assumed, the prompt is not necessary.
  final String prompt;

  /// Maps an Icon and it's description in a row,
  /// where each row is displayed vertically,
  /// in the order that they are listed.
  ///
  /// Displayed above the cancel button
  final List<ModalActionMenuButton>? actions;

  /// Message displayed under the Cancel Button
  ///
  /// Allows for [actions] to be added below the cancel button
  final String bottomActionsTitle;

  /// Maps an Icon and it's description in a row,
  /// where each row is displayed vertically,
  /// in the order that they are listed.
  ///
  /// Displayed under the cancel button
  final List<ModalActionMenuButton>? bottomActions;

  /// Whether or not a cancel button is
  /// included at the bottom of the modal sheet.
  final bool cancel;

  /// Expanded size of icon widget.
  final iconFlexFactor;

  /// Expanded size of text widget.
  final textFlexFactor;

  /// Spacing, in between the icons and text and borders.
  /// Change to manipulate the space around the icon and text widgets.
  final smallGutterFexFactor;

  /// Special widget placed directly underneath the
  /// bottom title but above the bottom actions.
  final Widget? featureWidget;

  final maxHeight;

  const ModalActionMenu(
      {Key? key,
      this.actions,
      this.featureWidget,
      this.bottomActions,
      this.bottomActionsTitle = "",
      this.prompt = '',
      this.cancel = false,
      this.iconFlexFactor = 2,
      this.textFlexFactor = 19,
      this.smallGutterFexFactor = 1, this.maxHeight})
      : super(key: key);

  @override
  Widget build(BuildContext pContext) {
    final _realHeight = MediaQuery.of(pContext).size.height -
        MediaQuery.of(pContext).padding.top -
        MediaQuery.of(pContext).padding.bottom +
        MediaQuery.of(pContext).viewInsets.bottom;

    // Dynamically ad widgets into the
    final List<Widget> widgets = [];

    // Only if user gave a prompt
    if (this.prompt.isNotEmpty) {
      widgets.add(Expanded(flex: 1, child: SizedBox()));
      widgets.add(
        Padding(
          padding: const EdgeInsets.only(left: 8.0, right: 8.0),
          child: Text(
            this.prompt,
            maxLines: 2,
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontSize: 16.0, color: cWhite70),
          ),
        ),
      );
      widgets.add(Expanded(flex: 1, child: SizedBox()));
    } // if

    // Add the choices to menu
    // User wants bottom actions
    if (this.actions != null) {
      this.actions!.forEach((ModalActionMenuButton btn) {
        widgets.add(btn);
      });
    } // if

    // If user chose a cancel button
    if (this.cancel) {
      // Add spacing for cancel button
      widgets.add(SizedBox(height: MediaQuery.of(pContext).size.height * .02));

      // Add actual "Cancel" Icon
      widgets.add(
        BorderTop(
          child: Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: ModalActionMenuButton(
              icon: Icons.close,
              description: 'Cancel',
              onPressed: () => Navigator.of(pContext).pop(),
            ),
          ),
        ),
      );
    } // if

    if (this.bottomActionsTitle != null && !this.cancel) {
      // Add actual "Cancel" Icon
      widgets.add(
        BorderBottom(
          child: ModalActionMenuButton(
            icon: Icons.close,
            description: this.bottomActionsTitle,
            onPressed: () => Navigator.of(pContext).popUntil((route) => route.isFirst),
          ),
        ),
      );
    } // if

    if (this.featureWidget != null) {
      widgets.add(featureWidget!);
    } // if

    // User wants bottom actions
    if (this.bottomActions != null) {
      // Add spacing below title
      widgets.add(SizedBox(height: MediaQuery.of(pContext).size.height * .02));

      // Add the choices to menu
      this.bottomActions!.forEach((ModalActionMenuButton btn) {
        widgets.add(btn);
      });
    } // if

    return ConstrainedBox(
      constraints: BoxConstraints(minWidth: double.infinity, maxHeight: this.maxHeight ?? _realHeight * .3),
      child: Container(
        color: Color.fromRGBO(24, 24, 24, 1.0),
        child: Padding(
          padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
          child: ListView(physics: const ScrollPhysics(), shrinkWrap: true, children: widgets),
        ),
      ),
    );
  } // build
} // ModalActionMenu
