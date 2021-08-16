import 'dart:async';
import 'package:communitytabs/logic/logic.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class DeviceNetworkBloc extends Bloc<DeviceNetworkEvent, DeviceNetworkState> {
  DeviceNetworkBloc() : super(DeviceNetworkStateUnknown());

  // Subscription used to monitor th devices network connectivity state
  StreamSubscription _streamSubscription;

  @override
  Stream<DeviceNetworkState> mapEventToState(DeviceNetworkEvent event) async* {
    if (event is DeviceNetworkEventListen) {
      _streamSubscription = Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
        this.add(DeviceNetworkEventChanged(result));
      }); // _streamSubscription
    } // if

    else if (event is DeviceNetworkEventChanged) {
      switch (event.connectivityResult){
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
        }// switch
    } // else if

    else {
      // Unknown event received
    } // else
  }// mapEventToState

    @override
  Future<void> close() {
    this._streamSubscription.cancel();
    return super.close();
  }// close
}// DeviceNetworkBloc