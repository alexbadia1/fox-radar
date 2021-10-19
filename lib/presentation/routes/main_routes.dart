import 'package:flutter/material.dart';
import 'package:fox_radar/presentation/presentation.dart';

/// This is the route generator for non-authentication screens:
///   - Home
///   - Account
class RouteGeneratorMain {
  /// Maps each named route to a page route
  /// builder during each navigation, route
  /// settings can be used to pass data between routes.
  Route onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {

      // By convention, "/" is always the index
      case "/":
        return PageRouteBuilder(
          pageBuilder: (context, animation1, animation2) =>
              // Home and account screen are stored in a PageView Widget
              AppPageView(),
        );
        break;

      // The route for the screen that shows everything about the event
      case "/event":

        // Get the route arguments that hold:
        //   - documentId: used to retrieve the full event from firebase
        //   - imageBytes: used to show the events image
        final EventScreenArguments args = settings.arguments;

        return PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) => EventScreen(
              eventId: args.documentId, imageBytes: args.imageBytes),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            var begin = Offset(1.0, 0.0);
            var end = Offset.zero;
            var curve = Curves.ease;

            var tween =
                Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

            return SlideTransition(
              position: animation.drive(tween),
              child: child,
            );
          },
        );
        break;

      // The loading screen while the user is currently being authenticated
      case "/loading":
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: SafeArea(
              child: Container(
                width: double.infinity,
                height: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: <Color>[
                      cWashedRed,
                      cFullRed,
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
        break;

      case "/error":
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            appBar: AppBar(
              title: Text('Error'),
            ),
            body: Center(
              child: Text('ERROR'),
            ),
          ),
        );
        break;

      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            appBar: AppBar(
              title: Text('Error'),
            ),
            body: Center(
              child: Text('ERROR'),
            ),
          ),
        );
    } // switch
  } // onGenerateRoute
}// RouteGenerator
