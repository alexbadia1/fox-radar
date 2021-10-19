import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fox_radar/logic/logic.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:fox_radar/presentation/presentation.dart';

class Time extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double _formSectionTimeWidth = MediaQuery.of(context).size.width;
    double _textFormFieldHeight = MediaQuery.of(context).size.height * .07;

    return Column(
      children: [
        BorderTopBottom(
          child: BlocProvider<DateTimePickerCubit>(
            create: (context) => DateTimePickerCubit(),
            child: Builder(builder: (context) {
              return ExpansionPanelDateTime(
                height: _textFormFieldHeight,
                title: 'Starts',
                hintText: 'Add Start Time',
                onTap: () {
                  FocusScope.of(context).unfocus();
                  final bool _expansionPanelIsOpen =
                      BlocProvider.of<DateTimePickerCubit>(context)
                          .state
                          .isOpen;

                  // Only open the expansion panel when the panel is closed
                  if (!_expansionPanelIsOpen) {
                    BlocProvider.of<DateTimePickerCubit>(context)
                        .openExpansionPanelToDatePicker();
                  } //
                },
                titleLabelCallback: (CreateEventState state) {
                  return state.eventModel.rawStartDateAndTime;
                },
                timeLabelCallback: (CreateEventState state) {
                  return state.eventModel.rawStartDateAndTime;
                },
                dateLabelCallback: (CreateEventState state) {
                  return state.eventModel.rawStartDateAndTime;
                },
                onConfirmButtonPressed: (DateTime dateTime) {
                  BlocProvider.of<CreateEventBloc>(context).add(
                      CreateEventSetRawStartDateTime(
                          newRawStartDateTime: dateTime));
                },
              );
            }),
          ),
        ),
        BorderBottom(
          child: BlocProvider<DateTimePickerCubit>(
            create: (context) => DateTimePickerCubit(),
            child: Builder(builder: (context) {
              CreateEventState state = context.watch<CreateEventBloc>().state;
              bool slideEnable = (state.eventModel.rawEndDateAndTime != null);
              return Slidable(
                enabled: slideEnable,
                direction: Axis.horizontal,
                actionPane: SlidableStrechActionPane(),
                actionExtentRatio: 0.15,
                child: ExpansionPanelDateTime(
                  height: _textFormFieldHeight,
                  title: 'Ends',
                  hintText: 'Add End Time',
                  onTap: () {
                    FocusScope.of(context).unfocus();
                    final bool _expansionPanelIsOpen =
                        BlocProvider.of<DateTimePickerCubit>(context)
                            .state
                            .isOpen;

                    // Only open the expansion panel when the panel is closed
                    if (!_expansionPanelIsOpen) {
                      BlocProvider.of<DateTimePickerCubit>(context)
                          .openExpansionPanelToDatePicker();
                    } //
                  },
                  titleLabelCallback: (CreateEventState state) {
                    return state.eventModel.rawEndDateAndTime;
                  },
                  timeLabelCallback: (CreateEventState state) {
                    return state.eventModel.rawEndDateAndTime;
                  },
                  dateLabelCallback: (CreateEventState state) {
                    return state.eventModel.rawEndDateAndTime;
                  },
                  onConfirmButtonPressed: (DateTime dateTime) {
                    BlocProvider.of<CreateEventBloc>(context).add(
                        CreateEventSetRawEndDateTime(
                            newRawEndDateTime: dateTime));
                  },
                ),

                /// Reveal a delete button, to remove the END DATE
                secondaryActions: <Widget>[
                  Container(
                    color: Colors.red,
                    child: Center(
                      child: Builder(
                          builder: (context) {
                            return IconButton(
                              key: UniqueKey(),
                              icon: Icon(Icons.delete, color: Colors.white),
                              onPressed: () {
                                Slidable.of(context).close();
                                // Remove the end date from the event bloc
                                BlocProvider.of<CreateEventBloc>(context).add(
                                    CreateEventRemoveRawEndDateTime()
                                );
                              },
                            );
                          }
                      ),
                    ),
                  ),
                ],
              );
            }),
          ),
        ),
      ],
    );
  }
}
