import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:equatable/equatable.dart';
import 'package:database_repository/database_repository.dart';

@immutable
abstract class FetchFullEventState extends Equatable {}

class FetchFullEventInitial extends FetchFullEventState {
  @override
  List<Object> get props => [];
} // FetchEventInitial

class FetchFullEventSuccess extends FetchFullEventState {
  final EventModel eventModel;
  DateTime end;
  DateTime start;
  String endSubtitle;
  String startSubtitle;

  FetchFullEventSuccess({@required this.eventModel})
      : assert(eventModel != null) {
    end = this.eventModel.rawEndDateAndTime;
    start = this.eventModel.rawStartDateAndTime;
    this.formatEventDatesAndTimes();
  } // FetchFullEventSuccess

  void formatEventDatesAndTimes() {

    DateTime myCurrent = DateTime(
        DateTime.now().year,
        DateTime.now().month,
        DateTime.now().day,
        DateTime.now().hour,
        DateTime.now().minute,
        0,
        0,
        0);

    // Format start times

    // Compare start time to now
    final int startDiffInDays = myCurrent.difference(this.start).inDays;
    final int startDiffInHours = myCurrent.difference(this.start).inHours;
    final int startDiffInMinutes = myCurrent.difference(this.start).inMinutes;

    final formattedStartTime = DateFormat.jm().format(this.start);
    final formattedStartDate = DateFormat('E, MMMM d, y').format(this.start);

    // Event is today now
    if (startDiffInDays == 0) {
      if (startDiffInMinutes == 0) {
        startSubtitle = "Event Starts Now!";
      } // if

      else if (startDiffInMinutes < 60) {
        startSubtitle = "Started $startDiffInMinutes minutes ago.";
      } // if

      else if (startDiffInHours <= 24) {
        startSubtitle = "Started $startDiffInHours hours ago.";
      } // if

      else {
        // This should never be reached
        startSubtitle = "Start $startDiffInHours hours ago.";
      } // else
    } // if

    // In the Future
    else if (startDiffInDays < 0) {
      if (startDiffInDays == -1) {
        // Starts tomorrow at [Insert Time]
        startSubtitle = "Starts tomorrow at $formattedStartTime";
      } // if

      else if (startDiffInDays > -7) {
        // Starts in ${startDiffInDays} at [Time]
        startSubtitle = "Starts in $startDiffInDays at $formattedStartTime";
      } // if

      else if (startDiffInDays == -7) {
        startSubtitle = "Starts next ${this.start.weekday} at $formattedStartTime";
      } // if

      else {
        startSubtitle = "Starts $formattedStartDate at $formattedStartTime";
      } // else
    } // else if

    // In the Past
    else {
      if (startDiffInDays == 1) {
        startSubtitle = "Started yesterday at $formattedStartTime";
      } // if

      else {
        startSubtitle = "Started since $formattedStartDate at $formattedStartTime";
      } // if
    } // else

    if (this.end != null) {

      // Compare start time to now
      final int endDiffInDays = myCurrent.difference(this.end).inDays;
      final int endDiffInHours = myCurrent.difference(this.end).inHours;
      final int endDiffInMinutes = myCurrent.difference(this.end).inMinutes;

      final formattedEndTime = DateFormat.jm().format(this.end);
      final formattedEndDate = DateFormat('E, MMMM d, y').format(this.end);

      // Event ends today
      if (endDiffInDays == 0) {
        if (endDiffInMinutes == 0) {
          endSubtitle = "Event is about to end now!";
        } // if

        else if (endDiffInMinutes > -60) {
          endSubtitle = "Ends in $endDiffInMinutes minutes.";
        } // if

        else if (endDiffInHours >= -24) {
          endSubtitle = "Ends in $startDiffInHours hours.";
        } // if

        else {
          // This should never be reached
          endSubtitle = "Ends $formattedEndDate at $formattedEndTime";
        } // else
      } // if

      // In the Future
      else if (endDiffInDays < 0) {
        if (endDiffInDays == -1) {
          endSubtitle = "Ends tomorrow at $formattedEndTime";
        } // if

        else if (endDiffInDays > -7) {
          endSubtitle = "Ends in $startDiffInDays days at $formattedEndTime";
        } // if

        else if (endDiffInDays == -7) {
          endSubtitle = "Ends next ${this.start.weekday} at $formattedEndTime";
        } // if

        else {
          endSubtitle = "Ends $formattedEndDate at $formattedEndTime";
        } // else
      } // else if

      // In the Past
      else {
        if (endDiffInDays == 1) {
          // Started yesterday since [Insert Time]
          endSubtitle = "Ended yesterday at $formattedEndTime";
        } // if

        else {
          // Started since [Date] at [Time]
          endSubtitle = "Ended $formattedEndDate at $formattedEndTime";
        } // if
      } // else
    }// else 
    
    else {
      endSubtitle = "";
    } // else
  } // _formatEventDatesAndTimes

  @override
  List<Object> get props => [
        eventModel,
        end,
        start,
        endSubtitle,
        startSubtitle,
      ];
} // FetchEventSuccess

class FetchFullEventFailure extends FetchFullEventState {
  final String msg;

  FetchFullEventFailure(this.msg) {
    print("[Fetch Full Event Failure]: ${this.msg}");
  }// FetchFullEventFailure
  
  @override
  List<Object> get props => [this.msg];
}// FetchEventFailure
