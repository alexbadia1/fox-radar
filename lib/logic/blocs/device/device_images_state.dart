import 'dart:typed_data';
import 'package:equatable/equatable.dart';

abstract class DeviceImagesState extends Equatable {
  const DeviceImagesState();
}

class DeviceImagesStateFetching extends DeviceImagesState {
  @override
  List<Object?> get props => [];
}

class DeviceImagesStateFailed extends DeviceImagesState {
  final int failedAttempts;

  DeviceImagesStateFailed({required this.failedAttempts})
      : assert(failedAttempts >= 0);

  @override
  List<Object?> get props => [failedAttempts];
}

class DeviceImagesStateDenied extends DeviceImagesState {
  @override
  List<Object?> get props => [];
}

class DeviceImagesStateSuccess extends DeviceImagesState {
  final List<String> paths;
  final List<Uint8List> images;
  final int lastPage;
  final bool maxImages;
  final bool isFetching;

  DeviceImagesStateSuccess({
    required this.paths,
    required this.images,
    required this.lastPage,
    required this.maxImages,
    required this.isFetching,
  });
  @override
  List<Object?> get props => [images, maxImages, lastPage, isFetching];
}
