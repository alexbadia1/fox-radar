import 'package:flutter/material.dart';

/// Margins
///
/// Horizontal Margins
SizedBox cLeftMarginSmall(context) {
  return SizedBox(width: MediaQuery.of(context).size.width * .05);
}// cLeftMarginSmall

SizedBox cLeftMarginMedium(context) {
  return SizedBox(width: MediaQuery.of(context).size.width * .1);
}// cLeftMarginMedium

SizedBox cRightMarginSmall(context) {
  return SizedBox(width: MediaQuery.of(context).size.width * .05);
}// cRightMarginSmall

/// Vertical Margins
SizedBox cVerticalMarginSmall(context) {
  return SizedBox(height: MediaQuery.of(context).size.height * .05);
}// cVerticalMarginSmall
