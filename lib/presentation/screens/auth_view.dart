import 'package:flutter/material.dart';
import 'package:communitytabs/presentation/presentation.dart';

class AuthView extends StatefulWidget {
  final RouteGeneratorAuthentication routeGeneratorAuthentication;

  AuthView({@required this.routeGeneratorAuthentication, Key key}) : super(key: key);
  @override
  _AuthViewState createState() => _AuthViewState();
}// AuthView

class _AuthViewState extends State<AuthView> {
  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      initialRoute: '/login',
      onGenerateRoute: this.widget.routeGeneratorAuthentication.onGenerateRoute,
    );
  }// build

@override
  void dispose() {
    this.widget.routeGeneratorAuthentication.close();
    super.dispose();
  }// dispose
}// _AuthViewState
