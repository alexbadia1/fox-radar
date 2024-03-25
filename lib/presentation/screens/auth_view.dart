import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fox_radar/presentation/presentation.dart';

class AuthView extends StatefulWidget {
  final RouteGeneratorAuthentication routeGeneratorAuthentication;

  AuthView({required this.routeGeneratorAuthentication, Key? key}) : super(key: key);
  @override
  _AuthViewState createState() => _AuthViewState();
}// AuthView

class _AuthViewState extends State<AuthView> {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
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
