import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:communitytabs/logic/blocs/blocs.dart';
import 'package:communitytabs/constants/marist_color_scheme.dart';

typedef RetrieveDateTimeFromBlocCallback = DateTime Function(
    CreateEventState currentState);

class ExpansionPanelTitle extends StatelessWidget {
  /// Text shown, when the DateTime is NOT null
  final String title;

  /// Text shown, when the DateTime IS null
  final String hintText;

  /// A function that returns a DateTime.
  /// The ExpansionPanelTitle only updates when the returned
  /// DateTime from the RetrieveDateTimeFromBlocCallback function changes.
  final RetrieveDateTimeFromBlocCallback retrieveDateTimeFromBlocCallback;

  const ExpansionPanelTitle(
      {Key key,
        @required this.title,
        @required this.hintText,
        @required this.retrieveDateTimeFromBlocCallback})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreateEventBloc, CreateEventState>(
      /// Only rebuild when the a date time is added or removed
      buildWhen: (previousState, currentState) {

        print(previousState.eventModel.getRawStartDateAndTime);
        print(currentState.eventModel.getRawStartDateAndTime);
        if (this.retrieveDateTimeFromBlocCallback(previousState) == null &&
            this.retrieveDateTimeFromBlocCallback(currentState) == null) {
          return false;
        }// if

        /// Null check on previous state, since the End Date is optional
        else if (retrieveDateTimeFromBlocCallback(previousState) == null &&
            retrieveDateTimeFromBlocCallback(currentState) != null) {
          return true;
        } // else if

        /// Null check on current state, since the End Date is optional
        else if (retrieveDateTimeFromBlocCallback(previousState) != null &&
            retrieveDateTimeFromBlocCallback(currentState) == null) {
          return true;
        } // else-if

        else {
          return false;
        } // else
      }, // ListenWhen

      /// Leading text, for hint text
      builder: (BuildContext context, createEventState) {
        if (retrieveDateTimeFromBlocCallback(createEventState) != null) {
          return Text(this.title,
              style: TextStyle(fontSize: 16.0, color: cWhite100));

        } // if

        else{
          return Text(this.hintText,
              style: TextStyle(fontSize: 12.0, color: cWhite65));
        }// else
      },
    );
  }// build
}// ExpansionPanelTitle

class DateLabel extends StatelessWidget {
  /// A function that returns a DateTime.
  /// The Date Label only updates when the returned
  /// DateTime from the RetrieveDateTimeFromBlocCallback function changes.
  final RetrieveDateTimeFromBlocCallback retrieveDateTimeFromBlocCallback;

  const DateLabel({Key key, @required this.retrieveDateTimeFromBlocCallback})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreateEventBloc, CreateEventState>(
      /// Only rebuild when the event date changes
      buildWhen: (previousState, currentState) {
        if (this.retrieveDateTimeFromBlocCallback(previousState) == null &&
            this.retrieveDateTimeFromBlocCallback(currentState) == null) {
          return false;
        }// if

        /// Null check on previous state, since the End Date is optional
        else if (this.retrieveDateTimeFromBlocCallback(previousState) == null &&
            this.retrieveDateTimeFromBlocCallback(currentState) != null) {
          return true;
        } // else if

        /// Null check on current state, since the End Date is optional
        else if (this.retrieveDateTimeFromBlocCallback(previousState) != null &&
            this.retrieveDateTimeFromBlocCallback(currentState) == null) {
          return true;
        } // else-if

        /// Check if the time was changed
        else {
          return (DateFormat('E, MMMM d, y').format(
              this.retrieveDateTimeFromBlocCallback(previousState)) !=
              DateFormat('E, MMMM d, y')
                  .format(this.retrieveDateTimeFromBlocCallback(currentState)));
        } // else

        /// Null check on previous state, since the End Date is optional
      }, // ListenWhen

      /// Shows the current chosen date by the user
      builder: (BuildContext context, createEventBlocState) {
        String _date = '';
        DateTime _rawDate =
        this.retrieveDateTimeFromBlocCallback(createEventBlocState);

        if (_rawDate != null) {
          _date = DateFormat('E, MMMM d, y').format(_rawDate);
        } // if

        return Text(_date, style: TextStyle(color: cWhite100));
      }, // Listener
    );
  } // build
} // DateLabel

class TimeLabel extends StatelessWidget {
  /// A function that returns a DateTime.
  /// The TimeLabel Label only updates when the returned
  /// DateTime from the RetrieveDateTimeFromBlocCallback function changes.
  final RetrieveDateTimeFromBlocCallback retrieveDateTimeFromBlocCallback;

  const TimeLabel({Key key, this.retrieveDateTimeFromBlocCallback})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreateEventBloc, CreateEventState>(
      /// Only rebuild when the event time changes
      buildWhen: (previousState, currentState) {
        if (this.retrieveDateTimeFromBlocCallback(previousState) == null &&
            this.retrieveDateTimeFromBlocCallback(currentState) == null) {
          return false;
        }// if

        /// Null check on previous state, since the End Time is optional
        else if (this.retrieveDateTimeFromBlocCallback(previousState) == null &&
            this.retrieveDateTimeFromBlocCallback(currentState) != null) {
          return true;
        } // else-if

        /// Null check on current state, since the End Time is optional
        else if (this.retrieveDateTimeFromBlocCallback(previousState) != null &&
            this.retrieveDateTimeFromBlocCallback(currentState) == null) {
          return true;
        } // else-if

        /// Check if the time was changed
        else {
          return (DateFormat.jm().format(
              this.retrieveDateTimeFromBlocCallback(previousState)) !=
              DateFormat.jm()
                  .format(this.retrieveDateTimeFromBlocCallback(currentState)));
        } // else
      }, // ListenWhen

      /// Shows the current chosen time by the user
      builder: (BuildContext context, createEventBlocState) {
        String _timeOfDay = '';

        DateTime _rawTimeOfDay =
        this.retrieveDateTimeFromBlocCallback(createEventBlocState);

        if (_rawTimeOfDay != null) {
          _timeOfDay = DateFormat.jm().format(_rawTimeOfDay);
        } // if

        return Text(_timeOfDay, style: TextStyle(color: cWhite100));
      },
    );
  } // build
} // TimeLabel
