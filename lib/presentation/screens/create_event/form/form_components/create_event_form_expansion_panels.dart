import 'package:communitytabs/constants/marist_color_scheme.dart';
import 'package:communitytabs/logic/blocs/blocs.dart';
import 'package:communitytabs/logic/cubits/cubits.dart';
import 'package:communitytabs/presentation/components/pickers/pickers.dart';
import 'package:communitytabs/presentation/screens/create_event/form/form.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';

typedef DateLabelCallback = DateTime Function(CreateEventState state);
typedef TimeLabelCallback = DateTime Function(CreateEventState state);
typedef OnConfirmButtonPressedCallback = void Function(DateTime dateTime);
typedef TitleLabelCallback = DateTime Function(CreateEventState state);
typedef OnHeaderTapCallback = void Function();

/// An Animated Container that listens to a bloc/cubit and animates changes in the UI.
/// Specifically, meant to mimic the function of the Flutter defined [ExpansionPanel]
class ExpansionPanelDateTime extends StatelessWidget {
  final double height;

  /// Text positioned in the leading left side of the widget when a non-null value is returned from the bloc
  final String title;

  /// Text positioned in the leading left side of the widget when a null value is returned from the bloc.
  final String hintText;

  /// A callback function that receives a CreateEventBloc State and returns a DateTime.
  ///
  /// The [ExpansionPanelTitle] listens to the DateTime value returned by the callback in order to
  /// display text with the correct [title] or [hintText]. NOTE: The DateTime should be retrieved from the CreateEventBloc State argument!
  final TitleLabelCallback titleLabelCallback;


  /// A callback function that receives a CreateEventBloc State and returns a DateTime.
  ///
  /// The [ExpansionPanelDateLabel] listens to the DateTime value returned by the callback function in order to
  /// display text with the correct Date. NOTE: The DateTime should be retrieved from the CreateEventBloc State argument!
  final DateLabelCallback dateLabelCallback;


  /// A callback function that receives a CreateEventBloc State and returns a DateTime.
  ///
  /// The [ExpansionPanelTimeLabel] listens to the DateTime value returned by the callback function in order to
  /// display text with the correct time. NOTE: The DateTime should be retrieved from the CreateEventBloc State argument!
  final TimeLabelCallback timeLabelCallback;

  /// A void callback that triggers from the Flutter defined Button onPressed() property.
  ///
  /// The argument passed back during the callback is the current temporary DateTime (stored in the ExpansionPanelCubit).
  /// You should use this "temporary DateTime" to update the CreateEventBloc.
  final OnConfirmButtonPressedCallback onConfirmButtonPressed;

  /// A void callback that triggers from the Flutter defined GestureDetector onTap() property.
  final OnHeaderTapCallback onTap;

  ExpansionPanelDateTime({
    @required this.height,
    @required this.title,
    @required this.hintText,
    @required this.titleLabelCallback,
    @required this.dateLabelCallback,
    @required this.timeLabelCallback,
    @required this.onConfirmButtonPressed,
    @required this.onTap,
  });
  @override
  Widget build(BuildContext context) {

    /// TODO: Make Animation look like the Expansion Tile Animation
    /// Probably involves manipulating the height of the container.
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
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

                  // Leading text, for hint text
                  ExpansionPanelTitle(
                    title: this.title,
                    hintText: this.hintText,
                    retrieveDateTimeFromBlocCallback: (CreateEventState state) {
                      return this.titleLabelCallback(state);
                    },
                  ),

                  Expanded(child: SizedBox()),

                  // Trailing text for date and time label
                  Row(
                    children: <Widget>[
                      ExpansionPanelDateLabel(
                        retrieveDateTimeFromBlocCallback:
                            (CreateEventState state) {
                          return this.dateLabelCallback(state);
                        },
                      ),

                      Container(
                          width: MediaQuery.of(context).size.width * .03225),
                      ExpansionPanelTimeLabel(
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

                // Show DatePicker
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

                // Show TimePicker
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

                // Show empty container, this may not be necessary
                else {
                  return Container(height: 0, width: 0);
                } // else
              }),

              // DateTime navigation buttons
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
                            onPressedCallback: (DateTime dateTime) {
                              this.onConfirmButtonPressed(dateTime);
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
