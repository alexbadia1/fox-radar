import 'dart:typed_data';
import 'package:flutter/material.dart';

/// Allows the search results data to be passed to the Events
/// Screen, where that data is used to retrieve th full event details.
class EventScreenArguments {
  /// Document ID of the full event in firebase cloud
  final String documentId;

  /// The thumbnail of the event retrieved from firebase storage
  final Uint8List imageBytes;

  EventScreenArguments({@required this.documentId, @required this.imageBytes});
} // EventScreenArguments
