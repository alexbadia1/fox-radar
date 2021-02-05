import 'package:flutter/material.dart';
import 'package:equatable/equatable.dart';

@immutable
abstract class CreateEventEvent extends Equatable{}

class CreateEventCreate extends CreateEventEvent {
  @override
  List<Object> get props => throw UnimplementedError();
}
