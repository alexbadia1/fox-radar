import 'package:equatable/equatable.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class DeviceNetworkEvent extends Equatable {
  @override
  List<Object> get props => [];
}// DeviceNetworkEvent

class DeviceNetworkEventListen extends DeviceNetworkEvent {
  @override
  List<Object> get props => [];
}// DeviceNetworkEventListen

class DeviceNetworkEventChanged extends DeviceNetworkEvent {
  final ConnectivityResult connectivityResult;
  DeviceNetworkEventChanged(this.connectivityResult);

  @override
  List<Object> get props => [];
}// DeviceNetworkEventChanged