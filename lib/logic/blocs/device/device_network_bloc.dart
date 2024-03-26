import 'dart:async';
import 'package:fox_radar/logic/logic.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class DeviceNetworkBloc extends Bloc<DeviceNetworkEvent, DeviceNetworkState> {
  final Connectivity _connectivity = Connectivity();
  // Subscription used to monitor th devices network connectivity state
  late StreamSubscription _streamSubscription;

  DeviceNetworkBloc() : super(DeviceNetworkStateUnknown()) {
    on<DeviceNetworkEventChanged>((event, emit) {
      switch (event.connectivityResult) {
        case ConnectivityResult.wifi:
          emit(DeviceNetworkStateWifi());
          break;
        case ConnectivityResult.mobile:
          emit(DeviceNetworkStateMobile());
          break;
        case ConnectivityResult.none:
          emit(DeviceNetworkStateNone());
          break;
        default:
          emit(DeviceNetworkStateNone());
          break;
      }
    });
    on<DeviceNetworkEventListen>((event, emit) async {
      _streamSubscription = _connectivity.onConnectivityChanged
          .listen((ConnectivityResult result) {
        this.add(DeviceNetworkEventChanged(result));
      });

      // Stream only fires on change, so must check for initial state
      if (state is DeviceNetworkStateUnknown) {
        final ConnectivityResult _connectivityResult =
            await _connectivity.checkConnectivity();
        this.add(DeviceNetworkEventChanged(_connectivityResult));
      }
    });
  }

  @override
  void onChange(Change<DeviceNetworkState> change) {
    print("[Device Network Bloc] $change");
    super.onChange(change);
  }

  @override
  Future<void> close() {
    this._streamSubscription.cancel();
    return super.close();
  }
}
