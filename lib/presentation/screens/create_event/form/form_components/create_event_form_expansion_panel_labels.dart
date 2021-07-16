import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:communitytabs/logic/logic.dart';
import 'package:communitytabs/presentation/presentation.dart';

/// Callback function used to return a DateTime from a CreateEventBloc State.
typedef RetrieveDateTimeFromBlocCallback = DateTime Function(
    CreateEventState currentState);

/// Callback function used to return a DateTime from a CreateEventBloc State.
typedef RetrieveCategoryFromBlocCallback = String Function(
    CreateEventState currentState);

/// Determines if the DateTime property of two CreateEventBloc states are equal or not.
///
/// Returns true if the two DateTimes are not equal,
/// since that means the DateTime changed between the two CreateEventBloc states.
bool _didDateChanged({
  @required DateTime previousDateTime,
  @required DateTime nextDateTime,
}) {
  // Null check, do not rebuild widget if both DateTimes are null.
  //
  // The End DateTime is optional and can technically be deleted, thus do not rebuild
  // this Text() widget if a non-existent [null] end DateTime is "deleted".
  if (previousDateTime == null && nextDateTime == null) {
    return false;
  } // if

  // User created a new DateTime, update Text() widget.
  else if (previousDateTime == null && nextDateTime != null) {
    return true;
  } // else if

  // User deleted a DateTime, update Text() widget.
  else if (previousDateTime != null && nextDateTime == null) {
    return true;
  } // else-if

  // User changed an existing DateTime to a different DateTime, update Text() widget.
  else {
    return previousDateTime != nextDateTime;
  } // else
} // didDateChanged

///  Determines if the Category property of two CreateEventBloc states are equal or not.
///
/// Returns true if the two Categories are not equal,
/// since that means the DateTime changed between the two CreateEventBloc states.
bool _didCategoryChanged({
  @required String previousCategory,
  @required String nextCategory,
}) {
  // Null check, do not rebuild widget if both DateTimes are null.
  //
  // The End DateTime is optional and can technically be deleted, thus do not rebuild
  // this Text() widget if a non-existent [null] end DateTime is "deleted".
  if (previousCategory == null && nextCategory == null) {
    return false;
  } // if

  // User created a new DateTime, update Text() widget.
  else if (previousCategory == null && nextCategory != null) {
    return true;
  } // else if

  // User deleted a DateTime, update Text() widget.
  else if (previousCategory != null && nextCategory == null) {
    return true;
  } // else-if

  // User changed an existing DateTime to a different DateTime, update Text() widget.
  else {
    return nextCategory != previousCategory;
  } // else
} // didDateChanged

class ExpansionPanelDateTimeTitle extends StatelessWidget {
  /// Text positioned in the leading left side of the
  /// widget when a non-null DateTime is returned from the bloc.
  final String title;

  /// Text positioned in the leading left side of the
  /// widget when a null DateTime is returned from the bloc.
  final String hintText;

  /// A function that receives a Bloc and returns a DateTime.
  ///
  /// Based on the DateTime received, this widget will rebuild itself showing the
  /// title [title] if [retrieveDateTimeFromBlocCallback] returns a non-null DateTime
  /// or the [hintText] if [retrieveDateTimeFromBlocCallback] returns a null DateTime value
  final RetrieveDateTimeFromBlocCallback retrieveDateTimeFromBlocCallback;

  const ExpansionPanelDateTimeTitle(
      {Key key,
      @required this.title,
      @required this.hintText,
      @required this.retrieveDateTimeFromBlocCallback})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // ExpansionPanelTitle listens to the the CreateEventBloc and rebuilds itself according to
    // the DateTime property of the CreateEventState
    return BlocBuilder<CreateEventBloc, CreateEventState>(
      buildWhen: (previousState, currentState) {
        return _didDateChanged(
          previousDateTime:
              this.retrieveDateTimeFromBlocCallback(previousState),
          nextDateTime: this.retrieveDateTimeFromBlocCallback(currentState),
        );
      }, // ListenWhen

      builder: (BuildContext context, createEventState) {
        if (retrieveDateTimeFromBlocCallback(createEventState) != null) {
          return Text(this.title,
              style: TextStyle(fontSize: 16.0, color: cWhite100));
        } // if
        else {
          return Text(this.hintText,
              style: TextStyle(fontSize: 14.0, color: cWhite65));
        } // else
      },
    );
  } // build
} // ExpansionPanelTitle

class ExpansionPanelDateLabel extends StatelessWidget {
  /// A function that receives a Bloc and returns a DateTime.
  ///
  /// Based on the DateTime received, this widget will rebuild itself showing the
  /// formatted DateTime [DateTime] returned by the callback [retrieveDateTimeFromBlocCallback] if non-null.
  final RetrieveDateTimeFromBlocCallback retrieveDateTimeFromBlocCallback;

