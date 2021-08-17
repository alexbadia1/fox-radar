import 'dart:async';
import 'package:communitytabs/logic/logic.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class DeviceNetworkBloc extends Bloc<DeviceNetworkEvent, DeviceNetworkState> {
  DeviceNetworkBloc() : super(DeviceNetworkStateUnknown());
  final Connectivity _connectivity = Connectivity();
  // Subscription used to monitor th devices network connectivity state
  StreamSubscription _streamSubscription;

  @override
  Stream<DeviceNetworkState> mapEventToState(DeviceNetworkEvent event) async* {
    if (event is DeviceNetworkEventListen) {
      _streamSubscription = _connectivity.onConnectivityChanged.listen((ConnectivityResult result) {
        this.add(DeviceNetworkEventChanged(result));
      }); // _streamSubscription

      // Stream only fires on change, so must check for initial state
      if (state is DeviceNetworkStateUnknown) {
        final ConnectivityResult _connectivityResult = await _connectivity.checkConnectivity();
        this.add(DeviceNetworkEventChanged(_connectivityResult));
      } // if
    } // if

    else if (event is DeviceNetworkEventChanged) {
      switch (event.connectivityResult) {
        case ConnectivityResult.wifi:
          yield DeviceNetworkStateWifi();
          break;
        case ConnectivityResult.mobile:
          yield DeviceNetworkStateMobile();
          break;
        case ConnectivityResult.none:
          yield DeviceNetworkStateNone();
          break;
        default:
          yield DeviceNetworkStateNone();
          break;
      } // switch
    } // else if

    else {
      // Unknown event received
    } // else
  } // mapEventToState

  @override
  void onChange(Change<DeviceNetworkState> change) {
    print("[Device Network Bloc] $change");
    super.onChange(change);
  } // onChange

  @override
  Future<void> close() {
    this._streamSubscription.cancel();
    return super.close();
  } // close
} // DeviceNetworkBloc
