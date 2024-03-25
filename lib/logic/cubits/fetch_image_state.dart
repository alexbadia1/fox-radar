import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:equatable/equatable.dart';

@immutable
abstract class FetchImageState extends Equatable {
  const FetchImageState();
}

/// TODO: The initial state is the fetching state, make that clear!
class FetchImageInitial extends FetchImageState {
  @override
  List<Object?> get props => [];

}

class FetchImageSuccess extends FetchImageState {
  Uint8List imageBytes;

  FetchImageSuccess({required this.imageBytes});

  @override
  List<Object?> get props => [imageBytes];

}

class FetchImageFailure extends FetchImageState {
  @override
  List<Object?> get props => [];
}
