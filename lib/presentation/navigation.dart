import 'package:flutter/material.dart';
import 'package:communitytabs/screens/login.dart';

class RouteGenerator {
  Route onGenerateRoute (RouteSettings settings) {
    switch(settings.name) {
      case "/":
        return MaterialPageRoute(
            builder: (_) => Login());
        break;
      default:
        return null;
        break;
    }// switch
  }
}