import 'package:flutter/material.dart';
import 'package:equatable/equatable.dart';

@immutable
abstract class CategoryEventsEvent extends Equatable{
  const CategoryEventsEvent();
}// CategoryEventsEvent

class CategoryEventsEventFetch extends CategoryEventsEvent {
  @override
  List<Object> get props => [];
}// CategoryEventsEventFetch

class CategoryEventsEventReload extends CategoryEventsEvent {
  @override
  List<Object> get props => [];
}// CategoryEventsEventReload
