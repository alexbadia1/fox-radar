import 'dart:async';
import 'dart:isolate';

import 'package:database_repository/database_repository.dart';

class IsolateWorker {
  /// SendPort used by the main thread to communicate
  /// with the worker isolate [_sendPort.send(dynamic)].
  SendPort _mainSendPort;

  /// SendPort used by the main thread to communicate
  /// with the worker isolate [_sendPort.send(dynamic)].
  Isolate _workerIsolate;

  /// Completer is [complete] when the [isolate] is finished spawning.
  ///
  /// Factory method waits on this to return an [IsolateWorker] instance.
  final _workerReady = Completer<void>();

  /// Completer is [complete] when the [isolate] finishes the [task] given
  Completer<dynamic> _results = Completer<dynamic>();

  /// No public constructor
  ///
  /// Only way to create an object is with the
  /// factory, which performs proper initialization.
  IsolateWorker._instance();

  /// Factory method
  ///
  /// Creates an [IsolateWorker] instance
  /// then, tries to spawn a dart isolate, and
  /// finally returns the [IsolateWorker] instance.
  static Future<IsolateWorker> instance() async {
    IsolateWorker isolateWorker = IsolateWorker._instance();
    await isolateWorker._init();
    return isolateWorker;
  } // instance

  Future<void> _init() async {
    final _mainReceivePort = ReceivePort();
    _mainReceivePort.listen(this._mainMessageHandler);
    this._workerIsolate = await Isolate.spawn(_workerMessageHandler, _mainReceivePort.sendPort);
    final completedFuture = await this._workerReady.future;
    return completedFuture;
  } // init

  dynamic sendMessage(Object msg) async {
    // Send message to begin task
    this._mainSendPort.send(msg);
    final taskCompleted = await this._results.future;
    return taskCompleted;
  }// sendMessage

  static void _workerMessageHandler(dynamic message) {
    SendPort workerSendPort;
    final workerReceivePort = ReceivePort();
    workerReceivePort.listen((dynamic message) {
      print("[Worker Isolate] Message Received!");
      if (message is String) {
        print("[Worker Isolate] $message");
        workerSendPort.send("##$message##");
      }// if
      else if (message is EventModel){
        print("[Worker Isolate] ${message.toString()}");
        workerSendPort.send(message);
      }// else if
    });
    // SendPort received from main isolate
    if (message is SendPort) {
      print("[Worker Isolate] Received Main Isolate Send Port!");
      workerSendPort = message;
      workerSendPort.send(workerReceivePort.sendPort);
      return;
    } // if
  } // _workerMessageHandler

  void _mainMessageHandler(dynamic message) {
    print("[Main Isolate] Message Received!");
    // SendPort from worker isolate
    if (message is SendPort) {
      this._mainSendPort = message;
      this._workerReady.complete(); // Worker isolate is ready
      print("[Main Isolate] Received Worker Isolate Send Port!");
      return;
    } // if
    else if (message is String){
      print("[Main Isolate] $message");
      _results?.complete(message);
    }// else if
    else if (message is EventModel){
      print("[Main Isolate] ${message.toString()}");
      _results?.complete(message);
    }// else if
  } // _mainMessageHandler

  // Tear down other isolate
  void dispose() {
    this._workerIsolate.kill();
  } // dispose
} // IsolateWorker

/// Wrapper class for data sent from isolate
///
/// This may not be necessary, we'll see.
class IsolateResponse {
  final dynamic data;

  IsolateResponse(this.data);
}// IsolateResponse
