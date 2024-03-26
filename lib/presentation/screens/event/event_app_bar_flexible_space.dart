import 'dart:typed_data';
import 'package:flutter/material.dart';

class EventSliverAppBarFlexibleSpace extends StatelessWidget {

  final Uint8List? imageBytes;

  const EventSliverAppBarFlexibleSpace({this.imageBytes});

  @override
  Widget build(BuildContext context) {

    final screenHeight = MediaQuery.of(context).size.height;
    final screenPaddingBottom = MediaQuery.of(context).padding.bottom;
    final screenInsetsBottom = MediaQuery.of(context).viewInsets.bottom;
    final screenPaddingTop = MediaQuery.of(context).padding.top;

    final height = screenHeight -
        screenPaddingTop -
        screenPaddingBottom +
        screenInsetsBottom;

    if (imageBytes != null) {
      // Event has image
      return Image.memory(this.imageBytes!, fit: BoxFit.cover);
    } else {
      // Event doesn't have image
      return Container(
        width: double.infinity,
        height: height,
      );
    }
  }
}

