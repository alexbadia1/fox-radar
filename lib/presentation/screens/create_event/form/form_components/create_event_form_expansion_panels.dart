import 'package:communitytabs/constants/marist_color_scheme.dart';
import 'package:communitytabs/logic/blocs/blocs.dart';
import 'package:communitytabs/logic/cubits/cubits.dart';
import 'package:communitytabs/presentation/components/pickers/pickers.dart';
import 'package:communitytabs/presentation/screens/create_event/form/form.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';

typedef DateLabelCallback = DateTime Function(CreateEventState state);
typedef TimeLabelCallback = DateTime Function(CreateEventState state);
typedef ConfirmButtonCallback = void Function(DateTime dateTime);
typedef TitleLabelCallback = DateTime Function(CreateEventState state);
typedef OnHeaderTapCallback = void Function();

/// Returns an Expansion Panel,
/// While it goes against dart conventions, keep function
/// name Capitalized as this function basically serves as a Widget.
class ExpansionPanelDateTime extends StatelessWidget {
  final double height;
  final String title;
  final String hintText;
  final TitleLabelCallback titleLabelCallback;
  final DateLabelCallback dateLabelCallback;
  final TimeLabelCallback timeLabelCallback;
  final ConfirmButtonCallback confirmButtonCallback;
  final OnHeaderTapCallback onTap;

  ExpansionPanelDateTime({
    @required this.height,
    @required this.title,
    @required this.hintText,
    @required this.titleLabelCallback,
    @required this.dateLabelCallback,
    @required this.timeLabelCallback,
    @required this.confirmButtonCallback,
    @required this.onTap,
  });
  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 10000),
      child: Column(
        children: [
          GestureDetector(
            onTap: this.onTap,
            child: Container(
              height: this.height,
              width: double.infinity,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  cLeftMarginSmall(context),

                  /// Leading text, for hint text
                  ExpansionPanelTitle(
                    title: this.title,
                    hintText: this.hintText,
                    retrieveDateTimeFromBlocCallback: (CreateEventState state) {
                      return this.titleLabelCallback(state);
                    },
                  ),

                  Expanded(child: SizedBox()),

                  /// Trailing text for date and time label
                  Row(
                    children: <Widget>[
                      /// Date
                      DateLabel(
                        retrieveDateTimeFromBlocCallback:
                            (CreateEventState state) {
                          return this.dateLabelCallback(state);
                        },
                      ),

                      Container(
                          width: MediaQuery.of(context).size.width * .03225),

                      /// Time
                      TimeLabel(
                        retrieveDateTimeFromBlocCallback:
                            (CreateEventState state) {
                          return this.timeLabelCallback(state);
                        },
                      ),
                    ],
                  ),
                  cRightMarginSmall(context),
                ],
              ),
            ),
          ),
          Column(
            children: <Widget>[
              Builder(builder: (context) {
                final ExpansionPanelState _expansionPanelCubitState =
                    context.watch<ExpansionPanelCubit>().state;

                /// Show DatePicker
                if (_expansionPanelCubitState
                    is ExpansionPanelOpenShowDatePicker) {
                  return DatePicker(
                    initialSelectedDate: _expansionPanelCubitState.tempDateTime,
                    onDateSelectedCallback: (DateTime dateTime) {
                      BlocProvider.of<ExpansionPanelCubit>(context)
                          .openExpansionPanelToDatePicker(
                        tempDateTime: dateTime,
                      );
                    },
                  );
                } // if

                /// Show TimePicker
                else if (_expansionPanelCubitState
                    is ExpansionPanelOpenShowTimePicker) {
                  return TimePicker(
                    initialDateTime: _expansionPanelCubitState.tempDateTime,
                    onDateTimeChangedCallback: (dateTime) {
                      BlocProvider.of<ExpansionPanelCubit>(context)
                          .openExpansionPanelToTimePicker(
                              tempDateTime: dateTime);
                    },
                  );
                } // else-if

                /// Show empty container, this may not be necessary
                else {
                  return Container(height: 0, width: 0);
                } // else
              }),

              /// DateTime navigation buttons
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Builder(
                      builder: (BuildContext context) {
                        final _expansionPanelCubitState =
                            context.watch<ExpansionPanelCubit>().state;

                        if (_expansionPanelCubitState
                            is ExpansionPanelOpenShowDatePicker) {
                          return ExpansionPanelCancelButton();
                        } // if

                        else if (_expansionPanelCubitState
                            is ExpansionPanelOpenShowTimePicker) {
                          return ExpansionPanelBackButton();
                        } // else if

                        else {
                          return Container(height: 0, width: 0);
                        } // else
                      },
                    ),
                    Builder(
                      builder: (BuildContext context) {
                        final _expansionPanelCubitState =
                            context.watch<ExpansionPanelCubit>().state;

                        if (_expansionPanelCubitState
                            is ExpansionPanelOpenShowDatePicker) {
                          return ExpansionPanelContinueButton();
                        } // if

                        else if (_expansionPanelCubitState
                            is ExpansionPanelOpenShowTimePicker) {
                          return ExpansionPanelConfirmButton(
                            addEventBlocCallBloc: (DateTime dateTime) {
                              this.confirmButtonCallback(dateTime);
                            },
                          );
                        } // else if

                        else {
                          return Container(height: 0, width: 0);
                        } // else
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  } // build
} //
