import 'dart:typed_data';
import 'package:flutter/material.dart';

class EventScreenArguments {
  final String documentId;
  final Uint8List imageBytes;

  EventScreenArguments({@required this.documentId, @required this.imageBytes});

}// EventScreenArguments