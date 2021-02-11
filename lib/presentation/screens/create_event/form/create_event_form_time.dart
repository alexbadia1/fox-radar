import 'form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:communitytabs/logic/blocs/blocs.dart';
import 'package:communitytabs/logic/cubits/cubits.dart';

class CreateEventFormTime extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double _formSectionTimeWidth = MediaQuery.of(context).size.width;
    double _textFormFieldHeight = MediaQuery.of(context).size.height * .07;

    return Column(
      children: [
        Container(
          width: _formSectionTimeWidth,
          child: BlocProvider<DateTimePickerCubit>(
            create: (context) => DateTimePickerCubit(),
            child: Builder(builder: (context) {
              return ExpansionPanelDateTime(
                height: _textFormFieldHeight,
                title: 'Starts',
                hintText: 'Add Start Time',
                onTap: () {
                  final bool _expansionPanelIsOpen =
                      BlocProvider.of<DateTimePickerCubit>(context)
                          .state
                          .isOpen;

                  /// Only open the expansion panel when the panel is closed
                  if (!_expansionPanelIsOpen) {
                    BlocProvider.of<DateTimePickerCubit>(context)
                        .openExpansionPanelToDatePicker();
                  } //
                },
                titleLabelCallback: (CreateEventState state) {
                  return state.eventModel.getRawStartDateAndTime;
                },
                timeLabelCallback: (CreateEventState state) {
                  return state.eventModel.getRawStartDateAndTime;
                },
                dateLabelCallback: (CreateEventState state) {
                  return state.eventModel.getRawStartDateAndTime;
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
        Container(
          width: _formSectionTimeWidth,
          child: BlocProvider<DateTimePickerCubit>(
            create: (context) => DateTimePickerCubit(),
            child: Builder(builder: (context) {
              return ExpansionPanelDateTime(
                height: _textFormFieldHeight,
                title: 'Ends',
                hintText: 'Add End Time',
                onTap: () {
                  final bool _expansionPanelIsOpen =
                      BlocProvider.of<DateTimePickerCubit>(context)
                          .state
                          .isOpen;

                  /// Only open the expansion panel when the panel is closed
                  if (!_expansionPanelIsOpen) {
                    BlocProvider.of<DateTimePickerCubit>(context)
                        .openExpansionPanelToDatePicker();
                  } //
                },
                titleLabelCallback: (CreateEventState state) {
                  return state.eventModel.getRawEndDateAndTime;
                },
                timeLabelCallback: (CreateEventState state) {
                  return state.eventModel.getRawEndDateAndTime;
                },
                dateLabelCallback: (CreateEventState state) {
                  return state.eventModel.getRawEndDateAndTime;
                },
                onConfirmButtonPressed: (DateTime dateTime) {
                  BlocProvider.of<CreateEventBloc>(context).add(
                      CreateEventSetRawEndDateTime(
                          newRawEndDateTime: dateTime));
                },
              );
            }),
          ),
        ),
      ],
    );
  }
}
