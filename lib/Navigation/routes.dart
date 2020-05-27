import 'package:communitytabs/Screens/eventDetails.dart';
import 'package:communitytabs/Screens/index.dart';
import 'package:communitytabs/Screens/loading.dart';
import 'package:communitytabs/Screens/login.dart';
import 'package:communitytabs/Screens/signUp.dart';
import 'package:communitytabs/Screens/wrapper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {

    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (context) => Wrapper());
        break;
      case '/home':
        return MaterialPageRoute(builder: (context) => HomePage());
        break;
      case '/login':
        return MaterialPageRoute(builder: (context) => Login());
        break;
      case '/signUp':
        return MaterialPageRoute(builder: (context) => SignUp());
        break;
      case '/loading':
        return MaterialPageRoute(builder: (context) => LoadingScreen());
        break;
      case '/eventDetails':
        return MaterialPageRoute(builder: (context) => EventDetails());
        break;
      default:
        return _errorRoute();
        break;
    } //switch
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(builder: (context) {
      return Scaffold(
          appBar: AppBar(
            title: Text('Error'),
          ),
          body: Center(
            child: Text('ERROR'),
          ));
    });
  }
}