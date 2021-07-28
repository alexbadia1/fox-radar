import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:communitytabs/logic/logic.dart';
import 'package:database_repository/database_repository.dart';
import 'package:communitytabs/presentation/presentation.dart';

class AccountModalBottomSheet extends StatelessWidget {
  // Spacing of menu items
  final _smallGutterFexFactor = 1;
  final _iconFlexFactor = 2;
  final _textFlexFactor = 19;

  // Colors
  final Color editColor = Colors.blueAccent;
  final Color deleteColor = Colors.redAccent;

  final int listViewIndex;
  final SearchResultModel searchResultModel;

  const AccountModalBottomSheet(
      {Key key, @required this.searchResultModel, this.listViewIndex})
      : assert(searchResultModel != null),
        super(key: key);

  @override
  Widget build(BuildContext parentContext) {
    final PageController _controller = new PageController();

    final screenHeight = MediaQuery.of(parentContext).size.height;
    final screenPaddingBottom = MediaQuery.of(parentContext).padding.bottom;
    final screenInsetsBottom = MediaQuery.of(parentContext).viewInsets.bottom;
    final screenPaddingTop = MediaQuery.of(parentContext).padding.top;

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
          child: SingleChildScrollView(
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
                          flex: this._smallGutterFexFactor, child: SizedBox()),
                      Expanded(
                        flex: this._iconFlexFactor,
                        child: Icon(Icons.edit, color: this.editColor),
                      ),
                      Expanded(
                          flex: this._smallGutterFexFactor, child: SizedBox()),
                      Expanded(
                        flex: this._textFlexFactor,
                        child: Text(
                          'Edit',
                          style:
                              TextStyle(color: this.editColor, fontSize: 16.0),
                        ),
                      ),
                      Expanded(
                          flex: this._smallGutterFexFactor, child: SizedBox()),
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
                          flex: this._smallGutterFexFactor, child: SizedBox()),
                      Expanded(
                        flex: this._iconFlexFactor,
                        child: Icon(Icons.delete, color: this.deleteColor),
                      ),
                      Expanded(
                          flex: this._smallGutterFexFactor, child: SizedBox()),
                      Expanded(
                        flex: this._textFlexFactor,
                        child: Text(
                          'Delete',
                          style: TextStyle(
                              color: this.deleteColor, fontSize: 16.0),
                        ),
                      ),
                      Expanded(
                          flex: this._smallGutterFexFactor, child: SizedBox()),
                    ],
                  ),
                  // onPressed: () => _controller.jumpToPage(1),
                  onPressed: () {
                    // When confirming to delete, the user
                    // must intentionally cancel or confirm, and
                    // can't accidentally dismiss the modal bottom sheet
                    showModalBottomSheet(
                        isDismissible: false,
                        context: parentContext,
                        builder: (confirmDeleteButtonContext) {
                          return BlocProvider.value(
                            value: BlocProvider.of<AccountEventsBloc>(
                                parentContext),
                            child: ConfirmDelete(
                                searchResultModel: this.searchResultModel,
                                listViewIndex: this.listViewIndex),
                          );
                        });
                  },
                  // Let user cancel choice
                  onLongPress: () {}, // onLongPress
                ),
                SizedBox(
                    height: MediaQuery.of(parentContext).size.height * .04),

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
                              style: TextStyle(color: cWhite70, fontSize: 16.0),
                            ),
                          ),
                          Expanded(
                              flex: this._smallGutterFexFactor,
                              child: SizedBox()),
                        ],
                      ),
                      onPressed: () => Navigator.pop(parentContext),
                      // Let user cancel choice
                      onLongPress: () {}, // onLongPress
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  } // build
} // AccountModalBottomSheet

class ConfirmDelete extends StatelessWidget {
  final int listViewIndex;
  final SearchResultModel searchResultModel;

  const ConfirmDelete(
      {Key key, @required this.searchResultModel, @required this.listViewIndex})
      : assert(searchResultModel != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
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
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(flex: 1, child: SizedBox()),
              Padding(
                padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                child: Text(
                  'Are you sure you want to delete: "${this.searchResultModel.title}"?',
                  maxLines: 2,
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 16.0, color: cWhite70),
                ),
              ),
              Expanded(flex: 1, child: SizedBox()),
              Builder(builder: (confirmDeleteContext) {
                final _state = context.watch<AccountEventsBloc>().state;

                if (!(_state is AccountEventsStateSuccess)) {
                  return Text('Nothing more to delete!',
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(color: cWhite70, fontSize: 16.0));
                } // if

                // Delete's so quick, user will probably never see this...
                else if (_state is AccountEventsStateSuccess && _state.isDeleting) {
                  return LoadingWidget(
                    color: cWhite70,
                  );
                } // if

                return Row(
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
                      onPressed: () => Navigator.of(context)
                          .popUntil((route) => route.isFirst),
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
                      onPressed: () {
                        // Send a delete event to the BloC
                        BlocProvider.of<AccountEventsBloc>(context).add(
                          AccountEventsEventRemove(
                              listIndex: this.listViewIndex,
                              searchResultModel: this.searchResultModel),
                        );

                        // Close all modal bottom sheets
                        Navigator.of(context).popUntil((route) => route.isFirst);
                      }, // onPressed
                      // Let user cancel choice
                      onLongPress: () {}, // onLongPress
                    ),
                    Expanded(flex: 1, child: SizedBox()),
                  ],
                );
              }),
              Expanded(flex: 1, child: SizedBox()),
            ],
          ),
        ),
      ),
    );
  } // build
} // ConfirmDelete
