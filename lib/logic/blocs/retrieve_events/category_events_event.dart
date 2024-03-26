import 'package:flutter/material.dart';
import 'package:equatable/equatable.dart';

@immutable
abstract class CategoryEventsEvent extends Equatable {
  const CategoryEventsEvent();
}

class CategoryEventsEventFetch extends CategoryEventsEvent {
  @override
  List<Object?> get props => [];
}

class CategoryEventsEventReload extends CategoryEventsEvent {
  @override
  List<Object?> get props => [];
}
