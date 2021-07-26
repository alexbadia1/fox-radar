import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:communitytabs/logic/logic.dart';

class EventScreenArguments {
  final String documentId;
  final Uint8List imageBytes;

  EventScreenArguments({@required this.documentId, @required this.imageBytes});

}// EventScreenArguments

class AccountScreenArguments {
  final HomePageViewCubit homePageViewCubit;

  AccountScreenArguments({@required this.homePageViewCubit}) : assert (homePageViewCubit != null);
}// AccountScreenArguments