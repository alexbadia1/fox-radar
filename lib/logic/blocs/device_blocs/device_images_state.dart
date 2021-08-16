import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:equatable/equatable.dart';

abstract class DeviceImagesState extends Equatable {
  const DeviceImagesState();
}

class DeviceImagesStateFetching extends DeviceImagesState {
  @override
  List<Object> get props => [];
} // DeviceImagesStateFetching

class DeviceImagesStateFailed extends DeviceImagesState {
  final int failedAttempts;

  DeviceImagesStateFailed({@required this.failedAttempts}) : assert(failedAttempts != null && failedAttempts >= 0);

  @override
  List<Object> get props => [failedAttempts];
} // DeviceImagesStateFailed

class DeviceImagesStateDenied extends DeviceImagesState {
  @override
  List<Object> get props => [];
} // DeviceImagesStateDenied

class DeviceImagesStateSuccess extends DeviceImagesState {
  final List<Uint8List> images;
  final int lastPage;
  final bool maxImages;
  final bool isFetching;

  DeviceImagesStateSuccess(
      {@required this.images,
        @required this.lastPage,
        @required this.maxImages,
        @required this.isFetching});
  @override
  List<Object> get props => [images, maxImages, lastPage, isFetching];
} // DeviceImagesStateSuccess