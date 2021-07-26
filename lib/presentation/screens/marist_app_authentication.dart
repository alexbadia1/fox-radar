import 'package:flutter/material.dart';
import 'package:communitytabs/presentation/presentation.dart';

class MaristAppAuthentication extends StatefulWidget {
  final RouteGeneratorAuthentication routeGeneratorAuthentication;

  MaristAppAuthentication({@required this.routeGeneratorAuthentication, Key key}) : super(key: key);
  @override
  _MaristAppAuthenticationState createState() => _MaristAppAuthenticationState();
}// MaristAppAuthentication

class _MaristAppAuthenticationState extends State<MaristAppAuthentication> {
  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      onGenerateRoute: this.widget.routeGeneratorAuthentication.onGenerateRoute,
      initialRoute: '/login',
    );
  }// build

@override
  void dispose() {
    this.widget.routeGeneratorAuthentication.close();
    super.dispose();
  }// dispose
}// _MaristAppAuthenticationState
