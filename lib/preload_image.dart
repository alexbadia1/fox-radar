import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/services.dart';

Future<void> loadImage({ImageProvider? imageProvider, double? devicePixelRatio}) {
  final config = ImageConfiguration(
    bundle: rootBundle,
    devicePixelRatio: devicePixelRatio,
    platform: defaultTargetPlatform,
  );

  final Completer<void> completer = Completer();
  final ImageStream stream = imageProvider!.resolve(config);

  ImageStreamListener? listener;

  listener = ImageStreamListener((ImageInfo image, bool sync) {
    debugPrint("Image ${image.debugLabel} finished loading");
    completer.complete();
    stream.removeListener(listener!);
  }, onError: (exception, stackTrace) {
    completer.complete();
    stream.removeListener(listener!);
    FlutterError.reportError(
      FlutterErrorDetails(
        context: ErrorDescription('Image failed to load'),
        library: 'image resource service',
        exception: exception,
        stack: stackTrace,

        /// Ignore the error in release mode
        silent: true,
      ),
    );
  });

  // Listen and wait for
  stream.addListener(listener);
  return completer.future;
}
