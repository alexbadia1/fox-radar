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
  String formattedEndDate;
  String formattedStartDate;

  FetchFullEventSuccess({@required this.eventModel}) : assert(eventModel != null) {
    end = this.eventModel.rawEndDateAndTime;
    start = this.eventModel.rawStartDateAndTime;
  }// FetchFullEventSuccess

  void formatEventDatesAndTimes() {
    final event = this.eventModel;

    DateTime myCurrent = DateTime(
        DateTime.now().year,
        DateTime.now().month,
        DateTime.now().day,
        DateTime.now().hour,
        DateTime.now().minute,
        0,
        0,
        0);

    if (myCurrent.difference(this.start).inDays == 0) {
      this.formattedStartDate = 'today';
    } else if (myCurrent.difference(this.start).inDays == 1) {
      this.formattedStartDate = 'yesterday';
    } else if (myCurrent.difference(this.start).inDays == -1) {
      this.formattedStartDate = 'tomorrow';
    } else {
      this.formattedStartDate = 'on ${event.startDate}';
    }

    if (this.end != null) {
      if (myCurrent.difference(this.end).inDays == 0) {
        formattedEndDate = 'today';
      } else if (myCurrent.difference(this.end).inDays == 1) {
        formattedEndDate = 'yesterday';
      } else if (myCurrent.difference(this.end).inDays == -1) {
        formattedEndDate = 'tomorrow';
      } else {
        formattedEndDate = 'on ${event.endDate}';
      }
    }

    if (myCurrent.isBefore(this.start)) {
      startSubtitle = 'Starts $formattedStartDate at ${event.startTime}';
      if (event.endDate.trim().isNotEmpty)
        endSubtitle = 'Ends $formattedEndDate at ${event.endTime}';
    } else if (myCurrent.isAtSameMomentAs(start)) {
      startSubtitle = 'Event starts now!';
      if (event.endDate.trim().isNotEmpty)
        endSubtitle = 'Ends at ${event.endTime} $formattedEndDate';
    } else if (myCurrent.isAfter(this.start)) {
      if (this.end != null) {
        if (myCurrent.isBefore(this.end)) {
          startSubtitle =
              'Started since ${event.startTime} ${this.formattedStartDate}';
          endSubtitle = 'Ends at ${event.endTime} $formattedEndDate';
        } else {
          startSubtitle = 'Ended since ${event.endTime} $formattedEndDate ';
        }
      } else {
        startSubtitle =
            'Started since ${event.startTime} ${this.formattedStartDate}';
      }
    } else {
      startSubtitle = 'Ended since ${event.startTime} $formattedEndDate ';
    }
  } // _formatEventDatesAndTimes

  @override
  List<Object> get props => [
        eventModel,
        end,
        start,
        endSubtitle,
        startSubtitle,
        formattedEndDate,
        formattedStartDate,
      ];
} // FetchEventSuccess

class FetchFullEventFailure extends FetchFullEventState {
  @override
  List<Object> get props => [];
} // FetchEventFailure
