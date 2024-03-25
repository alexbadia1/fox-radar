import 'package:flutter/material.dart';

class Utils {
  final BuildContext context;

  Utils({required this.context}) : assert (context != null);

  /// Calculated
  double get safeHeight => (this.rawHeight - this.topPadding - this.bottomPadding + this.bottomInsets);

  /// Raw
  double get rawHeight => MediaQuery.of(this.context).size.height;
  double get rawWidth => MediaQuery.of(this.context).size.height;

  /// Padding
  double get topPadding => MediaQuery.of(context).padding.top;
  double get bottomPadding =>  MediaQuery.of(context).padding.bottom;

  /// Insets
  double get bottomInsets => MediaQuery.of(context).viewInsets.bottom;
}// Sizes