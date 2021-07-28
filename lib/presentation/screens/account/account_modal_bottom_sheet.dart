import 'package:flutter/material.dart';
import 'package:communitytabs/presentation/presentation.dart';

class AccountModalBottomSheet extends StatelessWidget {
  // Spacing of menu items
  final _smallGutterFexFactor = 1;
  final _iconFlexFactor = 2;
  final _textFlexFactor = 19;

  // Colors
  final Color editColor = Colors.blueAccent;
  final Color deleteColor = Colors.redAccent;

  final String eventID;
  final String searchID;

  const AccountModalBottomSheet(
      {Key key, @required this.eventID, @required this.searchID})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final PageController _controller = new PageController();

    final screenHeight = MediaQuery.of(context).size.height;
    final screenPaddingBottom = MediaQuery.of(context).padding.bottom;
    final screenInsetsBottom = MediaQuery.of(context).viewInsets.bottom;
    final screenPaddingTop = MediaQuery.of(context).padding.top;

    final _realHeight = screenHeight -
        screenPaddingTop -
        screenPaddingBottom +
        screenInsetsBottom;

    return ConstrainedBox(
      constraints: BoxConstraints(
          minWidth: double.infinity, maxHeight: _realHeight * .3),
      child: Container(
        color: Color.fromRGBO(24, 24, 24, 1.0),
        child: Padding(
          padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
          child: PageView(
            controller: _controller,
            children: [
              SingleChildScrollView(
                child: Column(
                  children: [
                    /// Name: TextButton
                    ///
                    /// Description: Edit Event
                    TextButton(
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Expanded(
                              flex: this._smallGutterFexFactor,
                              child: SizedBox()),
                          Expanded(
                            flex: this._iconFlexFactor,
                            child: Icon(Icons.edit, color: this.editColor),
                          ),
                          Expanded(
                              flex: this._smallGutterFexFactor,
                              child: SizedBox()),
                          Expanded(
                            flex: this._textFlexFactor,
                            child: Text(
                              'Edit',
                              style: TextStyle(
                                  color: this.editColor, fontSize: 16.0),
                            ),
                          ),
                          Expanded(
                              flex: this._smallGutterFexFactor,
                              child: SizedBox()),
                        ],
                      ),
                      onPressed: () {},

                      // Let user cancel choice
                      onLongPress: () {}, // onLongPress
                    ),

                    /// Name: TextButton
                    ///
                    /// Description: Delete Event
                    TextButton(
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Expanded(
                              flex: this._smallGutterFexFactor,
                              child: SizedBox()),
                          Expanded(
                            flex: this._iconFlexFactor,
                            child: Icon(Icons.delete, color: this.deleteColor),
                          ),
                          Expanded(
                              flex: this._smallGutterFexFactor,
                              child: SizedBox()),
                          Expanded(
                            flex: this._textFlexFactor,
                            child: Text(
                              'Delete',
                              style: TextStyle(
                                  color: this.deleteColor, fontSize: 16.0),
                            ),
                          ),
                          Expanded(
                              flex: this._smallGutterFexFactor,
                              child: SizedBox()),
                        ],
                      ),
                      onPressed: () => _controller.jumpToPage(1),
                      // Let user cancel choice
                      onLongPress: () {}, // onLongPress
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * .04),

                    /// Name: TextButton
                    ///
                    /// Description: Cancel (Close Modal Bottom Sheet)
                    BorderTop(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: TextButton(
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Expanded(
                                  flex: this._smallGutterFexFactor,
                                  child: SizedBox()),
                              Expanded(
                                flex: this._iconFlexFactor,
                                child: Icon(Icons.cancel, color: cWhite70),
                              ),
                              Expanded(
                                  flex: this._smallGutterFexFactor,
                                  child: SizedBox()),
                              Expanded(
                                flex: this._textFlexFactor,
                                child: Text(
                                  'Cancel',
                                  style: TextStyle(
                                      color: cWhite70, fontSize: 16.0),
                                ),
                              ),
                              Expanded(
                                  flex: this._smallGutterFexFactor,
                                  child: SizedBox()),
                            ],
                          ),
                          onPressed: () => Navigator.pop(context),
                          // Let user cancel choice
                          onLongPress: () {}, // onLongPress
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              /// Confirm Delete Page
              Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(flex: 1, child: SizedBox()),
                  Text(
                    'Are you sure you want to delete: "[Event Name]?"',
                    maxLines: 2,
                    style: TextStyle(fontSize: 16.0, color: cWhite70),
                  ),
                  Expanded(flex: 1, child: SizedBox()),
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(flex: 1, child: SizedBox()),
                      TextButton(
                        child: Text(
                          'CANCEL',
                          style: TextStyle(
                            fontSize: 16.0,
                            color: Colors.blueAccent,
                          ),
                        ),
                        onPressed: () => _controller.jumpToPage(0),
                        // Let user cancel choice
                        onLongPress: () {}, // onLongPress
                      ),
                      Expanded(flex: 1, child: SizedBox()),
                      TextButton(
                        child: Text(
                          'CONFIRM',
                          style: TextStyle(
                            fontSize: 16.0,
                            color: Colors.redAccent,
                          ),
                        ),
                        onPressed: () {}, // onPressed
                        // Let user cancel choice
                        onLongPress: () {}, // onLongPress
                      ),
                      Expanded(flex: 1, child: SizedBox()),
                    ],
                  ),
                  Expanded(flex: 1, child: SizedBox()),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  } // build
} // AccountModalBottomSheet