  const ExpansionPanelDateLabel(
      {Key key, @required this.retrieveDateTimeFromBlocCallback})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreateEventBloc, CreateEventState>(
      buildWhen: (previousState, currentState) {
        return _didDateChanged(
          previousDateTime:
              this.retrieveDateTimeFromBlocCallback(previousState),
          nextDateTime: this.retrieveDateTimeFromBlocCallback(currentState),
        );
      }, // ListenWhen
      builder: (BuildContext context, createEventBlocState) {
        String _date = '';
        DateTime _rawDate =
            this.retrieveDateTimeFromBlocCallback(createEventBlocState);

        if (_rawDate != null) {
          _date = DateFormat('E, MMMM d, y').format(_rawDate);
        } // if

        return Text(_date, style: TextStyle(fontSize: 15.0, color: cWhite100));
      }, // Listener
    );
  } // build
} // DateLabel

class ExpansionPanelTimeLabel extends StatelessWidget {
  /// A function that receives a Bloc and returns a DateTime.
  ///
  /// Based on the DateTime received, this widget will rebuild itself showing the
  /// formatted DateTime [DateTime] returned by the callback [retrieveDateTimeFromBlocCallback] if non-null.
  final RetrieveDateTimeFromBlocCallback retrieveDateTimeFromBlocCallback;

  const ExpansionPanelTimeLabel(
      {Key key, this.retrieveDateTimeFromBlocCallback})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreateEventBloc, CreateEventState>(
      buildWhen: (previousState, currentState) {
        return _didDateChanged(
          previousDateTime:
              this.retrieveDateTimeFromBlocCallback(previousState),
          nextDateTime: this.retrieveDateTimeFromBlocCallback(currentState),
        );
      }, // ListenWhen

      builder: (BuildContext context, createEventBlocState) {
        String _timeOfDay = '';
        DateTime _rawTimeOfDay =
            this.retrieveDateTimeFromBlocCallback(createEventBlocState);
        if (_rawTimeOfDay != null) {
          _timeOfDay = DateFormat.jm().format(_rawTimeOfDay);
        } // if
        return Text(_timeOfDay,
            style: TextStyle(fontSize: 15.0, color: cWhite100));
      },
    );
  } // build
} // TimeLabel

class ExpansionPanelCategoryTitle extends StatelessWidget {
  /// Text positioned in the leading left side of the
  /// widget when a non-null Category is returned from the bloc.
  final String title;

  /// Text positioned in the leading left side of the
  /// widget when a null Category is returned from the bloc.
  final String hintText;

  /// A function that receives a Bloc and returns a Category.
  ///
  /// Based on the DateTime received, this widget will rebuild itself showing the
  /// title [title] if [retrieveCategoryFromBlocCallback] returns a non-null DateTime
  /// or the [hintText] if [retrieveCategoryFromBlocCallback] returns a null DateTime value
  final RetrieveCategoryFromBlocCallback retrieveCategoryFromBlocCallback;

  const ExpansionPanelCategoryTitle(
      {Key key,
      @required this.title,
      @required this.hintText,
      @required this.retrieveCategoryFromBlocCallback})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // ExpansionPanelTitle listens to the the CreateEventBloc and rebuilds itself according to
    // the DateTime property of the CreateEventState
    return BlocBuilder<CreateEventBloc, CreateEventState>(
      buildWhen: (previousState, currentState) {
        return _didCategoryChanged(
          previousCategory:
              this.retrieveCategoryFromBlocCallback(previousState),
          nextCategory: this.retrieveCategoryFromBlocCallback(currentState),
        );
      }, // ListenWhen

      builder: (BuildContext context, createEventState) {
        String _category = retrieveCategoryFromBlocCallback(createEventState);
        if (_category != null) {
          if (_category.isNotEmpty) {
            return Text(this.title,
                style: TextStyle(fontSize: 16.0, color: cWhite100));
          } // if
        } // if
        return Text(this.hintText,
            style: TextStyle(fontSize: 14.0, color: cWhite65));
      },
    );
  } // build
} // ExpansionPanelTitle

class ExpansionPanelCategoryLabel extends StatelessWidget {
  /// A function that receives a Bloc and returns a Category.
  ///
  /// Based on the Category received, this widget will rebuild itself showing the
  /// formatted Category [String] returned by the callback [retrieveCategoryFromBlocCallback] if non-null.
  final RetrieveCategoryFromBlocCallback retrieveCategoryFromBlocCallback;

  const ExpansionPanelCategoryLabel(
      {Key key, @required this.retrieveCategoryFromBlocCallback})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreateEventBloc, CreateEventState>(
      buildWhen: (previousState, currentState) {
        return _didCategoryChanged(
          previousCategory:
              this.retrieveCategoryFromBlocCallback(previousState),
          nextCategory: this.retrieveCategoryFromBlocCallback(currentState),
        );
      }, // ListenWhen
      builder: (BuildContext context, createEventBlocState) {
        String _category =
            this.retrieveCategoryFromBlocCallback(createEventBlocState);

        if (_category != null) {
          return Text(_category,
              style: TextStyle(fontSize: 15.0, color: cWhite100));
        } // if

        return Text('', style: TextStyle(fontSize: 15.0, color: cWhite100));
      }, // Listener
    );
  } // build
} // ExpansionPanelCategoryLabel
