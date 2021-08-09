import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:communitytabs/logic/logic.dart';
import 'package:database_repository/database_repository.dart';
import 'package:communitytabs/presentation/presentation.dart';

typedef OnEditCallback = Function(EventModel);

class AccountModalBottomSheet extends StatelessWidget {
  /// The position the event in the list
  /// view the opened this modal bottom sheet.
  final int listViewIndex;

  /// The search result that the user
  /// clicked on the "More Vert Bar" icon.
  final SearchResultModel searchResultModel;

  final OnEditCallback onEdit;

  const AccountModalBottomSheet({Key key, @required this.searchResultModel, this.listViewIndex, this.onEdit})
      : assert(searchResultModel != null),
        super(key: key);

  @override
  Widget build(BuildContext pContext) {
    return ModalActionMenu(
      actions: [
        ModalActionMenuButton(
            icon: Icons.edit,
            description: "Edit",
            color: Colors.blueAccent,
            onPressed: () {
              final state = BlocProvider.of<FetchFullEventCubit>(pContext).state;
              if (state is FetchFullEventSuccess) {
                final EventModel event = state.eventModel;
                // Pass the "Full Event" the id's necessary to update it
                event.eventID = searchResultModel.eventId;
                event.searchID = searchResultModel.searchID;
                event.accountID = searchResultModel.accountID;
                print(event.toString());
                this.onEdit(event);
              } // if
            }),
        ModalActionMenuButton(
          icon: Icons.delete,
          description: "Delete",
          color: Colors.redAccent,
          onPressed: () {
            // Confirm Delete
            showModalBottomSheet(
                // Make sure user is focused on task at hand only
                isDismissible: false,
                context: pContext,
                builder: (confirmDeleteButtonContext) {
                  return BlocProvider.value(
                    value: BlocProvider.of<AccountEventsBloc>(pContext),
                    child: ConfirmDelete(searchResultModel: this.searchResultModel, listViewIndex: this.listViewIndex),
                  );
                });
          },
        )
      ],
      cancel: true,
    );
  } // build
} // AccountModalBottomSheet

class ConfirmDelete extends StatelessWidget {
  /// The position the event in the list
  /// view the opened this modal bottom sheet.
  final int listViewIndex;

  /// The search result that the user
  /// clicked on the "More Vert Bar" icon.
  final SearchResultModel searchResultModel;

  const ConfirmDelete({Key key, @required this.searchResultModel, @required this.listViewIndex})
      : assert(searchResultModel != null),
        assert(listViewIndex != null),
        super(key: key);

  @override
  Widget build(BuildContext pContext) {
    return ModalConfirmation(
      prompt: 'Are you sure you want to delete: "${this.searchResultModel.title}"?',

      // Put CANCEL on the left to make the user think twice
      cancelText: "CANCEL",
      cancelColor: Colors.blueAccent,
      onCancel: () => Navigator.of(pContext).popUntil((route) => route.isFirst),

      // Put CONFIRM on the left to make the user think twice
      confirmText: "CONFIRM",
      confirmColor: Colors.redAccent,
      onConfirm: () {
        // Send a delete event to the BloC
        BlocProvider.of<AccountEventsBloc>(pContext).add(
          AccountEventsEventRemove(listIndex: this.listViewIndex, searchResultModel: this.searchResultModel),
        );

        // Close all modal bottom sheets
        Navigator.of(pContext).popUntil((route) => route.isFirst);
      },
    );
  } // build
} // ConfirmDelete
