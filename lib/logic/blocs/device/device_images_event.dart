import 'package:equatable/equatable.dart';

abstract class DeviceImagesEvent extends Equatable {
  const DeviceImagesEvent();
}

class DeviceImagesEventFetch extends DeviceImagesEvent {
  @override
  List<Object> get props => [];
}// SuggestedEventsFetch