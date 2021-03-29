import 'dart:io';
import 'package:flutter/material.dart';
import 'package:equatable/equatable.dart';

abstract class DeviceImagesState extends Equatable {
  const DeviceImagesState();
}

class DeviceImagesStateFetching extends DeviceImagesState {
  @override
  List<Object> get props => [];
} // SuggestedEventsFetching

class DeviceImagesStateFailed extends DeviceImagesState {
  @override
  List<Object> get props => [];
} // SuggestedEventsStateFailed

class DeviceImagesStateSuccess extends DeviceImagesState {
  final List<File> images;
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
} // SuggestedEventsStateFailed